import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aimall_face_recognition/flutter_aimall_face_recognition.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_turui_ocr/flutter_turui_ocr.dart';

// import 'package:flutter_turui_ocr/ocr.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/i18n/i18n.dart';
import 'package:flutter_ucore/modules/user/views/widget/real_name_upload_video_dialog.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/config_service.dart';
import 'package:flutter_ucore/utils/net_captcha_utils.dart';
// import 'package:get/get.dart';

class RealNameMessageController extends GetxController {
  final FocusNode focusNodeName = FocusNode();
  final TextEditingController controllerName = TextEditingController();
  final FocusNode focusNodeIDNum = FocusNode();
  final TextEditingController controllerIDNum = TextEditingController();

  final isResult = 1.obs; //1为成功 ，0 为失败
  final headImage = File('').obs; //头像图片
  final leftPhotoFile = File('').obs; //左侧证件照片路径
  final rightPhotoFile = File('').obs; //右侧证件照片路径
  final livingSamplingFileOne = File('').obs; //活体取样头像路径1
  final livingSamplingFileTwo = File('').obs; //活体取样头像路径2
  final livingSamplingFileThree = File('').obs; //活体取样头像路径3

  final leftPhotoType = 0.obs; //0 ：没有图片   1：上传图片中  2：上传失败  3;上传成功
  final rightPhotoType = 0.obs; //0 ：没有图片   1：上传图片中  2：上传失败  3;上传成功

  int isIdCard =
      Get.arguments as int; //证件类型   1:国内身份证 0:护照 3:其他证件 2:其他国家身份证, 4: 港澳台身份证
  String get cardTypeString => getIdCardTypeString(isIdCard);

  final hasLivingSamplingFile = false.obs; //是否有活体头像
  LivingSamplingResponse? livingSamplingMessage; //活体取样信息
  late BuildContext dialogContext; //dialog 关闭

  final clickable = false.obs; //点击了下一步

  String leftPhotoUrl = ''; //左侧证件照片路径url
  String rightPhotoUrl = ''; //右侧证件照片路径url
  String livingSamplingFileOneUrl = ''; //活体取样头像路径1url
  String livingSamplingFileTwoUrl = ''; //活体取样头像路径2url
  String livingSamplingFileThreeUrl = ''; //活体取样头像路径3url
  String videoUrl = ''; //视频url

  final hasCardPhoto = false.obs;
  final hasCardMessage = false.obs;
  final hasFacePhoto = false.obs;

  /// 第三方AppUrlSchemes，不为空时是第三方App调起的
  String? _thirdAppUrlSchemes = null;

  String? get thirdAppUrlSchemes => _thirdAppUrlSchemes;

  @override
  void onInit() {
    super.onInit();
    _thirdAppUrlSchemes = Get.parameters["thirdAppUrlSchemes"];
    firstLayout();
    NetCaptchaUtils.setNetCaptcha();
    controllerName.addListener(_changeController);
    controllerIDNum.addListener(_changeController);
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    FlutterTuruiOcr.deInitSdk();
    FlutterAimallFaceRecognition.cleanCache();
    controllerName.dispose();
    controllerIDNum.dispose();
    focusNodeIDNum.dispose();
    focusNodeName.dispose();
    super.onClose();
  }

  Future<void> firstLayout() async {
    if (isIdCard == 1) {
      await FlutterTuruiOcr.initSdk();
    }
    final String languageValue = RealNameGetLanguage.language;

    /// 初始化爱莫
    await FlutterAimallFaceRecognition.initImoSDK(
        ConfigService.to.imoKey, languageValue);
  }

  void _changeController() {
    if (clickable.value) {
      if (controllerName.text == '' || controllerIDNum.text == '') {
        hasCardMessage.value = true;
      } else {
        hasCardMessage.value = false;
      }
    } else {
      hasCardMessage.value = false;
    }
  }

