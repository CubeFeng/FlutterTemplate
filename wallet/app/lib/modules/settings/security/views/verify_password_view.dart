import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/modules/settings/security/controller/verify_password_controller.dart';
import 'package:flutter_wallet/modules/settings/security/widgets/password_text_field.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

/// 验证钱包密码
class VerifyPasswordView extends GetView<VerifyPasswordController> {
  const VerifyPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QiAppBar(
        title: Text(I18nKeys.walletPwd),
        elevation: 0.2,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
        child: Column(
          children: [
            SizedBox(height: 25.h),
            PasswordTextField(
              label: Text(I18nKeys.enterWalletPwd),
              floatingLabel: Text(I18nKeys.walletPwd),
              controller: controller.passwordController,
              focusNode: controller.passwordFocusNode,
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () => UniModals.showSingleActionPromptModal(
                  icon: WalletLoadAssetImage('property/icon_lock_big', width: 80.w, height: 65.h,),
                  title: Text(I18nKeys.whatIfIForgotMyPassword),
                  message: Text(I18nKeys.walletPwdSecNotes),
                  action: Text(I18nKeys.ok),
                ),
                child: Text(
                  '${I18nKeys.forgotPwd}?',
                  style: TextStyle(
                    color: const Color(0xFF2750EB),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Expanded(child: SizedBox.shrink()),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 80.w,
                height: 43.h,
                child: Obx(
                  () => UniButton(
                    style: UniButtonStyle.Primary,
                    onPressed: controller.canComplete ? () {} : null,
                    child: const Icon(Icons.keyboard_arrow_right),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
