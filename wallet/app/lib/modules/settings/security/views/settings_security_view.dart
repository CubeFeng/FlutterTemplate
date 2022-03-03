import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/settings/security/controller/settings_security_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:get/get.dart';

class SettingsSecurityView extends StatelessWidget {
  final controller = Get.put(SettingsSecuritController());

  SettingsSecurityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QiAppBar(
        title: Text(I18nKeys.securityCenter),
      ),
      body: ListView(
        children: [
          SizedBox(height: 25.h),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 3.w),
                  color: const Color(0xFF000000).withOpacity(0.08),
                  blurRadius: 5.w,
                ),
              ],
            ),
            child: Column(
              children: [
                _buildPathOption(I18nKeys.changeWalletPassword, 1),
                _buildDivider(),
                _buildPathOption(I18nKeys.restoreInitialSettings, 2),
              ],
            ),
          ),
          controller.canBiometrics
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 3.w),
                        color: const Color(0xFF000000).withOpacity(0.08),
                        blurRadius: 5.w,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Obx(
                        () => _buildCheckedOption(
                          controller.payTitle,
                          controller.payStatus.value,
                          1,
                        ),
                      ),
                      _buildDivider(),
                      Obx(
                        () => _buildCheckedOption(
                          controller.loginTitle,
                          controller.loginStatus.value,
                          2,
                        ),
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.only(left: 15.w, right: 15.w),
      child: Divider(
        height: 1.h,
        color: const Color(0xffF5F5F5).withOpacity(1),
      ),
    );
  }

  Widget _buildPathOption(String optionName, int index) {
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          UniModals.showVerifySecurityPasswordModal(
              title: Text(I18nKeys.verifyPwd),
              onSuccess: () {},
              onPasswordGet: (password) {
                Get.toNamed(Routes.SECURITY_SETUP_PASSWORD, parameters: {
                  "title": I18nKeys.setNewPassword,
                  "password": password
                });
              });
        } else if (index == 2) {
          controller.showRestoreSettingsModal();
        } else {
          Get.toNamed(Routes.SETTINGS_SECURITY_LOCK);
        }
        // Get.toNamed(path);
      },
      child: Container(
        color: Colors.transparent,
        height: 55.h,
        child: Stack(
          children: [
            Positioned(
              left: 15.w,
              top: 17.h,
              child: Text(
                optionName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff333333),
                  fontSize: 14.sp,
                ),
              ),
            ),
            Positioned(
              width: 15.w,
              height: 15.h,
              right: 15.w,
              top: 20.h,
              child: WalletLoadImage('settings/jump_icon'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCheckedOption(String optionName, bool checked, int index) {
    print("buildCheckedOption $checked");
    return SizedBox(
      height: 55.h,
      child: Stack(
        children: [
          Positioned(
            left: 15.w,
            top: 17.h,
            child: Text(
              optionName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xff333333),
                fontSize: 14.sp,
              ),
            ),
          ),
          Positioned(
            right: 2.w,
            top: 4.h,
            child: Switch(
              inactiveThumbColor: const Color(0xffffffff),
              value: checked,
              activeTrackColor: const Color(0xff6380F2),
              activeColor: const Color(0xffffffff),
              onChanged: (bool value) {
                print("Switch 的初始值 $value");
                controller.operationBiometrics(value, index);
              },
            ),
          )
        ],
      ),
    );
  }
}
