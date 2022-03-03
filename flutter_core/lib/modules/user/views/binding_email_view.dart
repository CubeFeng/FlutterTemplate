import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/binding_email_controller.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/widgets/custom_textfield.dart';
import 'package:flutter_ucore/widgets/ucore_adapt_status_bar.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';

class BindingEmailView extends GetView<BindingEmailController> {
  @override
  Widget build(BuildContext context) {
    return UCoreAdaptStatusBar(
      child: Scaffold(
        appBar: UCoreAppBar(
          title: Text(I18nKeys.binding_email_address),
        ),
        body: Container(
          color: Colors.white,
          height: 1.sh,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Gaps.vGap16,
                CustomTextField(
                  controller: controller.userNameController,
                  focusNode: controller.userNameNode,
                  hintText: I18nKeys.please_enter_email_address,
                  labelText: I18nKeys.email_address,
                ),
                Gaps.vGap5,
                CustomTextField(
                  controller: controller.authCodeController,
                  focusNode: controller.authCodeNode,
                  hintText: I18nKeys.please_enter_captcha,
                  labelText: I18nKeys.captcha,
                  getVCode: () {
                    return controller.getVCode();
                  },
                ),
                Gaps.vGap42,
                Obx(
                  () => UCoreButton(
                    onPressed: controller.submitButtonStatus.value
                        ? controller.toBinding
                        : null,
                    text: I18nKeys.confirm_submission,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
