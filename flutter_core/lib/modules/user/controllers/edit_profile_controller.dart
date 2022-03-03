import 'package:fk_photos/fk_photos.dart';
import 'package:flutter_base_kit/widgets/toast.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/user_center_controller.dart';
import 'package:flutter_ucore/services/auth_service.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final iconPath = ''.obs; //头像地址
  final nickname = ''.obs; //昵称
  final id = ''.obs; //ID

  UserCenterController userController = Get.find<UserCenterController>();

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();

    final userModel = AuthService.to.userModel;
    iconPath.value = userModel?.headImg ?? '';
    id.value = userModel?.userSn ?? '';
    nickname.value = userModel?.nickname ?? id.value;

  }

  @override
  void onClose() {
    super.onClose();

    userController.refresh();

  }

  void pick(BuildContext context) {
    showSelectPhotoPicker(context,takePicText: I18nKeys.camera,albumText: I18nKeys.choose_from_the_album,cancelText: I18nKeys.cancel, onCameraCallback: (asset) async {
      if (asset != null) {
        final File file = (await asset.compress())!;
        upLoadPic(file);
      }
    }, onAlbumCallback: (assetList) async {
      if (assetList != null) {
        final File file = (await assetList.first.compress())!;
        upLoadPic(file);
      }
    });
  }

  ///上传图片
  Future<void> upLoadPic(File file) async {
    Toast.showLoading();
    final String fileBase64 = await file.toBase64();
    final res = await UserApi.rssFileUpload(
        md5: '', suffixName: 'jpg', fileBase64: fileBase64);
    if (res.data == null) {
      Toast.showError(I18nKeys.picture_upload_failed_please_try_again);
      return;
    }

    final String headImage = res.data??'';

    iconPath.value = headImage;

    updateHeadImg(headImage);

    Toast.hideLoading();
  }

  ///更新用户信息
  Future<void> updateHeadImg(String imgPath) async {

    final result = await UserApi.userUpdateUserInfo(headImg: imgPath);

    if (result.code == 0 && result.data != null) {
      final userModel = AuthService.to.userModel;

      if(userModel != null){
        userModel.headImg = result.data?.headImg;
        await AuthService.to.updateUser(userModel);
      }

      Toast.show(I18nKeys.setting_successful);
    }
  }
}
