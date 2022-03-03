import 'package:fk_photos/fk_photos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/login/controllers/login_controller.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/utils/app_utils.dart';
import 'package:flutter_ucore/utils/net_captcha_utils.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';
// import 'package:get/get.dart';

///人脸注册2-资料填写
class FaceRegisterController extends GetxController {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPwdController = TextEditingController();
  final inviteCodeController = TextEditingController();

  final userNameNode = FocusNode();
  final passwordNode = FocusNode();
  final repeatPwdNode = FocusNode();
  final inviteCodeNode = FocusNode();

  final registerButtonStatus = false.obs;

  final agreeProtocolStatus = true.obs;

  final userNameInputError = false.obs;

  final passwordInputError = false.obs;

  final repeatPwdInputError = false.obs;

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
    userNameController.addListener(_changeButtonStatus);
    passwordController.addListener(_changeButtonStatus);
    repeatPwdController.addListener(_changeButtonStatus);
  }

  void _changeButtonStatus() {
    registerButtonStatus.value = userNameController.text.length > 5 &&
        userNameController.text.length < 33 &&
        passwordController.text.length > 7 &&
        passwordController.text.length < 13 &&
        repeatPwdController.text == passwordController.text;

    userNameInputError.value = userNameController.text.isNotEmpty &&
        (userNameController.text.length < 6 ||
            userNameController.text.length > 32);
    passwordInputError.value = passwordController.text.isNotEmpty &&
        (passwordController.text.length < 8 ||
            passwordController.text.length > 12);
    repeatPwdInputError.value = repeatPwdController.text.isNotEmpty &&
        repeatPwdController.text != passwordController.text;
  }

  void toRegister() async {
    AppUtils.hideKeyboard();
    var captcha = '';
    try {
      captcha = await NetCaptchaUtils.showNetCaptcha();
    } catch (e) {
      Toast.showError(I18nKeys.verification_code_error);
      return;
    }

    Toast.showLoading();

    final LoginController loginCon = Get.find();
    if (loginCon.livingResult.image == null) {
      return;
    }
    final String fileBase64 = await loginCon.livingResult.image!.toBase64();

    final result = await UserApi.userFaceRegister(
      account: userNameController.text,
      password: passwordController.text,
      commendCode: inviteCodeController.text,
      image: fileBase64,
      suffixName: 'jpg',
    );
    Toast.hideLoading();

    /// 成功
    if (result.code == 0 && result.data != null) {
      final result = await _showSuccessPage();
      if (result != null) {
        Get.back(result: userNameController.text);
      }
    } else {
      Toast.showError(
          result.message ?? I18nKeys.registration_failed_please_try_again);
    }
  }

  @override
  void onClose() {
    super.onClose();
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
                color: Get.isDarkMode ? Colors.white : Colors.black45,
              ),
              color: Colors.grey,
              onPressed: () {
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
                      Get.back(result: userNameController.text);
                    },
                    text: I18nKeys.to_login,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
