import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/real_name_message_controlller.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/widgets/custom_right_textfield.dart';

//实名认证数据采集，身份证信息
class RealNameCardMessageWidget extends GetView<RealNameMessageController> {
  const RealNameCardMessageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.primary_bg,
      padding: const EdgeInsets.all(
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
          Container(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 15,
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: Colours.primary_text,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(I18nKeys.document_type),
                  Expanded(
                    child: Text(
                      controller.cardTypeString,
                      textAlign: TextAlign.right,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colours.bg_gray,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  I18nKeys.full_name,
                  style: TextStyle(
                    color: Colours.primary_text,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: CustomRightTextField(
                    controller: controller.controllerName,
                    hintText: controller.isIdCard == 1
                        ? I18nKeys.automatic_identification_after_uploading
                        : I18nKeys.please_fill_in_your_name,
                    focusNode: controller.focusNodeName,
                  ),
                )
              ],
            ),
          ),
          Container(height: 1, color: Colours.bg_gray),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  I18nKeys.identification_number,
                  style: TextStyle(
                    color: Colours.primary_text,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: CustomRightTextField(
                    controller: controller.controllerIDNum,
                    hintText: controller.isIdCard == 1
                        ? I18nKeys.automatic_identification_after_uploading
                        : I18nKeys.please_enter_the_id_number,
                    focusNode: controller.focusNodeIDNum,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colours.bg_gray,
          ),
          Container(
            padding: const EdgeInsets.only(top: 8),
            child: Visibility(
              visible: controller.hasCardMessage.value,
              child: Text(
                I18nKeys.certificate_information_cannot_be_blank,
                style: TextStyle(
                  color: Colours.brand,
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
