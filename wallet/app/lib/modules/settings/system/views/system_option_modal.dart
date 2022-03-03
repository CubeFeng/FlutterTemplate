import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/settings/system/controller/system_options_controller.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

typedef SelectedIndexCallback = void Function(int index);

class SystemOptionModal extends StatefulWidget {
  final String title;
  final List<String> optionList;
  final VoidCallback selectedCallback;

  const SystemOptionModal({
    Key? key,
    required this.title,
    required this.optionList,
    required this.selectedCallback,
  }) : super(key: key);

  @override
  State<SystemOptionModal> createState() => _SystemOptionModalState();
}

class _SystemOptionModalState extends State<SystemOptionModal>
    with WidgetsBindingObserver {
  SystemOptionsController get controller => Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: _buildText(widget.title),
          ),
          Expanded(
            child: Obx(
              () => ListView(
                physics: const ClampingScrollPhysics(),
                children: widget.optionList.mapIndexed((index, title) {
                  return _buildOption(title, index);
                }).toList(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 165.w,
                height: 50.w,
                child: UniButton(
                  style: UniButtonStyle.PrimaryLight,
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(I18nKeys.cancel),
                ),
              ),
              SizedBox(width: 15.w),
              SizedBox(
                width: 165.w,
                height: 50.w,
                child: UniButton(
                  style: UniButtonStyle.Primary,
                  onPressed: () {
                    widget.selectedCallback();
                  },
                  child: Text(I18nKeys.confirm),
                ),
              ),
            ],
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildOption(String title, int index) {
    return InkWell(
      onTap: () {
        if (index != controller.selectedIndex.value) {
          controller.selectedIndex.value = index;
        }
      },
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: index == controller.selectedIndex.value ? const Color(0xFF333333):const Color(0xFF999999),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const Expanded(child: SizedBox.shrink()),
            WalletLoadAssetImage(
              index == controller.selectedIndex.value
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

  Widget _buildText(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF333333),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }
}
