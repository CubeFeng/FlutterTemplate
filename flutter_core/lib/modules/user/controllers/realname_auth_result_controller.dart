import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/real_name_message_controlller.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/utils/net_captcha_utils.dart';
// import 'package:get/get.dart';

class RealnameAuthResultController extends GetxController {
  final quarterTurns = 0.obs;
  final closed = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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
      final RealNameMessageController message = Get.find();
      Toast.showLoading();

      /// 提交实名认证信息
      final response = await UserApi.userAuthAddUserAuth(
        neCaptchaValidate: result,
        activeImg1: message.livingSamplingFileOneUrl,
        activeImg2: message.livingSamplingFileTwoUrl,
        activeImg3: message.livingSamplingFileThreeUrl,
        appOcrAudit: 1,
        idCardBack: message.rightPhotoUrl,
        idCardHold: '',
        idCardFront: message.leftPhotoUrl,
        idVideoUrl: message.videoUrl,
        mobile: '',
        name: message.controllerName.text,
        paperWorkNumber: message.controllerIDNum.text,
        paperWorkType: getIdCardTypeString(message.isIdCard),
        status: 0,
      );
      Toast.hideLoading();
      logger.d("======================8899998");

      if (response.code == 0 && response.data == true) {
        logger.d("=================999999999999999999");
        Get.toNamed(
          Routes.USER_AUTHENTICATION_RESULT,
        );
      } else {
        logger.d("=================${response}");
        Toast.show(response.message ?? I18nKeys.failed_to_sync_please_confirm_the_archive_again);
      }
    }
  }

  //1:国内身份证 0:护照 3:其他证件 2:其他国家身份证, 4: 港澳台身份证

  // 证件类型:1—身份证；2—护照；3—其他；4—国外身份证；5-港澳台省份证
  int getIdCardTypeString(int? isIdCard) {
    if (isIdCard == 0) {
      return 2;
    } else if (isIdCard == 4) {
      return 5;
    } else if (isIdCard == 1) {
      return 1;
    } else if (isIdCard == 3) {
      return 3;
    } else if (isIdCard == 2) {
      return 4;
    } else {
      return 3;
    }
  }

  void setExpandIconState() {
    //点击展开、、、收起
    if (closed.value) {
      closed.value = false;
    } else {
      closed.value = true;
    }
    quarterTurns.value = quarterTurns.value + 2;
  }
}
