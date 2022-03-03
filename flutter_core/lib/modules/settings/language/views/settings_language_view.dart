import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/i18n/i18n.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_choice_list_view.dart';

class SettingsLanguageView extends StatelessWidget {
  const SettingsLanguageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = LocalService.to;
    final items = [
      UCoreChoiceItem(
        title: "简体中文",
        selected: () => service.language == SupportedLocales.zh_CN,
        onTap: () {
          service.language = SupportedLocales.zh_CN;
          Get.back();
        },
      ),
      UCoreChoiceItem(
        title: "繁體中文",
        selected: () => service.language == SupportedLocales.zh_TW,
        onTap: () {
          service.language = SupportedLocales.zh_TW;
          Get.back();
        },
      ),
      UCoreChoiceItem(
        title: "日本語",
        selected: () => service.language == SupportedLocales.ja_JP,
        onTap: () {
          service.language = SupportedLocales.ja_JP;
          Get.back();
        },
      ),
      UCoreChoiceItem(
        title: "English",
        selected: () => service.language == SupportedLocales.en_US,
        onTap: () {
          service.language = SupportedLocales.en_US;
          Get.back();
        },
      ),
      // 屏蔽韩语支持
      /*UCoreChoiceItem(
        title: "한국어",
        selected: () => service.language == SupportedLocales.ko_KR,
        onTap: () {
          service.language = SupportedLocales.ko_KR;
          Get.back();
        },
      ),*/
    ];
    return Scaffold(
      appBar: UCoreAppBar(
        title: Text(I18nKeys.multi_language),
      ),
      body: Material(
        color:
            Get.isDarkMode ? Colours.dark_secondary_bg : Colours.secondary_bg,
        child: UCoreChoiceListView(items: items),
      ),
    );
  }
}
