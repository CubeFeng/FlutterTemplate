import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'translations/en_US.dart';
import 'translations/ja.dart';
import 'translations/ko.dart';
import 'translations/zh_CN.dart';
import 'translations/zh_TW.dart';

abstract class SupportedLocales {
  static const en_US = Locale("en", "US");
  static const ja_JP = Locale("ja");
  static const ko_KR = Locale("ko");
  static const zh_CN = Locale("zh", "CN");
  static const zh_TW = Locale("zh", "TW");

  static const values = [en_US, ja_JP, ko_KR, zh_CN, zh_TW];
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
