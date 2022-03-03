// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/real_name_message_controlller.dart';
import 'package:flutter_ucore/modules/user/views/widget/real_name_card_face_widget.dart';
import 'package:flutter_ucore/modules/user/views/widget/real_name_card_message_widget.dart';
import 'package:flutter_ucore/modules/user/views/widget/real_name_card_widget.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/utils/app_utils.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_scroll_view.dart';

class RealNameMessageView extends GetView<RealNameMessageController> {
  const RealNameMessageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UCoreAppBar(
          title: Text(I18nKeys.realname_authentication),
        ),
        body: SafeArea(
          child: Container(
            color: Colours.primary_bg,
            child: UCoreScrollView(
                keyboardConfig: AppUtils.getKeyboardActionsConfig(
                    context, <FocusNode>[controller.focusNodeName, controller.focusNodeIDNum]),
                children: [
                  Container(
                    height: 8,
                    color: Colours.bg_gray,
                  ),
                  if (controller.isIdCard == 1) RealNameCardWidget(),
                  if (controller.isIdCard == 1)
                    Container(
                      height: 8,
                      color: Colours.bg_gray,
                    ),
                  if (controller.isIdCard == 1) RealNameCardMessageWidget(),
                  if (controller.isIdCard == 1)
                    Container(
                      height: 8,
                      color: Colours.bg_gray,
                    ),
                  if (controller.isIdCard != 1) RealNameCardMessageWidget(),
                  if (controller.isIdCard != 1)
                    Container(
                      height: 8,
                      color: Colours.bg_gray,
                    ),
                  if (controller.isIdCard != 1) RealNameCardWidget(),
                  if (controller.isIdCard != 1)
                    Container(
                      height: 8,
                      color: Colours.bg_gray,
                    ),
                  RealNameCardFaceWidget(),
                ]),
          ),
        ));
  }
}
