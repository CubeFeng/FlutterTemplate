import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/modules/settings/security/controller/setup_password_controller.dart';
import 'package:flutter_wallet/modules/settings/security/widgets/password_level_prompt.dart';
import 'package:flutter_wallet/modules/settings/security/widgets/password_text_field.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/u_circle_dot.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/generated/icon_font.g.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

/// 设置钱包密码
class SetupPasswordView extends GetView<SetupPasswordController> {
  const SetupPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupPasswordController>(
        init: controller,
        builder: (controller) {
          return Scaffold(
            appBar: QiAppBar(
              title: Text(controller.title),
              elevation: 0.2,
            ),
            body: Padding(
              padding: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  top: 15.h,
                  bottom: 15.h + Get.safetyBottomBarHeight),
              child: ListView(
                children: [
                  const _PromptBox(),
                  SizedBox(height: 25.h),
                  PasswordTextField(
                    label: Text(I18nKeys.pleaseEnterPwd),
                    floatingLabel: Text(I18nKeys.pwd),
                    controller: controller.passwordController,
                    focusNode: controller.passwordFocusNode,
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: Obx(
                      () =>
                          PasswordLevelPrompt(level: controller.passwordLevel),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  PasswordTextField(
                    label: Text(I18nKeys.pleaseEnterThePasswordAgain),
                    floatingLabel: Text(I18nKeys.pleaseEnterThePasswordAgain),
                    controller: controller.confirmPasswordController,
                    focusNode: controller.confirmPasswordFocusNode,
                  ),
                  Obx(
                    (){
                      if (controller.confirmPasswordDifferent){
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, top: 8),
                            child: Text(
                              I18nKeys.theTwoPasswordsAreInconsistent,
                              style: TextStyle(
                                color: const Color(0xFFF14F4F),
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        );
                      }
                      else if (!controller.vaildPasswordLength){
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, top: 8),
                            child: Text(
                              I18nKeys.thePasswordLengthTip,
                              style: TextStyle(
                                color: const Color(0xFFF14F4F),
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        );
                      }
                      else{
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 68,),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: 80.w,
                      height: 43.h,
                      child: Obx(
                        () => UniButton(
                          style: UniButtonStyle.Primary,
                          onPressed: controller.canComplete
                              ? controller.savePassword
                              : null,
                          child: const Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class _PromptBox extends StatelessWidget {
  const _PromptBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4681F6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
            color: const Color(0xFF2750EB).withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        child: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                      color: const Color(0xFF2750EB).withOpacity(0.8),
                      fontSize: 12.sp,
                    ),
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 4.h, right: 5.w),
                          child: UCircleDot(
                            size: 4.r,
                            color: const Color(0xFF2750EB).withOpacity(0.8),
                          ),
                        ),
                      ),
                      TextSpan(text: '${I18nKeys.passwordMinLengthNotes}\n'),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 4.h, right: 5.w),
                          child: UCircleDot(
                            size: 4.r,
                            color: const Color(0xFF2750EB).withOpacity(0.8),
                          ),
                        ),
                      ),
                      TextSpan(text: '${I18nKeys.passwordImportant}\n'),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 4.h, right: 5.w),
                          child: UCircleDot(
                            size: 4.r,
                            color: const Color(0xFF2750EB).withOpacity(0.8),
                          ),
                        ),
                      ),
                      TextSpan(text: I18nKeys.walletPwdNotes),
                    ]),
              ),
            ),
            WalletLoadAssetImage('property/icon_warn_light', width: 55.w, height: 55.w,),
          ],
        ),
      ),
    );
  }
}
