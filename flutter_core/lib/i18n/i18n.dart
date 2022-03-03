import 'package:flutter/material.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:get/get.dart';

import 'translations/en_US.dart';
import 'translations/ja.dart';
import 'translations/ko.dart';
import 'translations/zh_CN.dart';
import 'translations/zh_TW.dart';

abstract class SupportedLocales {
  static const en_US = const Locale("en", "US");
  static const ja_JP = const Locale("ja");
  static const ko_KR = const Locale("ko");
  static const zh_CN = const Locale("zh", "CN");
  static const zh_TW = const Locale("zh", "TW");

  static const values = const [en_US, ja_JP, ko_KR, zh_CN, zh_TW];
}

class I18nTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => const {
        "en_US": en_US,
        "ja": ja,
        "ko": ko,
        "zh_CN": zh_CN,
        "zh_TW": zh_TW,
      };
}

class RealNameGetLanguage {
  /// 语言类型--实名认证专用
  static String get language {
    final language = LocalService.to.language;
    if (language == SupportedLocales.zh_CN) {
      return 'ZH_CN';
    } else if (language == SupportedLocales.zh_TW) {
      return 'ZH_TW';
    } else if (language == SupportedLocales.ja_JP) {
      return 'JP';
    } else if (language == SupportedLocales.en_US) {
      return 'EN';
    } else if (language == SupportedLocales.ko_KR) {
      return 'KR';
    }
    return 'ZH_TW';
  }
}
