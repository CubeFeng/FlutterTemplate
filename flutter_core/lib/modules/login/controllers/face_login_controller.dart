import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/auth_apis.dart';
import 'package:flutter_ucore/common/constants.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/login/controllers/login_controller.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/utils/app_utils.dart';
import 'package:flutter_ucore/utils/net_captcha_utils.dart';
import 'package:fk_photos/fk_photos.dart';
// import 'package:get/get.dart';

///人脸登录2-绑定账号
class FaceLoginController extends GetxController {
  final userNameController = TextEditingController();

  final userNameNode = FocusNode();

  final loginButtonStatus = false.obs;

  final facePicPath = 'drawer/icon_user_header'.obs;

  @override
  void onInit() {
    super.onInit();
    NetCaptchaUtils.setNetCaptcha();
  }

  @override
  void onReady() async {
    super.onReady();

    /// 监听输入框数值
    userNameController.addListener(_changeLoginButtonStatus);
    userNameController.text = StorageUtils.sp.read<String>(Constants.lastFaceAccount) ?? '';
  }

  void _changeLoginButtonStatus() {
    loginButtonStatus.value = userNameController.text.length > 5;
  }

  void toLogin() async {
    AppUtils.hideKeyboard();

    var captcha = '';
    try {
      captcha = await NetCaptchaUtils.showNetCaptcha();
    } catch (e) {
      Toast.showError(I18nKeys.verification_code_error);

      return;
    }
    final LoginController loginCon = Get.find();
    if (loginCon.livingResult.image == null) {
      return;
    }
    final String fileBase64 = await loginCon.livingResult.image!.toBase64();
    Toast.showLoading();
    final result = await AuthApi.authUserLogin(
        account: userNameController.text,
        neCaptchaValidate: captcha,
        image: fileBase64,
        faceToken: loginCon.livingResult.faceToken,
        type: 1);
    Toast.hideLoading();

    /// 成功
    if (result.code == 0 && result.data != null) {
      await AuthService.to.updateUser(result.data!);
      await StorageUtils.sp.write(Constants.lastFaceAccount, userNameController.text);
      // 刷脸登录成功，退回登录页面，登录页面需要判断是否已经登录
      // 如果已经登录，则需要pop登录页面
      Get.back();
    } else {
      Toast.showError(result.message ?? I18nKeys.login_failed_please_try_again);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
