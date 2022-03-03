import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/real_name_message_controlller.dart';
import 'package:flutter_ucore/modules/user/controllers/realname_auth_result_controller.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';
import 'package:flutter_ucore/widgets/ucore_scroll_view.dart';

class RealNameAuthResultView extends GetView<RealnameAuthResultController> {
  RealNameAuthResultView({Key? key}) : super(key: key);

  final RealNameMessageController message = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UCoreAppBar(
        title: Text(I18nKeys.auth_result),
      ),
      body: SafeArea(
        child: Container(
            color: Colours.primary_bg,
            child: Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: UCoreScrollView(
                      padding: const EdgeInsets.all(0),
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 14, bottom: 9),
                          color: Colours.secondary_bg,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  right: 8,
                                ),
                                child: LoadAssetImage(
                                  message.isResult.value == 1
                                      ? 'realname/icon_upload_success'
                                      : 'realname/icon_upload_fail',
                                  fit: BoxFit.fill,
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                              Text(
                                message.isResult.value == 1 ? I18nKeys.auth_pass : I18nKeys.auth_failed,
                                style: TextStyle(
                                  color: message.isResult.value == 1 ? Colours.text_blue : Colours.text_red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        _buildCardMessage(),
                        Container(
                          height: 8,
                          color: Colours.bg_gray,
                        ),
                        _buildHeadPortrait(),
                        Container(
                          height: 8,
                          color: Colours.bg_gray,
                        ),
                        _buildCertificationPrompt(),
                      ],
                    ),
                  ),
                  _buildBottomButton(),
                ],
              );
            })),
      ),
    );
  }

  Widget _buildCardMessage() {
    if (controller.closed.value) {
      return Container(
        padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 16),
        color: Colours.primary_bg,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              I18nKeys.certificate_information,
              style: TextStyle(
                color: Colours.primary_text,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
            Visibility(
              visible: message.isResult.value != 1,
              child: InkWell(
                onTap: () {
                  controller.setExpandIconState();
                },
                child: Row(
                  children: [
                    Text(
                      I18nKeys.unfold,
                      style: const TextStyle(
                        color: Colours.brand,
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    RotatedBox(
                      quarterTurns: controller.quarterTurns.value,
                      child: const LoadAssetImage(
                        'realname/icon_xiala_more',
                        height: 15,
                        width: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      //证件信息
      return Container(
        padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
        color: Colours.primary_bg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    I18nKeys.certificate_information,
                    style: TextStyle(
                      color: Colours.primary_text,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Visibility(
                    visible: message.isResult.value != 1,
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          controller.setExpandIconState();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              I18nKeys.hide,
                              style: const TextStyle(
                                color: Colours.brand,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            RotatedBox(
                              quarterTurns: controller.quarterTurns.value,
                              child: const LoadAssetImage(
                                'realname/icon_xiala_more',
                                height: 15,
                                width: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 16),
              child: _buildCardOneMessage(0),
            ),

            Container(
              height: 1,
              color: Colours.divider,
            ),
            // ),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: _buildCardOneMessage(1),
            ),
            Container(
              height: 1,
              color: Colours.divider,
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: _buildCardOneMessage(2),
            ),
            Container(
              height: 1,
              color: Colours.divider,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildCardOneMessage(int messageType) {
    var messageTitle = '';
    var messageDesc = '';
    if (messageType == 0) {
      messageTitle = I18nKeys.document_type;
      messageDesc = message.cardTypeString;
    } else if (messageType == 1) {
      messageTitle = I18nKeys.full_name;
      messageDesc = message.controllerName.value.text;
    } else if (messageType == 2) {
      messageTitle = I18nKeys.identification_number;
      messageDesc = message.controllerIDNum.value.text;
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 13,
            ),
            child: Text(
              messageTitle,
              style: TextStyle(
                color: Colours.text,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                top: 13,
              ),
              child: Container(
                child: Text(
                  messageDesc,
                  style: TextStyle(
                    color: Colours.text,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadPortrait() {
    //头像模块
    return Container(
      color: Colours.primary_bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.vGap16,
          Container(
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: Text(
              I18nKeys.id_photo,
              style: TextStyle(
                color: Colours.primary_text,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Gaps.vGap8,
          Container(
            padding: const EdgeInsets.only(left: 16),
            height: 112 * (1.sw - 72) / 3 / 101,
            width: (1.sw - 72) / 3 + 16,
            child: message.headImage.value.path != ''
                ? Image.file(
                    message.headImage.value,
                    fit: BoxFit.fill,
                    height: 112 * (1.sw - 72) / 3 / 101,
                    width: (1.sw - 72) / 3,
                  )
                : LoadAssetImage(
                    'realname/icon_quyang',
                    fit: BoxFit.fill,
                    height: 112 * (1.sw - 72) / 3 / 101,
                    width: (1.sw - 72) / 3,
                  ),
          ),
          Gaps.vGap16,
          Container(
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: Text(
              I18nKeys.living_avatar,
              style: TextStyle(
                color: Colours.primary_text,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Gaps.vGap8,
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.file(
                  message.livingSamplingFileOne.value,
                  fit: BoxFit.fill,
                  height: 112 * (1.sw - 72) / 3 / 101,
                  width: (1.sw - 72) / 3,
                ),
                Image.file(
                  message.livingSamplingFileTwo.value,
                  fit: BoxFit.fill,
                  height: 112 * (1.sw - 72) / 3 / 101,
                  width: (1.sw - 72) / 3,
                ),
                Image.file(
                  message.livingSamplingFileThree.value,
                  fit: BoxFit.fill,
                  height: 112 * (1.sw - 72) / 3 / 101,
                  width: (1.sw - 72) / 3,
                ),
              ],
            ),
          ),
          Gaps.vGap24,
        ],
      ),
    );
  }

  Widget _buildCertificationPrompt() {
    //认证提示
    if (message.isResult.value == 0) {
      //认证失败
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 13),
              child: Text(
                I18nKeys.auth_prompt,
                style: TextStyle(
                  color: Colours.primary_text,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 13, left: 13, right: 13, bottom: 26),
              width: 1.sw - 10,
              child: DecoratedBox(
                child: Container(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        I18nKeys.the_head_picture_living_disaccord,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colours.badge,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        I18nKeys.solution_1_re_sampling_in_vivo,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colours.primary_text,
                          fontSize: 13,
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        I18nKeys.solution_2_submit_it_for_manual_audit,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colours.primary_text,
                          fontSize: 13,
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    border: Border.all(width: 1.0, color: Colours.badge, style: BorderStyle.solid)),
              ),
            ),
            Container(
              height: 8,
              color: Colours.bg_gray,
            ),
          ],
        ),
      );
    } else {
      return Container(
        color: Colours.primary_bg,
      );
    }
  }

  Widget _buildBottomButton() {
    //底部按钮
    if (message.isResult.value == 0) {
      //认证失败
      return Container(
        color: Colours.primary_bg,
        child: Container(
          padding: const EdgeInsets.only(bottom: 12, top: 12, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: OutlinedButton(
                  child: Container(
                    height: 44,
                    child: Center(
                      child: Text(
                        I18nKeys.submit_for_manual_review,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colours.brand,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    //点击  提交存档
                    controller.showNetCaptcha();
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(const BorderSide(color: Colours.brand, width: 1)),
                    backgroundColor: MaterialStateProperty.all(Colours.button_disabled),
                  ),
                ),
              ),
              Gaps.hGap16,
              Expanded(
                  child: UCoreButton(
                onPressed: () {
                  Get.back();
                },
                text: I18nKeys.resampling_in_vivo,
                minHeight: 44,
                fontSize: 16,
              )),
            ],
          ),
        ),
      );
    } else {
      return Container(
          color: Colours.primary_bg,
          padding: const EdgeInsets.only(bottom: 12, top: 12, left: 16, right: 16),
          child: UCoreButton(
            onPressed: () {
              controller.showNetCaptcha();
            },
            text: I18nKeys.next_step,
            minHeight: 44,
          ));
    }
  }
}
