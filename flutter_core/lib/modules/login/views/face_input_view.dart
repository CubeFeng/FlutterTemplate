import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/login/controllers/face_register_controller.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/widgets/ucore_adapt_status_bar.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';

class FaceInputView extends GetView<FaceRegisterController> {
  @override
  Widget build(BuildContext context) {
    return UCoreAdaptStatusBar(
      child: Scaffold(
        appBar: UCoreAppBar(
          title: Text(I18nKeys.face_register),
        ),
        body: Container(
          color: Colours.divider,
        ),
      ),
    );
  }
}
