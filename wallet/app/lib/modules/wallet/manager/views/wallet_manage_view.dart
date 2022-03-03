import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/modules/wallet/create/controllers/wallet_create_controller.dart';
import 'package:flutter_wallet/modules/wallet/manager/controllers/wallet_manage_controller.dart';
import 'package:flutter_wallet/modules/wallet/manager/modals/wallet_choice_type_modal.dart';
import 'package:flutter_wallet/modules/wallet/manager/modals/wallet_manage_menu_modal.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/services/security_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/uni_wallet_card.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';

///
class WalletManageView extends GetView<WalletManageController> {
  const WalletManageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletManageController>(
      init: controller,
      builder: (controller) {
        int position = 0;
        int selectPosition = 0;
        for (var element in controller.coinsMap.keys) {
          if (controller.selectCoinType == element) {
            selectPosition = position;
          }
          position++;
        }
        bool lastOne = selectPosition == controller.coinsMap.length - 1;
        return Scaffold(
          appBar: QiAppBar(
            title: Text(I18nKeys.managemer),
          ),
          body: Center(
            child: Row(
              children: [
                Container(
                    color: Colors.white,
                    width: 62.w,
                    child: Column(
                      children: [
                        Column(
                          children: controller.coinsMap.keys.map((e) {
                            int position = 0;
                            int currentPosition = 0;
                            for (var element in controller.coinsMap.keys) {
                              if (element == e) {
                                currentPosition = position;
                              }
                              position++;
                            }

                            return InkWell(
                              onTap: () {
                                controller.selectTab(e);
                              },
                              child: currentPosition == selectPosition
                                  ? Container(
                                      color: const Color(0xFFF8F9FF),
                                      height: 62.h,
                                      child: Center(
                                        child: WalletLoadAssetImage(
                                          'property/icon_coin_${e.coinUnit().toLowerCase()}',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ))
                                  : (currentPosition != selectPosition - 1 &&
                                          currentPosition != selectPosition + 1)
                                      ? Container(
                                          color: const Color(0xFFFFFFFF),
                                          height: 62.h,
                                          child: Center(
                                              child: WalletLoadAssetImage(
                                            'property/icon_coin_${e.coinUnit().toLowerCase()}_gray',
                                            width: 30,
                                            height: 30,
                                          )))
                                      : Container(
                                          color: const Color(0xFFF8F9FF),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFFFFFFF),
                                                  borderRadius:
                                                      currentPosition ==
                                                              selectPosition - 1
                                                          ? const BorderRadius
                                                                  .only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          15))
                                                          : const BorderRadius
                                                                  .only(
                                                              topRight: Radius
                                                                  .circular(
                                                                      15))),
                                              height: 62.h,
                                              child: Center(
                                                  child: WalletLoadAssetImage(
                                                'property/icon_coin_${e.coinUnit().toLowerCase()}_gray',
                                                width: 30,
                                                height: 30,
                                              ))),
                                        ),
                            );
                          }).toList(),
                        ),
                        lastOne
                            ? Container(
                                color: const Color(0xFFF8F9FF),
                                child: Container(
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15))),
                                    height: 62.h),
                              )
                            : Container(),
                      ],
                    )),
                Expanded(
                    child: Container(
                  color: const Color(0xFFF8F9FF),
                  child: ListView(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 20, right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              controller.selectCoinType!.chainName(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 1.09261358),
                              child: Text(
                                ' /' + controller.selectCoinType!.fullName(),
                                style: const TextStyle(
                                    fontSize: 11, color: Color(0xFF666666)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7.5),
                      ...controller.coinsMap[controller.selectCoinType]
                              ?.map((e) => _buildWalletCard(coin: e))
                              .toList() ??
                          [],
                      _buildAddWalletItem()
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 添加钱包
  Widget _buildAddWalletItem() {
    return InkWell(
      onTap: () {
        if (SecurityService.to.hasSecurityPassword) {
        } else {
          // 设置密码
          return UniModals.showNotSetPasswordPromptModal(onConfirm: () {
            Get.back();
            Get.toNamed(Routes.SECURITY_SETUP_PASSWORD);
          });
        }
        UniModals.showVerifySecurityPasswordModal(
          onSuccess: () {},
          onPasswordGet: (password) {
            controller.popDialog(password);
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(10),
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3.w),
              color: const Color(0xFF000000).withOpacity(0.02),
              blurRadius: 5.w,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const WalletLoadAssetImage(
              'property/option_add',
              width: 20,
              height: 20,
              color: Color(0xFF999999),
            ),
            Gaps.hGap10,
            Text(
              I18nKeys.addWallet,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF999999),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard({required Coin coin}) {
    return InkWell(
      onTap: () {
        if (WalletManageController.isHD(controller.wallets, coin)) {
          Get.toNamed(Routes.HD_WALLET_MANAGE, arguments: coin);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 7.5,
        ),
        child: UniWalletCard(
          shadowIcon: 'property/shadow_${coin.coinUnit!.toLowerCase()}',
          colors: QiCoinCode44.parse(coin.coinType!).coinGradientColor(),
          name: Text(
            WalletManageController.getCoinWalletName(controller.wallets, coin),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          balance: Text(
            LocalService.to.currencySymbol +
                '' +
                WalletService.service
                    .getTotalBalanceCurrency(coin)
                    .toStringAsFixed(2),
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          address: coin.coinAddress!,
          selected: controller.isSelect(coin),
          hdWallet: WalletManageController.isHD(controller.wallets, coin),
          menuButton: GestureDetector(
            onTap: () async {
              final wallet =
                  await DBService.to.walletDao.findById(coin.walletId!);
              Get.bottomSheet(
                WalletManageMenuModal(
                  coin: coin,
                  wallet: wallet!,
                ),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(13),
              child: Icon(
                Icons.menu,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