  ///获取身份证信息
  Future<void> getIDCardMessage() async {
    try {
      final OCRResultInfo? resultInfo = await FlutterTuruiOcr.identify();
      if (resultInfo == null) {
        return;
      }

      if (resultInfo.isFront ?? false) {
        controllerName.text = resultInfo.frontCardInfo?.realName ?? '';
        controllerIDNum.text = resultInfo.frontCardInfo?.idCardNum ?? '';
        leftPhotoFile.value = resultInfo.frontCardInfo?.image ?? File('');
        headImage.value = resultInfo.frontCardInfo?.headImage ?? File('');

        uploadIDPhotoData(file: leftPhotoFile.value, type: '1', imageType: 1);
      } else {
        rightPhotoFile.value = resultInfo.backCardInfo?.image ?? File('');
        uploadIDPhotoData(file: rightPhotoFile.value, type: '1', imageType: 2);
      }
      if (clickable.value) {
        if (leftPhotoFile.value.path == '' || rightPhotoFile.value.path == '') {
          hasCardPhoto.value = true;
        } else {
          hasCardPhoto.value = false;
        }
      } else {
        hasCardPhoto.value = false;
      }
    } catch (e) {
      // if (e != null ) {}
    }
  }

  ///获取其他证件信息
  Future<void> getOtherIDCardMessage(bool isFront) async {
    final CardResponse? response =
        await FlutterAimallFaceRecognition.takeCardImage(isFront: isFront);
    if (response == null) {
      return;
    }
    if (response.isFront ?? false) {
      leftPhotoFile.value = response.image ?? File('');
      headImage.value = response.headImage ?? File('');

      uploadIDPhotoData(file: leftPhotoFile.value, type: '1', imageType: 1);
    } else {
      rightPhotoFile.value = response.image ?? File('');
      uploadIDPhotoData(file: rightPhotoFile.value, type: '1', imageType: 2);
    }
    if (clickable.value) {
      if (leftPhotoFile.value.path == '' || rightPhotoFile.value.path == '') {
        hasCardPhoto.value = true;
      } else {
        hasCardPhoto.value = false;
      }
    } else {
      hasCardPhoto.value = false;
    }
  }

  ///实名认证活体采集
  Future<void> getLivingSamplingMessage() async {
    try {
      livingSamplingMessage =
          await FlutterAimallFaceRecognition.livingSampling();
    } catch (e) {
      return;
    }
    if (livingSamplingMessage == null) {
      return;
    }

    livingSamplingFileOne.value = livingSamplingMessage?.image1 ?? File('');
    livingSamplingFileTwo.value = livingSamplingMessage?.image2 ?? File('');
    livingSamplingFileThree.value = livingSamplingMessage?.image3 ?? File('');
    hasLivingSamplingFile.value = true;

    if (clickable.value) {
      if (livingSamplingFileOne.value.path == '' ||
          livingSamplingMessage == null) {
        hasFacePhoto.value = true;
      } else {
        hasFacePhoto.value = false;
      }
    } else {
      hasFacePhoto.value = false;
    }

    getFaceRecognition();
  }

  /// 图形验证
  Future<void> showNetCaptcha() async {
    String result = '';
    try {
      result = await NetCaptchaUtils.showNetCaptcha();
    } catch (e) {
      return;
    }
    if (result != '') {
      userAuthInfoCheckNetEase(result: result);
    }
  }

  /// 获取证件和活体采集比对分数
  Future<void> getFaceRecognition() async {
    if (headImage.value == '' || headImage.value.path == '') {
      isResult.value = 0;
      return;
    }

    try {
      final double results =
          await FlutterAimallFaceRecognition.faceSimilarityComparison(
              headImage.value.path, [
        livingSamplingFileOne.value.path,
        livingSamplingFileTwo.value.path,
        livingSamplingFileThree.value.path
      ]);
      isResult.value = results >= 0.88 ? 1 : 0;
    } catch (e) {
      Toast.show(e as String);
    }
  }

  //点击下一步
  void nextBtnClick() {
    final String name = controllerName.value.text;
    final String idNum = controllerIDNum.value.text;
    clickable.value = true;

    if (name.isEmpty || idNum.isEmpty) {
      hasCardPhoto.value = true;
    }
    if (leftPhotoFile.value.path == '' || rightPhotoFile.value.path == '') {
      hasCardMessage.value = true;
    }
    if (livingSamplingFileOne.value.path == '' ||
        livingSamplingMessage == null) {
      hasFacePhoto.value = true;
    }
    //所有数据都满足条件
    if (!hasCardPhoto.value &&
        !hasCardMessage.value &&
        !hasFacePhoto.value &&
        leftPhotoUrl != '' &&
        rightPhotoUrl != '') {
      //图形验证码校验
      showNetCaptcha();
    }
  }

