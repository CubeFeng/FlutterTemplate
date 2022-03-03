import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/settings/address/controllers/address_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/theme/text_style.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:get/get.dart';

class AddressView extends StatelessWidget {
  final controller = Get.put(AddressController());
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

  AddressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QiAppBar(
        title: Text(I18nKeys.addressManagemer),
        action: Obx(
          () => controller.addressList.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  onPressed: () async {
                    await Get.toNamed(Routes.SETTINGS_ADDRESS_ADD_EDIT);
                    controller.requestUpdate();
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Color(0xFF333333),
                    size: 20.r,
                  ),
                ),
        ),
      ),
      body: Obx(
        () => controller.addressList.isEmpty
            ? _buildEmpty()
            : _buildAddressList(),
      ),
    );
  }

  void _showDeletePromptModal(Address address) {
    UniModals.showSingleActionPromptModal(
      icon: WalletLoadAssetImage('property/icon_delete_red', width: 112.w, height: 89.h,),
      title: Text(I18nKeys.deleteAddress),
      message: Text('${I18nKeys.areYouSureYouWantToDeleteThisAddress}？'),
      action: Text(I18nKeys.delete),
      actionStyle: UniButtonStyle.DangerLight,
      showCloseIcon: true,
      onAction: () {
        Get.back();
        controller.didDelete(address);
      },
    );
  }

  Widget _buildAddressList() {
    return ListView(
      padding: EdgeInsets.only(top: 15.h, left: 12.w, right: 12.w),
      children: controller.addressList
          .mapIndexed((index,address) => _buildAddress(address,index))
          .toList(),
    );
  }

  Widget _buildEmpty() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 100.h),
          const SizedBox(
            width: 112,
            height: 89,
            child: WalletLoadImage("settings/settings_add_address"),
          ),
          SizedBox(height: 40.h),
          SizedBox(
            height: 40,
            child: UniButton(
              onPressed: () async {
                await Get.toNamed(Routes.SETTINGS_ADDRESS_ADD_EDIT);
                controller.requestUpdate();
              },
              child: Text(I18nKeys.addAddress,textAlign: TextAlign.center,),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddress(Address address ,int index) {
    return GestureDetector(
      onTap: () async {
        await Get.toNamed(Routes.SETTINGS_ADDRESS_ADD_EDIT, arguments: address);
        controller.requestUpdate();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: decoration,
        child: Slidable(
          key: ValueKey("$address+$index"),
          actionPane: const SlidableStrechActionPane(),
          secondaryActions: [
            GestureDetector(
              onTap: () => _showDeletePromptModal(address),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEE4949),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15.r),
                    bottomRight: Radius.circular(15.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    I18nKeys.delete,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14.sp,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            )
          ],
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15),
                child: WalletLoadAssetImage(
                    "property/icon_coin_${address.coinType?.toLowerCase()}",
                  fit:BoxFit.fitHeight,
                  width: 43,
                  height: 43,),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.coinType ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF333333),
                            fontSize: 14.sp,
                          ),
                        ),
                        const Expanded(child: SizedBox.shrink()),
                        SizedBox(
                          width: 1.sw * 0.5,
                          child: Text(
                            address.name ?? '',
                            maxLines: 1,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 14.sp,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      address.coinAddress ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF999999),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.w),
            ],
          ),
        ),
      ),
    );
  }
}
