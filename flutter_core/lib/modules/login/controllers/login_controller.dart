import 'dart:async';

import 'package:fk_photos/fk_photos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aimall_face_recognition/flutter_aimall_face_recognition.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/auth_apis.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/common/constants.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/i18n/i18n.dart';
import 'package:flutter_ucore/modules/login/views/widgets/register_mode_widget.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/services/config_service.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/utils/app_utils.dart';
import 'package:flutter_ucore/utils/net_captcha_utils.dart';
// import 'package:get/get.dart';

class LoginController extends GetxController {
  static const LOGIN_LANGUAGE_ID = 0x01;

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  final loginButtonStatus = false.obs;

  StreamSubscription? _languageSub;
  late SilentLivingResponse livingResult;

  @override
  void onInit() {
    super.onInit();
    NetCaptchaUtils.setNetCaptcha();
    _languageSub = LocalService.to.languageObservable.listen((_) {
      update([LOGIN_LANGUAGE_ID]);
    });
    String markstr = Get.arguments ?? "";
    if (markstr == '1') {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        showRegisterMode(Get.context!, () {
          fetchIsHaveFace(false);
        });
      });
    }
  }

  ///注册方式
  void showRegisterMode(BuildContext context, GestureTapCallback tapCallback) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Container(
            height: 228,
            width: 1.sw * 0.872,
            decoration: BoxDecoration(
              color: Colours.primary_bg,
              borderRadius: BorderRadius.circular(8.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: RegisterMode(
              onMail: () {
                Navigator.pop(context);
                Get.toNamed(Routes.USER_EMAIL_REGISTER);
              },
              onFace: () {
                Navigator.pop(context);
                tapCallback(); //点击回调
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void onReady() async {
    super.onReady();

    /// 监听输入框数值
    userNameController.addListener(_changeLoginButtonStatus);
    passwordController.addListener(_changeLoginButtonStatus);

    userNameController.text =
        StorageUtils.sp.read<String>(Constants.lastAccount) ?? '';
  }

  void _changeLoginButtonStatus() {
    loginButtonStatus.value = userNameController.text.length >= 6 &&
        passwordController.text.length >= 6;
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
    Toast.showLoading();
    final result = await AuthApi.authUserLogin(
      account: userNameController.text,
      neCaptchaValidate: captcha,
      password: passwordController.text,
    );
    Toast.hideLoading();

    /// 成功
    if (result.code == 0 && result.data != null) {
      await AuthService.to.updateUser(result.data!);
      await StorageUtils.sp.write(
        Constants.lastAccount,
        userNameController.text,
      );
      Get.back();
    } else {
      Toast.showError(result.message ?? I18nKeys.login_failed_please_try_again);
    }
  }

  @override
  void onClose() {
    _languageSub?.cancel();
    userNameController.dispose();
    passwordController.dispose();
    userNameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  //刷脸登录
  Future<void> fetchIsHaveFace(bool isLogin) async {
    //获取手机权限 TODO
    // if (!await OtherUtils.requestNecessaryPermission(view.getContext())) {
    //   return;
    // }
    final silentLivingResult = await slientLiving(isLogin);
    if (silentLivingResult == null) {
      return null;
    }
    if (silentLivingResult.image == null) {
      return null;
    }
    livingResult = silentLivingResult;
    if (isLogin) {
      await Get.toNamed(Routes.USER_FACE_LOGIN);
      //人脸人脸页面pop判断是否已经登录，如果已经登录，则pop登录页面
      if (AuthService.to.isLoggedInValue) {
        Get.back();
      }
    } else {
      final String fileBase64 = await livingResult.image!.toBase64();
      final result =
          await UserApi.userFaceSearch(suffixName: 'jpg', image: fileBase64);
      print('1111-------------------$result---');
      if (result.code == 0) {
        Get.toNamed(Routes.USER_FACE_REGISTER);
        print('2222----------------------');
        return;
      } else if (result.code == 7023) {
        print('3333----------------------');
        Toast.showError(I18nKeys.already_registered);
        return;
      } else {
        Toast.showError(I18nKeys.face_recognition_failed);
      }
    }
  }

  /// 静默活体识别
  Future<SilentLivingResponse?> slientLiving(bool isLogin) async {
    try {
      final String languageValue = RealNameGetLanguage.language;

      /// 初始化爱莫
      await FlutterAimallFaceRecognition.initImoSDK(
          ConfigService.to.imoKey, languageValue);

      /// 识别
      return await FlutterAimallFaceRecognition.silentLiving(
        userName: '',
        isRegister: !isLogin,
      );
    } catch (e) {
      return null;
    }
  }
}
