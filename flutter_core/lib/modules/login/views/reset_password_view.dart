import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/login/controllers/reset_password_controller.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/widgets/custom_textfield.dart';
import 'package:flutter_ucore/widgets/ucore_adapt_status_bar.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  @override
  Widget build(BuildContext context) {
    return UCoreAdaptStatusBar(
      child: Scaffold(
        appBar: UCoreAppBar(
          title: Text(I18nKeys.reset_password),
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
                Gaps.vGap5,
                CustomTextField(
                  controller: controller.passwordController,
                  focusNode: controller.passwordNode,
                  hintText: I18nKeys.please_reset_password,
                  labelText: I18nKeys.password_setting,
                  isInputPwd: true,
                  needCheckInput: true,
                ),
                Gaps.vGap5,
                Obx(
                  () => CustomTextField(
                    controller: controller.repeatPwdController,
                    focusNode: controller.repeatPwdNode,
                    hintText: I18nKeys.please_confirm_password,
                    labelText: I18nKeys.confirm_password,
                    isInputPwd: true,
                    showError: controller.repeatPwdError.value,
                    errorText: I18nKeys.password_not_match,
                  ),
                ),
                Gaps.vGap32,
                Gaps.vGap32,
                Obx(
                  () => UCoreButton(
                    onPressed: controller.submitButtonStatus.value ? controller.toRest : null,
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
