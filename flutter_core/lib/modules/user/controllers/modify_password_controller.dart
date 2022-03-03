import 'package:flutter/material.dart';
import 'package:flutter_base_kit/widgets/toast.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/utils/regular_util.dart';
import 'package:get/get.dart';

class ModifyPasswordController extends GetxController {
  final TextEditingController oldController = TextEditingController();
  final FocusNode oldNode = FocusNode();

  final TextEditingController newController = TextEditingController();
  final FocusNode newNode = FocusNode();

  final TextEditingController repeatController = TextEditingController();
  final FocusNode repeatNode = FocusNode();

  final submitButtonStatus = false.obs;
  final repeatPwdError = false.obs;

  @override
  void onInit() async {
    super.onInit();

    oldController.addListener(_changeButtonStatus);

    newController.addListener(_changeButtonStatus);

    repeatController.addListener(_changeButtonStatus);
  }

  void _changeButtonStatus() {
    submitButtonStatus.value = oldController.text.isNotEmpty &&
        RegularUtils.isPasswordLegal(newController.text) &&
        repeatController.text == newController.text;

    repeatPwdError.value = newController.text.isNotEmpty &&
        repeatController.text.isNotEmpty &&
        repeatController.text != newController.text;
  }

  @override
  void onReady() async {
    super.onReady();
  }

  //todo 新密碼不能與原密碼一樣
  void toModify() async {
    Toast.showLoading();
    final result = await UserApi.userResetUserPwd(
      passwordOld: oldController.text,
      passwordNew: newController.text,
    );
    Toast.hideLoading();
    if (result.code == 0 && result.data != null) {
      Toast.show(I18nKeys.successfully_modified);
      AuthService.to.logout();
      Get.until((route) => Get.currentRoute == Routes.HOME);
      Future.delayed(Duration(milliseconds: 20), () {
        Get.toNamed(Routes.USER_LOGIN);
      });
    } else {
      Toast.show(result.message ?? I18nKeys.modify_login_password);
    }
  }
}
