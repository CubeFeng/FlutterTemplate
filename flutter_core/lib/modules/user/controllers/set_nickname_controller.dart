import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/edit_profile_controller.dart';
import 'package:flutter_ucore/services/auth_service.dart';
// import 'package:get/get.dart';

class SetNicknameController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final nickname = (Get.parameters['nickname'] ?? '').obs;

  final showDel = false.obs;
  final enableBtn = false.obs; //完成按钮

  EditProfileController editProfileController = Get.find<EditProfileController>();

  @override
  void onInit() async {
    super.onInit();

    textController.text = nickname.value;

    textController.addListener(listen);

    focusNode.addListener(listen);
  }

  @override
  void onReady() async {
    super.onReady();
  }

  void listen() {
    if (focusNode.hasFocus && textController.text.isNotEmpty) {
      showDel.value = true;
    } else {
      showDel.value = false;
    }

    if (textController.text == nickname.value || textController.text.isEmpty) {
      enableBtn.value = false;
    } else {
      enableBtn.value = true;
    }
  }

  ///更新用户信息
  Future<void> setNickname() async {
    if (!enableBtn.value) {
      return;
    }

    final result = await UserApi.userUpdateUserInfo(nickname: textController.text);

    if (result.code == 0 && result.data != null) {
      final userModel = AuthService.to.userModel;
      if(userModel != null){
        userModel.nickname = result.data?.nickname;
        await AuthService.to.updateUser(userModel);
      }

      Toast.show(I18nKeys.setting_successful);
      editProfileController.nickname.value = result.data?.nickname??'';
      Get.back();
    }
  }
}
