import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/modules/settings/security/controller/security_lock_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/security_service.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';

class SettingsSecurityLock extends StatelessWidget {
  final SecurityLockController controller = Get.put(SecurityLockController());

  SettingsSecurityLock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const QiAppBar(
        title: Text("应用锁"),
      ),
      body: Container(
        color: Colors.white,
        height: 1.sh,
        child: ListView(
          children: [
            SizedBox(
              height: 20.h,
            ),
            _buildText("请选择应用锁的开关", false),
            buildCheckedOption("指纹解锁", true),
            buildDivider(),
            SizedBox(
              height: 20.h,
            ),
            _buildText("请选择应用锁的用途", false),
            buildCheckedOption("打开APP时需要", true),
            buildCheckedOption("转账", true),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Container(
      margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.w),
      child: Divider(
        height: 1.h,
        color: const Color(0xffF5F5F5).withOpacity(1),
      ),
    );
  }

  Widget _buildText(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF333333),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget buildCheckedOption(String optionName, bool checked) {
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
                color: const Color(0xff333333),
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
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
                print(
                    "6666666666666 ${SecurityService.to.authenticate(localizedReason: "开启应用锁")}");
              },
            ),
          )
        ],
      ),
    );
  }
}
