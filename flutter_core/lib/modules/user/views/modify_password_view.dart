import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/modify_password_controller.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/widgets/custom_textfield.dart';
import 'package:flutter_ucore/widgets/ucore_adapt_status_bar.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';

class ModifyPasswordView extends GetView<ModifyPasswordController> {
  @override
  Widget build(BuildContext context) {
    return UCoreAdaptStatusBar(
      child: Scaffold(
        appBar: UCoreAppBar(
          title: Text(I18nKeys.change_password),
        ),
        body: Container(
          color: Get.isDarkMode ? Colours.dark_primary_bg : Colours.primary_bg,
          height: 1.sh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics().applyTo(BouncingScrollPhysics()),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: controller.oldController,
                        focusNode: controller.oldNode,
                        hintText: I18nKeys.password_can_not_empty,
                        labelText: I18nKeys.original_password,
                        isInputPwd: true,
                      ),
                      Gaps.vGap5,
                      CustomTextField(
                        controller: controller.newController,
                        focusNode: controller.newNode,
                        hintText: I18nKeys.password_can_not_same,
                        labelText: I18nKeys.new_password,
                        isInputPwd: true,
                        needCheckInput: true,
                      ),
                      Gaps.vGap5,
                      Obx(
                        () => CustomTextField(
                          controller: controller.repeatController,
                          focusNode: controller.repeatNode,
                          hintText: I18nKeys.repeated_password_can_not_same,
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
                          onPressed: controller.submitButtonStatus.value ? controller.toModify : null,
                          text: I18nKeys.modify,
                          minHeight: 44,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
