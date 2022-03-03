import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/utils/app_utils.dart';
import 'package:flutter_ucore/utils/net_captcha_utils.dart';
import 'package:flutter_ucore/utils/regular_util.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';
// import 'package:get/get.dart';

class RegisterController extends GetxController {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final authCodeController = TextEditingController();
  final inviteCodeController = TextEditingController();

  final userNameNode = FocusNode();
  final passwordNode = FocusNode();
  final authCodeNode = FocusNode();
  final inviteCodeNode = FocusNode();

  final registerButtonStatus = false.obs;

  final agreeProtocolStatus = true.obs;

  String? captchaKey;

  @override
  void onInit() {
    super.onInit();
    NetCaptchaUtils.setNetCaptcha();
  }

  @override
  void onReady() async {
    super.onReady();

    /// 监听输入框数值
    userNameController.addListener(_changeButtonStatus);
    authCodeController.addListener(_changeButtonStatus);
    passwordController.addListener(_changeButtonStatus);
  }

  void _changeButtonStatus() {
    registerButtonStatus.value = userNameController.text.length > 5 &&
        userNameController.text.length < 33 &&
        authCodeController.text.isNotEmpty &&
        RegularUtils.isPasswordLegal(passwordController.text);
  }

  //todo 报验证码失效
  void toRegister() async {
    AppUtils.hideKeyboard();

    if (!agreeProtocolStatus.value) {
      Toast.show(I18nKeys.please_agree_users_protocol);
      return;
    }
    var captcha = '';
    try {
      captcha = await NetCaptchaUtils.showNetCaptcha();
    } catch (e) {
      Toast.showError(I18nKeys.verification_code_error);
      return;
    }
    Toast.showLoading();
    final result = await UserApi.userRegister(
      neCaptchaValidate: captcha,
      email: userNameController.text,
      password: passwordController.text,
      captcha: authCodeController.text,
      captchaKey: captchaKey ?? '',
      commendCode: inviteCodeController.text,
      type: 3,
    );
    Toast.hideLoading();

    /// 成功
    if (result.code == 0) {
      final result = await _showSuccessPage();
      if (result != null) {
        Get.back(result: userNameController.text);
      }
    } else {
      Toast.showError(
          result.message ?? I18nKeys.registration_failed_please_try_again);
    }
  }

  Future _showSuccessPage() {
    return showGeneralDialog(
      context: Get.context!,
      barrierLabel: I18nKeys.hello,
      barrierDismissible: true,
      barrierColor: Colors.white,
      // 添加这个属性是颜色

      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          appBar: UCoreAppBar(
            title: Text(I18nKeys.registration_success,
                textAlign: TextAlign.center),
            leading: IconButton(
              icon: LoadAssetImage(
                "common/icon_arrow_left",
                color: Get.isDarkMode ? Colors.white : null,
              ),
              color: Colors.grey,
              onPressed: () {
                Get.back();
                Get.back(result: userNameController.text);
              },
            ),
            elevation: 0,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.sp, vertical: 120.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LoadAssetImage('load/icon_load_success'),
                Gaps.vGap20,
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: UCoreButton(
                      onPressed: () {
                        Get.back();
                        Get.back(result: userNameController.text);
                      },
                      text: I18nKeys.to_login),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  ///获取邮箱验证码
  Future<bool> getVCode() async {
    final Completer<bool> completer = Completer<bool>();
    if (RegularUtils.isEmailLegal(userNameController.text)) {
      Toast.showLoading();
      final result = await UserApi.userRegisterCaptchaEmail(
          email: userNameController.text, type: 1);
      Toast.hideLoading();
      if (result.code == 0 && result.data != null) {
        captchaKey = result.data;
        Toast.show(I18nKeys.captcha_has_been_sent);
        completer.complete(true);
      } else {
        Toast.show(result.message ?? '');
        completer.complete(false);
      }
    } else {
      Toast.show(I18nKeys.please_enter_correct_email);
      completer.complete(false);
    }

    return completer.future;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
