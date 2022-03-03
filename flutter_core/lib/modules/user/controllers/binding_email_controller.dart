import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/my_binding_controller.dart';
import 'package:flutter_ucore/utils/app_utils.dart';
import 'package:flutter_ucore/utils/net_captcha_utils.dart';
import 'package:flutter_ucore/utils/regular_util.dart';
// import 'package:get/get.dart';

class BindingEmailController extends GetxController {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController authCodeController = TextEditingController();

  final FocusNode userNameNode = FocusNode();
  final FocusNode authCodeNode = FocusNode();

  final submitButtonStatus = false.obs;

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
  }

  void _changeButtonStatus() {
    submitButtonStatus.value = userNameController.text.isNotEmpty && authCodeController.text.isNotEmpty;
  }

  // todo 验证码已失效
  void toBinding() async {
    AppUtils.hideKeyboard();

    Toast.showLoading();
    final result = await UserApi.userSaveUserBand(
        email: userNameController.text, captcha: authCodeController.text, captchaKey: captchaKey);
    Toast.hideLoading();
    final MyBindingController myBinding = Get.find();

    /// 成功
    if (result.code == 0 && result.data != null) {
      Toast.show(I18nKeys.email_binding_successful);
      myBinding.getUserBindingData();
      Get.back();
    } else {
      Toast.showError(result.message ?? I18nKeys.bind_failed_retry);
    }
  }

  ///获取邮箱验证码
  Future<bool> getVCode() async {
    final Completer<bool> completer = Completer<bool>();
    if (RegularUtils.isEmailLegal(userNameController.text)) {
      Toast.showLoading();
      final result = await UserApi.userRegisterCaptchaEmail(email: userNameController.text, type: 3);
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
