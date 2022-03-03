import 'dart:io';

import 'package:fk_photos/fk_photos.dart';
import 'package:flutter_aimall_face_recognition/flutter_aimall_face_recognition.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/i18n/i18n.dart';
import 'package:flutter_ucore/models/user/user_state_model_entity.dart';
import 'package:flutter_ucore/services/config_service.dart';
// import 'package:get/get.dart';

class MyBindingController extends GetxController {
  final userStateModel = UserStateModelEntity().obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    getUserBindingData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getUserBindingData() async {
    Toast.showLoading();
    final response = await UserApi.userQueryUserBand();
    logger.d("===========================1");
    Toast.hideLoading();
    if (response.code == 0 && response.data != null) {
      userStateModel.value = response.data!;
    } else {
      //
    }
  }

  /// 录入数据
  Future<void> addFace() async {
    //获取手机权限 TODO
    // if (!await OtherUtils.requestNecessaryPermission(context)) {
    //   return;
    // }

    final File? file = await _actionLiving();

    if (file == null) {
      Toast.showError(I18nKeys.face_recognition_failed);
      return;
    }
    Toast.showLoading();

    final String fileBase64 = await file.toBase64();

    final result =
        await UserApi.userFaceSearch(suffixName: 'jpg', image: fileBase64);

    if (result.code == 0) {
      final res =
          await UserApi.userFaceAdd(suffixName: 'jpg', image: fileBase64);
      Toast.hideLoading();
      if (res.code == 0 && res.data == true) {
        getUserBindingData();
        return;
      }
      if (res.data == false) {
        Toast.showError(I18nKeys.picture_upload_failed_please_try_again);
        return;
      }
      return;
    } else if (result.code == 7023) {
      Toast.hideLoading();
      Toast.showError(I18nKeys.already_registered);
      return;
    } else {
      Toast.hideLoading();
      Toast.showError(I18nKeys.face_recognition_failed);
    }
  }

  /// 动作活体识别
  Future<File> _actionLiving() async {
    try {
      final String languageValue = RealNameGetLanguage.language;

      /// 初始化爱莫
      await FlutterAimallFaceRecognition.initImoSDK(
          ConfigService.to.imoKey, languageValue);

      /// 识别
      return await FlutterAimallFaceRecognition.actionLiving();
    } catch (e) {
      logger.e('动作活体识别  $e');
      return Future.value();
    }
  }
}
