import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/set_nickname_controller.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/dimens.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/utils/my_text_input_formatter.dart';
import 'package:flutter_ucore/widgets/ucore_adapt_status_bar.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';

class SetNicknameView extends GetView<SetNicknameController> {
  @override
  Widget build(BuildContext context) {
    return UCoreAdaptStatusBar(
      child: Scaffold(
        appBar: UCoreAppBar(
          title: Text(
            I18nKeys.choose_your_nickname,
          ),
          action: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 5),
                child: Obx(
                  () => Text(
                    I18nKeys.completed,
                    style: TextStyle(
                      fontSize: 14,
                      color: controller.enableBtn.value ? Colours.brand : Colours.tertiary_text,
                    ),
                  ),
                ),
              ),
              onTap: () => controller.setNickname()),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(height: 1, color: Colours.divider),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    Obx(
                      () => TextField(
                        controller: controller.textController,
                        focusNode: controller.focusNode,
                        style: TextStyle(fontSize: Dimens.font_sp15, color: Colours.text),
                        cursorColor: Colours.brand,
                        inputFormatters: [MyTextInputFormatter(maxLength: 30)],
                        decoration: InputDecoration(
                          hintText: I18nKeys.please_enter_your_nickname,
                          suffix: controller.showDel.value
                              ? GestureDetector(
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.grey,
                                    size: 18.sp,
                                  ),
                                  onTap: () => controller.textController.text = '',
                                )
                              : null,
                          focusColor: Colours.brand,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colours.divider,
                              width: 0.8,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colours.divider,
                              width: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colours.divider,
                    ),
                    Gaps.vGap24,
                    Row(
                      children: [
                        LoadAssetImage('user/icon_user_attention'),
                        Gaps.hGap5,
                        Text(
                          I18nKeys.thirty_characters_maximum,
                          style: TextStyle(color: Colours.tertiary_text, fontSize: 12),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
