import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/modules/property/controllers/property_controller.dart';
import 'package:flutter_wallet/modules/settings/security/controller/restore_settings_controller.dart';
import 'package:flutter_wallet/modules/settings/security/widgets/restore_settings_modal.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/security_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:local_auth/error_codes.dart' as local_auth_error_codes;

class SettingsSecuritController extends GetxController {
  final _restoreController = Get.put(RestoreSettingsController());

  final payStatus = false.obs;
  final loginStatus = false.obs;

  bool canBiometrics = true;
  String payTitle = I18nKeys.payWithFingerprint;
  String loginTitle = I18nKeys.logInWithFingerprint;

  ///恢复初始设置弹窗
  ///index 1 支付，2登录
  void operationBiometrics(bool open, int index) {
    if (open) {
      UniModals.showVerifySecurityPasswordModal(
          onSuccess: () {},
          onPasswordGet: (password) {
            _saveStatus(open, index, password);
          });
    } else {
      _saveStatus(open, index, null);
    }
  }

  Future<void> _saveStatus(bool open, int index, String? password) async {
    try {
      bool authenticate = await SecurityService.to
          .authenticate(localizedReason: index == 1 ? payTitle : loginTitle);
      if (!authenticate) {
        //Get.showTopBanner(I18nKeys.thePhoneHasNoFingerprintFunction,  style: TopBannerStyle.Error);
        return;
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case local_auth_error_codes.notEnrolled:
          Get.showTopBanner(I18nKeys.recognitionFailed,
              style: TopBannerStyle.Error);
          return;
        case local_auth_error_codes.notAvailable:
          // 不支持生物识别
          Get.showTopBanner(I18nKeys.thePhoneHasNoFingerprintFunction,
              style: TopBannerStyle.Error);
          return;
        case local_auth_error_codes.lockedOut:
          // 由于尝试次数过多而导致API锁定
          Get.showTopBanner(I18nKeys.identifyExceptions,
              style: TopBannerStyle.Error);
          return;
        case local_auth_error_codes.permanentlyLockedOut:
          // 由于锁定过多而禁用的API
          Get.showTopBanner(I18nKeys.identifyExceptions,
              style: TopBannerStyle.Error);
          return;
        default:
          break;
      }
    }

    if (index == 1) {
      await SecurityService.to.setSecurityPassword(
          password ?? SecurityService.to.getPassword(),
          original: open);
      await SecurityService.to.setBiometryPay(open ? true : false);
      payStatus.value = await SecurityService.to.isOpenBiometryPay;
    } else {
      await SecurityService.to.setBiometryLogin(open ? true : false);
      loginStatus.value = await SecurityService.to.isOpenBiometryLogin;
    }
  }

  ///恢复初始设置弹窗
  void showRestoreSettingsModal() {
    late List<Map> optionsList = _restoreController.getOptionList();
    print("optionsList $optionsList");
    Get.bottomSheet((RestoreSettingsModal(
      title: I18nKeys.restoreInitialSettings,
      optionList: optionsList,
      selectedCallback: () {
        //隐退弹窗
        Get.back();
        _cleanWalletDB();
        //退出当前页面
        Get.back();
      },
    )));
  }

  ///删除数据
  Future<void> _cleanWalletDB() async {
    WalletService.service.currentCoin = null;
    Get.find<PropertyController>().update();
    StorageUtils.sp.delete('currentCoin');
    StorageUtils.sp.write('recordTime', DateTime.now().millisecondsSinceEpoch);
    DBService.to.db.wipeData();
    SecurityService.to.cleanPassword();
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();

    /// iOS 通过机型， 安卓默认 指纹
    if (DeviceUtils.isIos) {
      List<BiometricType> availableBiometrics =
          (await SecurityService.to.getAvailableBiometrics);
      if (availableBiometrics.contains(BiometricType.face)) {
        payTitle = I18nKeys.payWithFace;
        loginTitle = I18nKeys.loginWithFace;
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        payTitle = I18nKeys.payWithFingerprint;
        loginTitle = I18nKeys.logInWithFingerprint;
      }
    }

    payStatus.value = await SecurityService.to.isOpenBiometryPay;

    loginStatus.value = await SecurityService.to.isOpenBiometryLogin;

    canBiometrics = (await SecurityService.to.canCheckBiometrics);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    print("object onClose");
  }
}
