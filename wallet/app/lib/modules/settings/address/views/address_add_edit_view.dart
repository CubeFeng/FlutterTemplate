import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/generated/icon_font.g.dart';
import 'package:flutter_wallet/modules/settings/address/controllers/address_add_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/utils/app_utils.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';

class AddressAddEditView extends StatelessWidget {
  final controller = Get.put(AddressAddEditController());

  final decoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15.r),
    boxShadow: [
      BoxShadow(
        offset: Offset(0, 3.w),
        color: const Color(0xFF000000).withOpacity(0.08),
        blurRadius: 5.w,
      ),
    ],
  );

  AddressAddEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QiAppBar(
        title: Text(
            controller.isEdit ? I18nKeys.modifyAddress : I18nKeys.addAddress),
        action: IconButton(
          icon: const WalletLoadAssetImage(
            'common/scan_qrcode',
            width: 22,
          ),
          onPressed: () async {
            AppUtils.hideKeyboard();
            // 扫码
            final result = await Get.toNamed(Routes.SCAN_CODE);
            // Toast.show("扫码结果: $result");
            controller.validateAddress(result);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 25.h),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showChoiceCoinTypeModal,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: decoration,
                child: Obx(() => _buildCoinType(controller.selectedCoinType)),
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 15,
                bottom: 2.5,
              ),
              decoration: decoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    I18nKeys.name,
                    style: TextStyle(
                        color: const Color(0xFF666666), fontSize: 12.sp),
                  ),
                  _CleanableTextField(
                    controller: controller.nameController,
                    hintText: I18nRawKeys
                        .pleaseSetANameForThisAddressUpToCharacters
                        .trPlaceholder(['20']),
                    maxLength: 20,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 15,
                bottom: 2.5,
              ),
              decoration: decoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    I18nKeys.address,
                    style: TextStyle(
                        color: const Color(0xFF666666), fontSize: 12.sp),
                  ),
                  _CleanableTextField(
                    controller: controller.addressController,
                    hintText: I18nKeys.theWalletCanBePastedOrScanned,
                    maxLength: 50,
                  )
                ],
              ),
            ),
            SizedBox(height: 40.h),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 130.w,
                height: 50.h,
                child: Obx(
                  () => UniButton(
                    onPressed: controller.canSave
                        ? () => controller.didSave().then((value) => Get.back())
                        : null,
                    child: Text(controller.isEdit
                        ? I18nKeys.modifiedSuccessfully
                        : I18nKeys.preservation),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showChoiceCoinTypeModal() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15.r),
              child: Row(
                children: [
                  Text(
                    I18nKeys.selectMainChain,
                    style: TextStyle(
                      color: const Color(0xFF333333),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.clear, color: Color(0xFF999999)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ...controller.supportCoinTypes
                      .map(
                        (coinType) => GestureDetector(
                          onTap: () {
                            controller.setSelectedCoinType(coinType);
                            Get.back();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.only(bottom: 7.5),
                            decoration: BoxDecoration(
                              color: controller.selectedCoinType == coinType
                                  ? const Color(0xFFF8F8F8)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: _buildCoinType(coinType, true,false),
                          ),
                        ),
                      )
                      .toList()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCoinType(QiCoinType coinType, [bool? requireFullName,bool showArrowIcon = true]) {
    return Row(
      children: [
        WalletLoadAssetImage(
            "property/icon_coin_${coinType.chainName().toLowerCase()}", width: 43,
          height: 43, fit: BoxFit.fitHeight,),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              coinType.chainName(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
                fontSize: 14.sp,
              ),
            ),
            requireFullName == true
                ? Text(
                    coinType.fullName(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF999999),
                      fontSize: 12.sp,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        const Expanded(child: SizedBox.shrink()),
        showArrowIcon == true
            ?const Icon(
          Icons.arrow_forward_ios_sharp,
          size: 12,
          color: Color(0xFFCCCCCC),
        ):const Text(""),
      ],
    );
  }
}

class _CleanableTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int? maxLength;

  const _CleanableTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.maxLength,
  }) : super(key: key);

  @override
  State<_CleanableTextField> createState() => _CleanableTextFieldState();
}

class _CleanableTextFieldState extends State<_CleanableTextField> {
  var _isCleanable = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        _isCleanable = widget.controller.text.isNotEmpty;
      });
    });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {
        _isCleanable = widget.controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: TextStyle(color: const Color(0xFF333333), fontSize: 14.sp),
      minLines: 1,
      maxLines: 3,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        counter: const SizedBox.shrink(),
        border: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: const Color(0xFFCCCCCC), fontSize: 14.sp),
        isDense: true,
        suffix: _isCleanable
            ? GestureDetector(
                onTap: () => setState(() => widget.controller.text = ''),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconFont(
                    IconFont.iconSRshanchu,
                    size: 12.r,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