  //1:国内身份证 0:护照 3:其他证件 2:其他国家身份证, 4: 港澳台身份证
  String getIdCardTypeString(int? isIdCard) {
    if (isIdCard == 0) {
      return I18nKeys.passport;
    } else if (isIdCard == 4) {
      return I18nKeys.hk_macao_and_taiwan_identity_card_cn;
    } else if (isIdCard == 1) {
      return I18nKeys.mainland_id_card_cn;
    } else if (isIdCard == 3) {
      return I18nKeys.other_documents;
    } else if (isIdCard == 2) {
      return I18nKeys.id_card_of_other_countries;
    } else {
      return '';
    }
  }

  ///上传图片
  ///[imageType] 1:左边证件 2：右边证件  3:其他图片  4：视频
  void uploadIDPhotoData(
      {required File file,
      required String type,
      required int imageType}) async {
    if (imageType == 1) {
      //0 ：没有图片   1：上传图片中  2：上传失败  3;上传成功
      leftPhotoType.value = 1;
    }
    if (imageType == 2) {
      rightPhotoType.value = 1;
    }
    final response =
        await UserApi.rssFileUploadImg(file: file.path, type: type);
    logger.d("===========================1");
    if (response.code == 0 && response.data != null) {
      logger.d("======================888888888");
      if (imageType == 1) {
        //0 ：没有图片   1：上传图片中  2：上传失败  3;上传成功
        leftPhotoType.value = 3;
        leftPhotoUrl = response.data ?? '';
      }
      if (imageType == 2) {
        rightPhotoType.value = 3;
        rightPhotoUrl = response.data ?? '';
      }
    } else {
      logger.d("======================8899998");
      if (imageType == 1) {
        //0 ：没有图片   1：上传图片中  2：上传失败  3;上传成功
        leftPhotoType.value = 2;
      }
      if (imageType == 2) {
        rightPhotoType.value = 2;
      }
    }
  }

  /// 网易滑动式校验码验证
  void userAuthInfoCheckNetEase({required String result}) async {
    logger.d("=============33333333=========8899998");
    final response = await UserApi.userAuthInfoCheckNetEase(
      neCaptchaValidate: result,
    );

    if (response.code == 0) {
      //校验成功
      logger.d("=======44444444===============8899998");
      //开启上传页面
      showUploadVideoPhoneDialog(Get.context!,
          onPressed: (BuildContext dialogCon) {
        dialogContext = dialogCon;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        uploadPhotoOrVideoData();
      });
      //todo 缺少上传图片和视频逻辑
    } else {
      logger.d("======================8899998");
      Toast.show(I18nKeys.vcode_check_failed);
      //校验失败
    }
  }

  ///上传图片
  ///[imageType] 1:活体 2：活体  3:活体  4：视频
  Future<void> uploadPhotoOrVideoData() async {
    bool success = true;
    try {
      final response = await Future.wait([
        UserApi.rssFileUploadImg(
            file: livingSamplingFileOne.value.path, type: '1'),
        UserApi.rssFileUploadImg(
            file: livingSamplingFileTwo.value.path, type: '1'),
        UserApi.rssFileUploadImg(
            file: livingSamplingFileThree.value.path, type: '1'),
        UserApi.rssFileUploadImg(
            file: (livingSamplingMessage?.video ?? File('')).path, type: '2')
      ]).timeout(Duration(seconds: 8));

      for (var i = 0; i < response.length; i++) {
        final res = response[i];
        if (res.code == 0 && res.data != null) {
          switch (i) {
            case 0:
              livingSamplingFileOneUrl = res.data ?? '';
              break;
            case 1:
              livingSamplingFileTwoUrl = res.data ?? '';
              break;
            case 2:
              livingSamplingFileThreeUrl = res.data ?? '';
              break;
            case 3:
              videoUrl = res.data ?? '';
              break;
            default:
          }
        } else {
          success = false;
          break;
        }
      }
    } catch (e) {
      success = false;
      NeSentry.message('upload real info error: ${e.toString()}');
    }

    if (success) {
      Navigator.pop(dialogContext);
      Get.toNamed(
        Routes.USER_AUTH_RESULT,
      );
    } else {
      Navigator.pop(dialogContext);
      Toast.showError(I18nKeys.upload_failed_please_upload_again);
    }
  }
}
