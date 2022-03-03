import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_choice_list_view.dart';

class SettingsThemeView extends StatelessWidget {
  const SettingsThemeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = LocalService.to;
    final items = [
      UCoreChoiceItem(
        title: I18nKeys.follow_system,
        selected: () => service.darkTheme == null,
        onTap: () {
          service.darkTheme = null;
          Get.back();
        },
      ),
      UCoreChoiceItem(
        title: I18nKeys.light_mode,
        selected: () => service.darkTheme == false,
        onTap: () {
          service.darkTheme = false;
          Get.back();
        },
      ),
      UCoreChoiceItem(
        title: I18nKeys.dark_mode,
        selected: () => service.darkTheme == true,
        onTap: () {
          service.darkTheme = true;
          Get.back();
        },
      ),
    ];
    return Scaffold(
      appBar: UCoreAppBar(
        title: Text(I18nKeys.theme_settings),
      ),
      body: Material(
        color: Get.isDarkMode ? Colours.dark_secondary_bg : Colours.secondary_bg,
        child: UCoreChoiceListView(items: items),
      ),
    );
  }
}
