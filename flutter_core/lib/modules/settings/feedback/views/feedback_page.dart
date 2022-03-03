// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/settings/feedback/controllers/feedback_controller.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/theme/text_style.dart';
import 'package:flutter_ucore/utils/app_utils.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';
import 'package:flutter_ucore/widgets/ucore_scroll_view.dart';

class FeedbackPage extends GetView<FeedbackController> {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: UCoreAppBar(
        title: Text(I18nKeys.suggest),
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xFFF4F5F8),
          child: UCoreScrollView(
            keyboardConfig: AppUtils.getKeyboardActionsConfig(context, [
              controller.mobileOrEmailFocusNode,
              controller.contentFocusNode
            ]),
            children: [
              Container(
                padding: EdgeInsets.all(15.sp),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(I18nKeys.related_information,
                        style: TextStyles.textBold16),
                    Gaps.vGap15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: I18nKeys.types, style: TextStyles.text),
                          TextSpan(
                              text: '*',
                              style: TextStyles.text
                                  .copyWith(color: Colors.redAccent)),
                        ])),
                        InkWell(
                            child: Row(children: [
                              Obx(() {
                                return Text(
                                    controller.typeList[controller.type.value]);
                              }),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              )
                            ]),
                            onTap: controller.selectType)
                      ],
                    ),
                    Gaps.hhLine(height: 15.sp),
                    Row(children: [
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: I18nKeys.ways_to_contact,
                                style: TextStyles.text),
                            TextSpan(
                                text: '*',
                                style: TextStyles.text
                                    .copyWith(color: Colors.redAccent)),
                          ])),
                      Gaps.hGap15,
                      Expanded(
                        child: TextField(
                          controller: controller.mobileOrEmailController,
                          focusNode: controller.mobileOrEmailFocusNode,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                              hintText: I18nKeys.enter_your_email_address,
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyles.text,
                              enabledBorder: InputBorder.none),
                        ),
                      ),
                      Gaps.hGap8,
                    ]),
                  ],
                ),
              ),
              Gaps.vGap34,
              Container(
                  padding: EdgeInsets.all(15.sp),
                  // height: 200,
                  color: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(I18nKeys.specific_contents,
                            style: TextStyles.textBold16),
                        Gaps.vGap15,
                        TextField(
                          controller: controller.contentController,
                          focusNode: controller.contentFocusNode,
                          maxLines: 5,
                          maxLength: 200,
                          decoration: InputDecoration(
                              hintText: "${I18nKeys.fill_in_contents}",
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyles.text,
                              enabledBorder: InputBorder.none),
                        ),
                        InkWell(
                          child: Container(
                              height: 60,
                              width: 60,
                              // color: Colors.redAccent,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    width: .5,
                                    style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3.0)),
                              ),
                              child: Obx(() {
                                if (controller.image.value.path.isEmpty) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LoadAssetImage(
                                          'drawer/icon_select_picture'),
                                      Text(
                                        I18nKeys.upload_pictures_one_at_most,
                                        style: TextStyles.text
                                            .copyWith(fontSize: 8),
                                      )
                                    ],
                                  );
                                } else {
                                  return Image.file(
                                    controller.image.value,
                                    fit: BoxFit.cover,
                                  );
                                }
                              })),
                          onTap: () {
                            controller.selectPhotoPicker();
                          },
                        )
                      ])),
            ],
            bottomButton: Container(
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: UCoreButton(
                  onPressed: controller.onSubmit, text: I18nKeys.submit),
            ),
          ),
        ),
      ),
    );
  }
}
