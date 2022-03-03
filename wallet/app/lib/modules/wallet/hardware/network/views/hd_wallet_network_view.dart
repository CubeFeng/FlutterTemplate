import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/models/wallet_importtype_model.dart';
import 'package:flutter_wallet/modules/wallet/create/controllers/wallet_create_controller.dart';
import 'package:flutter_wallet/modules/wallet/hardware/network/controllers/hd_wallet_network_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/theme/decorate_style.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';

///
class HDWalletNetworkView extends GetView<HDWalletNetworkController> {
  const HDWalletNetworkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HDWalletNetworkController>(
      builder: (controller) {
        return Scaffold(
          appBar: QiAppBar(
            title: Text(I18nKeys.addNetwork),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                SizedBox(height: 12.h),
                Container(
                    width: double.infinity,
                    decoration: DecorateStyles.decoration,
                    child: Column(
                      children: [
                        WalletLoadAssetImage(
                          'wallet/img_wallet_net',
                          width: 112.w,
                          height: 89.h,
                        ),
                        SizedBox(height: 15.h),
                        Padding(
                          padding: EdgeInsets.all(15.sp),
                          child: Text(
                            I18nKeys.addingNetworkIsTheHighlightFunctionOfHDIdentityWalletItCanReuseTheSameSetOfMnemonicsOfUsersToOtherBlockchainNetworksToGeneratePrivateKeysAndAddressesTheNameAndPasswordOfTheNewWalletAreTheSameAsTheIdentityWallet,
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 15.h),
                Container(
                    width: double.infinity,
                    decoration: DecorateStyles.decoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15.sp),
                          child: Text(I18nKeys.pleaseSelectANetwork,
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF333333))),
                        ),
                        Gaps.line,
                        Column(
                          children: QiRpcService().supportCoins.map((e) {
                            QiCoinType coinType = e;
                            return InkWell(
                              onTap: () {
                                if (!controller.hasCoin(coinType)) {
                                  controller.switchChainStatus(coinType);
                                }
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      WalletLoadAssetImage(
                                        'property/icon_coin_${coinType.coinUnit().toLowerCase()}',
                                        width: 43.w,
                                        height: 43.h,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              coinType.chainName(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF333333),
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              coinType.fullName(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF999999),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      controller.hasCoin(coinType)
                                          ? const WalletLoadAssetImage(
                                              'wallet/icon_select_disable')
                                          : ((controller.selectedStatus[
                                                      coinType] ??
                                                  false)
                                              ? const WalletLoadAssetImage(
                                                  'wallet/icon_select', width: 15, height: 15,)
                                              : const WalletLoadAssetImage(
                                                  'wallet/icon_select_gray', width: 15, height: 15,)),
                                    ],
                                  )),
                            );
                          }).toList(),
                        )
                      ],
                    )),
                Gaps.vGap24,
                SizedBox(
                  height: 55.h,
                  child: UniButton(
                    style: UniButtonStyle.PrimaryLight,
                    onPressed: controller.isSelected()
                        ? () {
                            UniModals.showVerifySecurityPasswordModal(
                              onSuccess: () {},
                              onPasswordGet: (password) {
                                cachePassword = password;
                                selectNet = controller.selectedStatus.keys;
                                Get.toNamed(Routes.WALLET_CREATE, parameters: {
                                  'walletId':
                                      controller.coin.walletId.toString(),
                                  "createType":
                                      WalletCreateType.netExtend.typeName
                                });
                              },
                            );
                          }
                        : null,
                    child: Text(I18nKeys.addNetwork,
                        style: TextStyle(fontSize: 15.sp)),
                  ),
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
