import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/binding_success_controller.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/widgets/ucore_adapt_status_bar.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

class BindingSuccessView extends GetView<BindingSuccessController> {
  @override
  Widget build(BuildContext context) {
    return UCoreAdaptStatusBar(
      child: Scaffold(
        appBar: UCoreAppBar(
          title: Text(I18nKeys.binding_successfully),
        ),
        body: Container(
          color: Colours.primary_bg,
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Gaps.vGap42,
              Gaps.vGap50,
              LoadAssetImage('load/icon_load_success'),
              Gaps.vGap34,
              UCoreButton(
                onPressed: () {},
                text: I18nKeys.completed,
              )
            ],
          ),
        ),
      ),
    );
  }
}
