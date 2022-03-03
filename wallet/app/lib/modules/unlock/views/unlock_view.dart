import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';

class UnlockView extends StatefulWidget {
  const UnlockView({Key? key}) : super(key: key);

  @override
  State<UnlockView> createState() => _UnlockViewState();
}

class _UnlockViewState extends State<UnlockView> {
  void startBiometricAuth() {
    UniModals.showVerifySecurityPasswordModal(
      title: Text(I18nKeys.unlockAITDWallet),
      onSuccess: () async {
        await Get.offAllNamed(Routes.HOME);
      },
      passwordAuthOnly: false,
      switchPasswordAuto: false,
    );
  }

  void startPasswordAuth() {
    UniModals.showVerifySecurityPasswordModal(
      title: Text(I18nKeys.unlockAITDWallet),
      onSuccess: () async {
        await Get.offAllNamed(Routes.HOME);
      },
      passwordAuthOnly: true,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      startBiometricAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: Get.safetyBottomBarHeight),
        child: Column(
          children: [
            const Expanded(child: SizedBox.shrink()),
            GestureDetector(
              onTap: startBiometricAuth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.fingerprint,
                    size: 64,
                    color: Color(0xFF2750EB),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    I18nKeys.unlockAITDWallet,
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox.shrink()),
            GestureDetector(
              onTap: startPasswordAuth,
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(16.r),
                child: Text(
                  I18nKeys.useWalletPasswordInstead,
                  style: TextStyle(
                    color: Color(0xFF2750EB),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
