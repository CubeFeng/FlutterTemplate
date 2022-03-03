import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/login/controllers/register_controller.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/widgets/custom_textfield.dart';
import 'package:flutter_ucore/widgets/ucore_adapt_status_bar.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return UCoreAdaptStatusBar(
      child: Scaffold(
        appBar: UCoreAppBar(
          title: Text(I18nKeys.email_registration),
        ),
        body: Container(
          color: Colors.white,
          height: 1.sh,
          padding: const EdgeInsets.only(left: 16, right: 16),
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
                Gaps.vGap10,
                CustomTextField(
                  controller: controller.inviteCodeController,
                  focusNode: controller.inviteCodeNode,
                  hintText: I18nKeys.enter_invitation_code,
                  labelText: I18nKeys.invitation_code,
                ),
                Gaps.vGap32,
                Gaps.vGap8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => GestureDetector(
                          onTap: () {
                            controller.agreeProtocolStatus.value =
                                !controller.agreeProtocolStatus.value;
                          },
                          child: LoadAssetImage(
                              controller.agreeProtocolStatus.value
                                  ? "login/icon_login_agree"
                                  : "login/icon_login_noagree"),
                        )),
                    Gaps.hGap5,
                    Text(
                      I18nKeys.i_have_read_and_agreed,
                      style: TextStyle(
                          fontSize: 12, color: Colours.tertiary_text),
                    ),
                    GestureDetector(
                      onTap: () {
                        //用户协议
                        Get.toNamed(Routes.USER_PROTOCOL);
                      },
                      child: Text(
                        I18nKeys.users_agreement,
                        style: TextStyle(
                            fontSize: 12, color: Colours.brand),
                      ),
                    )
                  ],
                ),
                Gaps.vGap12,
                Obx(() {
                  return UCoreButton(
                    onPressed: controller.registerButtonStatus.value
                        ? controller.toRegister
                        : null,
                    text: I18nKeys.confirm_submission,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
