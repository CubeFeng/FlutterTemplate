import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/i18n/i18n.dart';
import 'package:flutter_wallet/theme/app_theme.dart';
import 'package:get/get.dart';

class LocalService extends GetxService {
  static LocalService get to => Get.find();
  static const _prefix = "local.";

  StorageInterface get _store => StorageUtils.sp;

  //<editor-fold desc="当前版本第一次启动时间">
  static const _keyCurrentVersionFirstStartupTimestamp = "${_prefix}currentVersionFirstStartupTimestamp";

  Future<int?> getCurrentVersionFirstStartupTimestamp() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final key = "${_keyCurrentVersionFirstStartupTimestamp}_${packageInfo.buildNumber}";
    return _store.read<int>(key, null);
  }

  Future<void> setCurrentVersionFirstStartupTimestamp() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final key = "${_keyCurrentVersionFirstStartupTimestamp}_${packageInfo.buildNumber}";
    _store.write(key, DateTime.now().millisecondsSinceEpoch);
  }

  //</editor-fold>

  //<editor-fold desc="语言">
  static const _keyLanguage = "${_prefix}language";
  late final languageObservable = language.obs;

  Locale get language {
    final lang = StorageUtils.sp.read<String>(_keyLanguage, null)?.split("_");
    if (lang != null) {
      if (lang.length == 1) {
        return Locale.fromSubtags(languageCode: lang[0]);
      } else if (lang.length == 2) {
        return Locale.fromSubtags(languageCode: lang[0], countryCode: lang[1]);
      } else if (lang.length == 3) {
        return Locale.fromSubtags(languageCode: lang[0], scriptCode: lang[1], countryCode: lang[2]);
      }
    }
    return Get.locale ?? Get.fallbackLocale ?? Get.deviceLocale ?? SupportedLocales.en_US;
  }

  set language(Locale value) {
    if (language == value) {
      return;
    }
    Get.locale = value;
    StorageUtils.sp.write(_keyLanguage, value.toString());
    languageObservable.value = value;
  }

  String get languageText {
    for (Map map in supportedLanguageList) {
      if (language == map["locales"]) {
        return map["name"];
      }
    }
    return "";
  }

  String get languageCode {
    for (Map map in supportedLanguageList) {
      if (language == map["locales"]) {
        return map["code"];
      }
    }
    return "";
  }

  int get languageCodeNet {
    for (Map map in supportedLanguageList) {
      if (language == map["locales"]) {
        return map["langCode"];
      }
    }
    return 1;
  }

  ///语言列表 1 中文 2 英文 3 繁体 4 日语
  List<Map> get supportedLanguageList {
    List<Map> tempList = [
      {"name": "简体中文", "locales": SupportedLocales.zh_CN, "code": "zh-CN", "langCode": 1},
      {"name": "繁體中文", "locales": SupportedLocales.zh_TW, "code": "zh-TW", "langCode": 3},
      {"name": "English", "locales": SupportedLocales.en_US, "code": "en", "langCode": 2},
      {"name": "日本語", "locales": SupportedLocales.ja_JP, "code": "jp", "langCode": 4}
    ];
    return tempList;
  }

  //</editor-fold>

  //<editor-fold desc="货币单位">
  static const _keyCurrency = "${_prefix}currency";

  /// 货币单位显示
  late final currencyObservable = currency.obs;

  String get currency {
    return StorageUtils.sp.read<String>(_keyCurrency, 'SGD') ?? 'SGD';
  }

  set currency(String value) {
    if (currency == value) {
      return;
    }
    StorageUtils.sp.write(_keyCurrency, value.toString());
    currencyObservable.value = value;
  }

  String get currencySymbol {
    for (Map map in supportedCurrencyList) {
      if (currencyObservable.value == map["unit"]) {
        return map["symbol"];
      }
    }
    return 'S\$';
  }

  ///计价货币列表
  List<Map> get supportedCurrencyList {
    List<Map> tempList = [
      {"name": I18nKeys.currency_rmb, "symbol": "¥", "unit": "CNY"},
      {"name": I18nKeys.currency_dollar, "symbol": "\$", "unit": "USD"},
      {"name": I18nKeys.currency_singaporeDollar, "symbol": "S\$", "unit": "SGD"},
      {"name": I18nKeys.currency_hkdollar, "symbol": "HK\$", "unit": "HKD"}
    ];
    return tempList;
  }

  ///服务及隐私条款
  String get servicePrivacyPolicy {
    String lang = "zh";
    if (languageCode == "zh-CN") {
    lang = "zh";
    }else if (languageCode == "en"){
    lang = "en";
    }else if (languageCode == "zh-TW"){
    lang = "zh_TW";
    }else if (languageCode == "jp"){
    lang = "ja_JP";
    }
    return "http://wallet.aitdcoin.com/aitd-coin-$lang.html";
  }

  //</editor-fold>

  //<editor-fold desc="主题  true-暗色，false-亮色，null-跟随系统">
  late final darkThemeObservable = darkTheme.obs;
  static const _keyDarkTheme = "${_prefix}darkTheme";

  bool? get darkTheme => StorageUtils.sp.read(_keyDarkTheme, null);

  set darkTheme(bool? value) {
    if (darkTheme == value) {
      return;
    }
    if (value == true) {
      Get.changeTheme(AppTheme.darkTheme);
      StorageUtils.sp.write(_keyDarkTheme, true);
      darkThemeObservable.value = true;
    } else if (value == false) {
      Get.changeTheme(AppTheme.theme);
      StorageUtils.sp.write(_keyDarkTheme, false);
      darkThemeObservable.value = false;
    } else {
      Get.changeTheme(Get.isPlatformDarkMode ? AppTheme.darkTheme : AppTheme.theme);
      StorageUtils.sp.delete(_keyDarkTheme);
      darkThemeObservable.value = null;
    }
  }

  //</editor-fold>

  @override
  void onInit() {
    super.onInit();
    // 根据配置修改语言和主题配色
    Get.locale = language;
    // if (darkTheme == true) {
    //   Get.changeTheme(AppTheme.darkTheme);
    // } else if (darkTheme == false) {
    //   Get.changeTheme(AppTheme.theme);
    // } else {
    //   Get.changeTheme(
    //       Get.isPlatformDarkMode ? AppTheme.darkTheme : AppTheme.theme);
    // }
    Get.changeTheme(AppTheme.theme);
  }
}
