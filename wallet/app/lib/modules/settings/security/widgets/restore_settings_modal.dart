import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/settings/security/controller/restore_settings_controller.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

typedef SelectedIndexCallback = void Function(int index);

class RestoreSettingsModal extends StatefulWidget {
  final String title;
  final List<Map> optionList;
  final VoidCallback selectedCallback;

  const RestoreSettingsModal({
    Key? key,
    required this.title,
    required this.optionList,
    required this.selectedCallback,
  }) : super(key: key);

  @override
  State<RestoreSettingsModal> createState() => _RestoreSettingsModalState();
}

class _RestoreSettingsModalState extends State<RestoreSettingsModal>
    with WidgetsBindingObserver {
  final controller = Get.put(RestoreSettingsController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    controller.addTimer(false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();

    controller.addTimer(true);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(bottom: Get.safetyBottomBarHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.r),
          topRight: Radius.circular(15.r),
        ),
      ),
      child: Obx(
        () {
          // print("_RestoreSettingsModalState Obx");
         return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 10,
                ),
                child: Text(
                  I18nKeys.restoringSettingsTipTitle,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Column(
                children: widget.optionList.map((map) {
                  return buildOption(map);
                }).toList(),
              ),
              const Expanded(child: SizedBox.shrink()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 15.w),
                  SizedBox(
                    width: 165.w,
                    height: 50.h,
                    child: UniButton(
                      style: UniButtonStyle.PrimaryLight,
                      onPressed: () => Get.back(),
                      child: Text(I18nKeys.cancel),
                    ),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  SizedBox(
                    width: 165.w,
                    height: 50.h,
                    child: UniButton(
                      style: UniButtonStyle.Primary,
                      onPressed: controller.canRestoreAction ? () {
                        widget.selectedCallback();
                      }
                          : null,
                      child: Text(controller.maxCount > 0 ? "${I18nKeys.recovery} (${controller.maxCount}s) ":I18nKeys.recovery),
                    ),
                  ),
                  SizedBox(width: 15.w),
                ],
              ),
              SizedBox(height: 40.h),
            ],
          );
        },
      ),
    );
  }

  Widget buildOption(Map map) {
    return InkWell(
      onTap: () {
        controller.selectedOptionsWithMap(map);
      },
      child: Container(
        height: 50.h,
        padding: const EdgeInsets.only(left: 17, right: 17),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: WalletLoadAssetImage("settings/lead_arrow"),
            ),
            Expanded(child: Text(
              map["name"],
              maxLines: 2,
              style: TextStyle(
                color: map["status"] == "1"
                    ? const Color(0xFF333333)
                    : const Color(0xFF666666),
                fontWeight:
                map["status"] == "1" ? FontWeight.bold : FontWeight.normal,
                fontSize: 13.sp,
              ),
            ),
            ),
            WalletLoadAssetImage(
              map["status"] == "1"
                  ? "common/icon_gouxuan"
                  : "common/icon_weigouxuan",
              height: 30,
              width: 30,
            ),
          ],
        ),
      ),
    );
  }
}
