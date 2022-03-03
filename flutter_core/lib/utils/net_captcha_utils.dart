import 'dart:async';

import 'package:flutter_net_captcha/flutter_net_captcha.dart';
import 'package:flutter_ucore/i18n/i18n.dart';
import 'package:flutter_ucore/services/local_service.dart';

class NetCaptchaUtils {
  static final VerifyCodeConfig codeConfig =
      VerifyCodeConfig(captchaId: '3d950bf0298b4644b94f2cdbdc8dfd65', closeButtonHidden: false);

  static void setNetCaptcha() {
    FlutterNetCaptcha.configVerifyCode(codeConfig);
  }

  static Future<String> showNetCaptcha() {

    final Completer<String> completer = Completer<String>();
    FlutterNetCaptcha.showCaptcha(
        mode: VerifyCodeMode.Normal,
        language: getLanguageNetCaptcha(),//VerifyLanguage.ZH_CN,
        onLoaded: () {},
        onVerify: (VerifyCodeResponse response) {
          if (response.validate != '') {
            completer.complete(response.validate);
          }
        },
        onError: (String message) {
          completer.completeError(message); // 有时  Bad state: Future already completed
        },
        onClose: (VerifyCodeClose close) {});
    return completer.future;
  }


  ///网易易盾
  static VerifyLanguage getLanguageNetCaptcha() {
    VerifyLanguage language = VerifyLanguage.ZH_TW;
    final locale =   LocalService.to.language;

    if (locale == SupportedLocales.zh_CN) {
      language = VerifyLanguage.ZH_CN;
    } else if (locale == SupportedLocales.zh_TW) {
      language = VerifyLanguage.ZH_TW;
    } else if (locale == SupportedLocales.en_US) {
      language = VerifyLanguage.EN;
    } else if (locale == SupportedLocales.ko_KR) {
      language = VerifyLanguage.KO;
    } else if (locale == SupportedLocales.ja_JP) {
      language = VerifyLanguage.JA;
    }  else {
      language = VerifyLanguage.ZH_TW;
    }
    return language;
  }
}
