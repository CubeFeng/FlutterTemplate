import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/login/controllers/face_register_controller.dart';
import 'package:flutter_ucore/modules/login/controllers/login_controller.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';

// import 'package:flutter_ucore/utils/common_colors.dart';
import 'package:flutter_ucore/widgets/account_textfield.dart';

import 'package:flutter_ucore/widgets/custom_textfield.dart';
import 'package:flutter_ucore/widgets/ucore_adapt_status_bar.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';

class FaceRegisterView extends GetView<FaceRegisterController> {
  LoginController get _loginController => Get.find();

  @override
  Widget build(BuildContext context) {
    return UCoreAdaptStatusBar(
      child: Scaffold(
        appBar: UCoreAppBar(
          title: Text(I18nKeys.face_register),
        ),
        body: Container(
          color: Colors.white,
          height: 1.sh,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Gaps.vGap32,
                Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(60.0),
                        border: Border.all(color: Colours.brand, width: 3.0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60.0),
                      child: Image.file(
                        _loginController.livingResult.image!,
                        fit: BoxFit.cover,
                      ),
                    )),
                Gaps.vGap20,
                Obx(
                  () => AccountTextField(
                    leftWidget: LoadAssetImage('login/icon_account'),
                    controller: controller.userNameController,

                    focusNode: controller.userNameNode,
                    hintText: I18nKeys.set_account_6_32_bits,
                    showError: controller.userNameInputError.value,
                    errorText: I18nKeys.please_enter_the_account_6_32_bits,
                    // labelText: I18nKeys.email_address,
                  ),
                ),
                Obx(
                  () => CustomTextField(
                    leftWidget: LoadAssetImage('login/icon_password'),
                    controller: controller.passwordController,
                    focusNode: controller.passwordNode,
                    hintText: I18nKeys.set_password_8_12_bits,
                    // labelText: I18nKeys.password_setting,
                    isInputPwd: true,
                    showError: controller.passwordInputError.value,
                    errorText: I18nKeys.please_enter_the_password_8_12_bits,
                  ),
                ),
                Obx(
                  () => CustomTextField(
                    leftWidget: LoadAssetImage('login/icon_password'),
                    controller: controller.repeatPwdController,
                    focusNode: controller.repeatPwdNode,
                    hintText: I18nKeys.please_confirm_password,
                    // labelText: I18nKeys.password_setting,
                    isInputPwd: true,
                    showError: controller.repeatPwdInputError.value,
                    errorText: I18nKeys.password_not_match,
                  ),
                ),
                CustomTextField(
                  controller: controller.inviteCodeController,
                  focusNode: controller.inviteCodeNode,
                  hintText: I18nKeys.enter_invitation_code,
                  // labelText: I18nKeys.invitation_code,
                ),
                Gaps.vGap50,
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
                      style:
                          TextStyle(fontSize: 12, color: Colours.tertiary_text),
                    ),
                    GestureDetector(
                      onTap: () {
                        //用户协议
                        Get.toNamed(Routes.USER_PROTOCOL);
                      },
                      child: Text(
                        I18nKeys.users_agreement,
                        style: TextStyle(fontSize: 12, color: Colours.brand),
                      ),
                    )
                  ],
                ),
                Gaps.vGap12,
                Obx(
                  () => UCoreButton(
                    onPressed: controller.registerButtonStatus.value
                        ? controller.toRegister
                        : null,
                    text: I18nKeys.register,
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
