import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/i18n/i18n.dart';
import 'package:flutter_ucore/theme/app_theme.dart';
// import 'package:get/get.dart';

class LocalService extends GetxService {
  static LocalService get to => Get.find();
  static const _prefix = "local_";

  StorageInterface get _sp => StorageUtils.sp;

  ///================== 订阅的RSS ID 列表 ==================
  static const _keySubscribedRssIds = "${_prefix}subscribedRssIds";

  List<int> get subscribedRssIds {
    final value = _sp.read<String>(_keySubscribedRssIds, "") ?? "";
    return value
        .split(",")
        .map((e) => int.tryParse(e))
        .filterNotNull()
        .toList();
  }

  set subscribedRssIds(List<int> value) =>
      _sp.write(_keySubscribedRssIds, value.toSet().join(","));

  /// 订阅RSS
  void subscribeRss({int? id, List<int>? ids}) {
    final _ids = subscribedRssIds;
    if (id != null) _ids.add(id);
    if (ids != null) _ids.addAll(ids);
    subscribedRssIds = _ids;
  }

  /// 退订RSS
  void unsubscribeRss({int? id, List<int>? ids}) {
    final _ids = subscribedRssIds;
    if (id != null) _ids.remove(id);
    if (ids != null) ids.forEach((e) => _ids.remove(e));
    subscribedRssIds = _ids;
  }

  ///================== 当前版本第一次启动时间 ==================
  static const _keyCurrentVersionFirstStartupTimestamp =
      "${_prefix}currentVersionFirstStartupTimestamp";

  Future<int?> getCurrentVersionFirstStartupTimestamp() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final key =
        "${_keyCurrentVersionFirstStartupTimestamp}_${packageInfo.buildNumber}";
    return _sp.read<int>(key, null);
  }

  Future<void> setCurrentVersionFirstStartupTimestamp() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final key =
        "${_keyCurrentVersionFirstStartupTimestamp}_${packageInfo.buildNumber}";
    _sp.write(key, DateTime.now().millisecondsSinceEpoch);
  }

  ///================== 语言 ==================
  late Rx<Locale> languageObservable;
  static const _keyLanguage = "${_prefix}language";

  Locale get language {
    final lang = StorageUtils.sp.read<String>(_keyLanguage, null)?.split("_");
    if (lang != null) {
      if (lang.length == 1) {
        return Locale.fromSubtags(languageCode: lang[0]);
      } else if (lang.length == 2) {
        return Locale.fromSubtags(languageCode: lang[0], countryCode: lang[1]);
      } else if (lang.length == 3) {
        return Locale.fromSubtags(
            languageCode: lang[0], scriptCode: lang[1], countryCode: lang[2]);
      }
    }
    return Get.locale ??
        Get.fallbackLocale ??
        Get.deviceLocale ??
        SupportedLocales.en_US;
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
    if (language == SupportedLocales.zh_CN) {
      return "简体中文";
    } else if (language == SupportedLocales.zh_TW) {
      return "繁體中文";
    } else if (language == SupportedLocales.ja_JP) {
      return "日本語";
    } else if (language == SupportedLocales.en_US) {
      return "English";
    } else if (language == SupportedLocales.ko_KR) {
      return "한국어";
    }
    return "";
  }

  String get languageCode {
    if (language == SupportedLocales.zh_CN) {
      return "zh_CN";
    } else if (language == SupportedLocales.zh_TW) {
      return "zh_TW";
    } else if (language == SupportedLocales.ja_JP) {
      return "ja_JP";
    } else if (language == SupportedLocales.en_US) {
      return "en_US";
    } else if (language == SupportedLocales.ko_KR) {
      return "ko_KR";
    }
    return "";
  }

  ///================== 主题  true-暗色，false-亮色，null-跟随系统 ==================
  late Rx<bool?> darkThemeObservable;
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
      Get.changeTheme(
          Get.isPlatformDarkMode ? AppTheme.darkTheme : AppTheme.theme);
      StorageUtils.sp.delete(_keyDarkTheme);
      darkThemeObservable.value = null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Observables
    languageObservable = Rx(language);
    darkThemeObservable = Rx(darkTheme);
    // 根据配置修改语言和主题配色
    Get.locale = language;
    // 屏蔽暗色，暂时只支持亮色
    Get.changeTheme(AppTheme.theme);
    // if (darkTheme == true) {
    //   Get.changeTheme(AppTheme.darkTheme);
    // } else if (darkTheme == false) {
    //   Get.changeTheme(AppTheme.theme);
    // } else {
    //   Get.changeTheme(Get.isPlatformDarkMode ? AppTheme.darkTheme : AppTheme.theme);
    // }
  }
}
