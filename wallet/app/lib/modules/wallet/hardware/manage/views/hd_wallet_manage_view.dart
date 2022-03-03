import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/home/controllers/home_controller.dart';
import 'package:flutter_wallet/modules/property/base_record_view.dart';
import 'package:flutter_wallet/modules/property/controllers/property_controller.dart';
import 'package:flutter_wallet/modules/property/record_detail_view.dart';
import 'package:flutter_wallet/modules/wallet/export/controllers/wallet_export_controller.dart';
import 'package:flutter_wallet/modules/wallet/hardware/manage/controllers/hd_wallet_manage_controller.dart';
import 'package:flutter_wallet/modules/wallet/manager/controllers/wallet_manage_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/theme/decorate_style.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

///
class HDWalletManageView extends GetView<HDWalletManageController> {
  const HDWalletManageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HDWalletManageController>(
      builder: (controller) {
        return Scaffold(
          appBar: QiAppBar(
            title: const Text(''),
            action: InkWell(
                onTap: () {
                  UniModals.showVerifySecurityPasswordModal(
                    title: Text(I18nKeys.deleteWallet),
                    confirm: Text(I18nKeys.confirmDelete),
                    onSuccess: () async {
                      UniModals.showSingleActionPromptModal(
                        icon: WalletLoadAssetImage(
                          'property/icon_delete_big',
                          width: 112.w,
                          height: 89.h,
                        ),
                        title: Text(I18nKeys.deleteWallet),
                        message: Text(I18nKeys.deletedWalletNotes),
                        action: Text(I18nKeys.confirmDelete),
                        onAction: () async {
                          Wallet? wallet = await DBService.service.walletDao
                              .findById(controller.coin.walletId!);
                          List<Coin> deleteCoins = [controller.coin];
                          if (wallet != null) {
                            DBService.service.walletDao
                                .deleteAndReturnChangedRows(wallet);
                            deleteCoins = await DBService.service.coinDao
                                .findAllByWalletId(wallet.id!);
                          }
                          for (var element in deleteCoins) {
                            DBService.service.coinDao
                                .deleteAndReturnChangedRows(element);
                          }
                          for (var element in deleteCoins) {
                            //当前删除的是使用中的地址，进行自动切换
                            if (WalletService.service.currentCoin != null && element.id ==
                                WalletService.service.currentCoin!.id) {
                              await Get.find<PropertyController>()
                                  .reselectAddress();
                            }
                          }
                          Get.find<WalletManageController>().onReady();
                          Get.find<HomeController>().checkConnect();
                          Get.back();
                          Get.back();
                          Get.showTopBanner(I18nKeys.confirmTheDeletion);
                        },
                      );
                    },
                  );
                },
                child: WalletLoadAssetImage(
                  'wallet/icon_delete',
                )),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                ListView(
                  children: [
                    SizedBox(height: 12.h),
                    WalletLoadAssetImage(
                      'wallet/img_hd_wallet',
                      width: 112.w,
                      height: 89.h,
                    ),
                    SizedBox(height: 10.h),
                    Center(
                      child: Text(
                        controller.walletName,
                        style: TextStyle(
                          color: const Color(0xFF333333),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Container(
                        width: double.infinity,
                        decoration: DecorateStyles.decoration15,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                final wallet = await DBService.to.walletDao
                                    .findById(controller.coin.walletId!);
                                UniModals.showSingleTextFieldModal(
                                  title: Text(I18nKeys.changeWalletName),
                                  hintText: I18nKeys.pleaseEnterWalletName,
                                  initialText: wallet!.walletName ?? '',
                                  onConfirm: (newName) async {
                                    if (wallet.id ==
                                        WalletService
                                            .service.currentWallet!.id) {
                                      WalletService.service.currentWallet!
                                          .walletName = newName;
                                      await DBService.to.walletDao
                                          .saveAndReturnId(WalletService
                                              .service.currentWallet!);
                                      Get.find<PropertyController>().update();
                                    } else {
                                      wallet.walletName = newName;
                                      await DBService.service.walletDao
                                          .saveAndReturnId(wallet);
                                    }
                                    Get.find<WalletManageController>()
                                        .onReady();
                                    controller.walletName = newName;
                                    controller.update();
                                    Get.back();
                                    Get.showTopBanner(
                                        I18nKeys.modifiedSuccessfully);
                                  },
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(15.sp),
                                child: Row(
                                  children: [
                                    WalletLoadAssetImage(
                                      'wallet/icon_edit',
                                      width: 18.w,
                                      height: 18.h,
                                    ),
                                    Gaps.hGap10,
                                    Text(I18nKeys.changeWalletName,
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF333333))),
                                    const Expanded(
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: Color(0xFFCCCCCC),
                                            ))),
                                  ],
                                ),
                              ),
                            ),
                            Gaps.line,
                            InkWell(
                              onTap: () {
                                UniModals.showVerifySecurityPasswordModal(
                                    onSuccess: () async {},
                                    onPasswordGet: (password) {
                                      Get.toNamed(
                                        Routes.WALLET_EXPORT,
                                        arguments: WalletExportArgs(
                                            mode: WalletExportMode.Mnemonic,
                                            coin: controller.coin,
                                            password: password),
                                      );
                                    });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(15.sp),
                                child: Row(
                                  children: [
                                    WalletLoadAssetImage(
                                      'wallet/icon_backup',
                                      width: 18.w,
                                      height: 18.h,
                                    ),
                                    Gaps.hGap10,
                                    Text(I18nKeys.backUpAuxWord,
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF333333))),
                                    const Expanded(
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: Color(0xFFCCCCCC),
                                            ))),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 15.h),
                    Container(
                        width: double.infinity,
                        decoration: DecorateStyles.decoration15,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(I18nKeys.network,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF333333))),
                                  controller.isFullChain()
                                      ? Container()
                                      : GestureDetector(
                                          child: const WalletLoadAssetImage(
                                            'wallet/icon_add',
                                          ),
                                          onTap: () {
                                            Get.toNamed(
                                                Routes.HD_WALLET_NETWORK,
                                                arguments: controller.coin);
                                          },
                                        ),
                                ],
                              ),
                            ),
                            Gaps.line,
                            Column(
                              children: controller.coinList.map((e) {
                                Coin coin = e;
                                return Container(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        WalletLoadAssetImage(
                                          coin.getIcon(),
                                          width: 55.w,
                                          height: 55.h,
                                          fit: BoxFit.fitHeight,
                                        ),
                                        SizedBox(width: 5.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    coin.coinUnit!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                          0xFF333333),
                                                    ),
                                                  ),
                                                  Gaps.hGap5,
                                                  controller.isSelect(coin)
                                                      ? WalletLoadAssetImage(
                                                          'wallet/icon_select',
                                                          width: 10.w,
                                                          height: 10.h,
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                              Text(
                                                I18nKeys.balance +": "+ LocalService.to.currencySymbol +
                                                    "" +
                                                    WalletService.service
                                                        .getTotalBalanceCurrency(
                                                            coin)
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color:
                                                      const Color(0xFF333333),
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              SizedBox(
                                                width: 138.w,
                                                child: AddressText(
                                                  coin.coinAddress!,
                                                  fontSize: 11.sp,
                                                  color:
                                                      const Color(0xAA666666),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ));
                              }).toList(),
                            )
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      init: controller,
    );
  }
}
