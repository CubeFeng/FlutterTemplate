import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/utils/app_utils.dart';
import 'package:flutter_ucore/utils/net_captcha_utils.dart';
import 'package:flutter_ucore/utils/regular_util.dart';
// import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final userNameController = TextEditingController();
  final authCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPwdController = TextEditingController();
  final userNameNode = FocusNode();
  final authCodeNode = FocusNode();
  final passwordNode = FocusNode();
  final repeatPwdNode = FocusNode();

  final submitButtonStatus = false.obs;

  final repeatPwdError = false.obs;

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
    passwordController.addListener(_changeButtonStatus);
    repeatPwdController.addListener(_changeButtonStatus);
    authCodeController..addListener(_changeButtonStatus);
  }

  void _changeButtonStatus() {
    submitButtonStatus.value = userNameController.text.isNotEmpty &&
        authCodeController.text.isNotEmpty &&
        RegularUtils.isPasswordLegal(passwordController.text) &&
        repeatPwdController.text == passwordController.text;

    repeatPwdError.value = passwordController.text.isNotEmpty &&
        repeatPwdController.text.isNotEmpty &&
        repeatPwdController.text != passwordController.text;
  }

  //todo 报验证码错误
  void toRest() async {
    AppUtils.hideKeyboard();

    Toast.showLoading();
    final result = await UserApi.userFindUserPwd(
        account: userNameController.text,
        captcha: authCodeController.text,
        captchaKey: captchaKey,
        password: passwordController.text);
    Toast.hideLoading();

    /// 成功
    if (result.code == 0 && result.data != null) {
      Get.back();
    } else {
      Toast.showError(result.message ?? I18nKeys.failed_to_reset_password_please_try_again);
    }
  }

  ///获取邮箱验证码
  Future<bool> getVCode() async {
    final Completer<bool> completer = Completer<bool>();
    if (RegularUtils.isEmailLegal(userNameController.text)) {
      Toast.showLoading();
      final result = await UserApi.userRegisterCaptchaEmail(email: userNameController.text, type: 2);
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
