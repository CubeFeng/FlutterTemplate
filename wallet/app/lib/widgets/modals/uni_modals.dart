import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/services/security_service.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:get/get.dart';
import 'package:local_auth/error_codes.dart' as local_auth_error_codes;

part 'not_set_password_prompt_modal.dart';

part 'qi_general_prompt_modal.dart';

part 'single_action_prompt_modal.dart';

part 'single_text_field_modal.dart';

part 'transaction_amount_clear_modal.dart';

part 'verify_security_password_modal.dart';

part 'import_modal.dart';

part 'solana_input_modal.dart';

typedef PasswordCallback = dynamic Function(String password);

typedef InputCallback = dynamic Function(
    String contractAddress, String address);

/// 应用内通用模态框
class UniModals {
  UniModals._();

  /// 显示未设置密码提示模态框
  static void showNotSetPasswordPromptModal({
    Key? key,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
    WillPopCallback? onBackPress,
  }) {
    final child = _NotSetPasswordPromptModal(
      key: key,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
    Get.dialog(
      onBackPress == null
          ? child
          : WillPopScope(onWillPop: onBackPress, child: child),
      barrierDismissible: barrierDismissible,
    );
  }

  static void showImportModal({
    Key? key,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
    WillPopCallback? onBackPress,
  }) {
    final child = _ImportModal(
      key: key,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
    Get.dialog(
      onBackPress == null
          ? child
          : WillPopScope(
              onWillPop: onBackPress,
              child: child,
            ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// 转账页面点击全部转账提示模态框
  static void showAmountClearModal({
    Key? key,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    Get.dialog(_AmountClearModal(
      key: key,
      onConfirm: onConfirm,
      onCancel: onCancel,
    ));
  }

  /// 显示验证安全密码模态框
  ///
  /// [originalPassword]，是否比较密文密码
  ///
  /// [securityPasswordOnly]，为`true`时只有安全密码，没有生物识别，默认`true`
  ///
  /// [switchPasswordAuto]，为`true`时指纹验证失败自动切换到安全密码验证，默认`true`
  static void showSolInputModal({
    InputCallback? onPasswordGet,
    Text? title,
    Text? confirm,
    String? hintText,
    bool? showSecond,
  }) {
    Get.bottomSheet(
      SolanaInputModal(
        title: title ?? Text(I18nKeys.verifyPassword),
        confirm: confirm ?? Text(I18nKeys.confirm),
        showSecond: showSecond,
        onConfirm: (one, two) {
          Get.back();
          if (onPasswordGet != null) {
            onPasswordGet(one, two);
          }
        },
      ),
      backgroundColor: Colors.transparent,
    );
  }

  /// 显示验证安全密码模态框
  ///
  /// [originalPassword]，是否比较密文密码
  ///
  /// [securityPasswordOnly]，为`true`时只有安全密码，没有生物识别，默认`true`
  ///
  /// [switchPasswordAuto]，为`true`时指纹验证失败自动切换到安全密码验证，默认`true`
  static void showVerifySecurityPasswordModal({
    required VoidCallback onSuccess,
    VoidCallback? onFailure,
    PasswordCallback? onPasswordGet,
    Text? title,
    Text? confirm,
    String? hintText,
    bool originalPassword = false,
    bool passwordAuthOnly = true,
    bool switchPasswordAuto = true,
    bool verifyPassword = true,
  }) {
    void showPasswordAuthModal() {
      Get.bottomSheet(
        _VerifySecurityPasswordModal(
          title: title ?? Text(I18nKeys.verifyPassword),
          hintText: hintText ?? I18nKeys.enterWalletPwd,
          confirm: confirm ?? Text(I18nKeys.confirm),
          onConfirm: (password) {
            bool isCorrect = true;
            if (verifyPassword) {
              isCorrect = SecurityService.to.verifySecurityPassword(
                password,
                original: originalPassword,
              );
            }
            if (isCorrect) {
              Get.back();
              onSuccess();
              if (onPasswordGet != null) {
                onPasswordGet(password);
              }
            } else {
              if (onFailure == null) {
                Get.showTopBanner(I18nKeys.walletPasswordError,
                    style: TopBannerStyle.Error);
              } else {
                onFailure();
              }
            }
          },
        ),
        backgroundColor: Colors.transparent,
      );
    }

    void showBiometricAuthModal() async {
      try {
        final result = await SecurityService.to.authenticate(
          localizedReason:
              (title ?? Text(I18nKeys.verifyPassword)).data ?? I18nKeys.unlock,
        );
        if (!result) {
          // 生物识别失败
          if (switchPasswordAuto) {
            showPasswordAuthModal();
          } else {
            if (onFailure == null) {
              Get.showTopBanner(I18nKeys.recognitionFailed,
                  style: TopBannerStyle.Error);
            } else {
              onFailure();
            }
          }
        } else {
          // 生物识别成功
          onSuccess();
          if (onPasswordGet != null) {
            onPasswordGet(SecurityService.to.getPassword());
          }
        }
      } on PlatformException catch (e) {
        if (switchPasswordAuto) {
          showPasswordAuthModal();
        } else {
          if (onFailure == null) {
            Get.showTopBanner(I18nKeys.identifyExceptions,
                style: TopBannerStyle.Error);
          } else {
            onFailure();
          }
        }
        switch (e.code) {
          case local_auth_error_codes.notEnrolled:
            // 未在设备上注册任何指纹
            showPasswordAuthModal();
            break;
          case local_auth_error_codes.notAvailable:
            // 不支持生物识别
            showPasswordAuthModal();
            break;
          case local_auth_error_codes.lockedOut:
            // 由于尝试次数过多而导致API锁定
            showPasswordAuthModal();
            break;
          case local_auth_error_codes.permanentlyLockedOut:
            // 由于锁定过多而禁用的API
            showPasswordAuthModal();
            break;
          default:
            showPasswordAuthModal();
            break;
        }
      }
    }

    if (passwordAuthOnly) {
      showPasswordAuthModal();
    } else {
      showBiometricAuthModal();
    }
  }

  /// 显示单一动作提示模态框
  static void showSingleActionPromptModal({
    Key? key,
    required Widget icon,
    required Widget title,
    required Widget message,
    required Widget action,
    UniButtonStyle actionStyle = UniButtonStyle.PrimaryLight,
    bool? showCloseIcon,
    VoidCallback? onAction,
    double? width,
    bool barrierDismissible = true,
    bool cancelable = true,
  }) {
    Get.dialog(
      _SingleActionPromptModal(
        icon: icon,
        title: title,
        message: message,
        action: action,
        actionStyle: actionStyle,
        showCloseIcon: showCloseIcon,
        onAction: onAction,
        width: width,
        cancelable: cancelable,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// 显示通用单一动作提示模态框
  static void showGeneralSingleActionPromptModal({
    Key? key,
    required Widget message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String? actionTitle,
    Widget? image,
    bool barrierDismissible = true,
    WillPopCallback? onBackPress,
  }) {
    final child = _GeneralBaseActionPromptModal(
      message: message,
      onConfirm: onConfirm,
      onCancel: onCancel,
      actionTitle: actionTitle,
      image: image,
    );
    Get.dialog(
      onBackPress == null
          ? child
          : WillPopScope(onWillPop: onBackPress, child: child),
      barrierDismissible: barrierDismissible,
    );
  }

  /// 显示单一文本输入模态框
  static void showSingleTextFieldModal({
    required Widget title,
    required Function(String) onConfirm,
    VoidCallback? onCancel,
    Widget? confirm,
    Widget? cancel,
    String? initialText,
    String? hintText,
    bool? obscureText,
  }) {
    Get.bottomSheet(
      _SingleTextFieldModal(
        title: title,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirm: confirm,
        cancel: cancel,
        initialText: initialText,
        hintText: hintText,
        obscureText: obscureText,
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
