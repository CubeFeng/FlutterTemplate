import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'translations/en_US.dart';
import 'translations/ja.dart';
import 'translations/ko.dart';
import 'translations/zh_CN.dart';
import 'translations/zh_TW.dart';

abstract class Locales {
  static const en_US = const Locale("en", "US");
  static const ja = const Locale("ja");
  static const ko = const Locale("ko");
  static const zh_CN = const Locale("zh", "CN");
  static const zh_TW = const Locale("zh", "TW");

  static final supportedLocales = const [en_US, ja, ko, zh_CN, zh_TW];
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
