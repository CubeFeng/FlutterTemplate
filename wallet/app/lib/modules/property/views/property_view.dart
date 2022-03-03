import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_base_kit/theme/gaps.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/models/token_info_model.dart';
import 'package:flutter_wallet/modules/wallet/create/controllers/wallet_create_controller.dart';
import 'package:flutter_wallet/modules/dapps/views/widgets/dapps_tabbar_indicator.dart';
import 'package:flutter_wallet/modules/home/controllers/home_controller.dart';
import 'package:flutter_wallet/modules/property/base_record_view.dart';
import 'package:flutter_wallet/modules/property/controllers/property_controller.dart';
import 'package:flutter_wallet/modules/property/views/widgets/no_wallet_view.dart';
import 'package:flutter_wallet/modules/property/views/widgets/property_item_view.dart';
import 'package:flutter_wallet/modules/wallet/export/controllers/wallet_export_controller.dart';
import 'package:flutter_wallet/modules/wallet/manager/controllers/wallet_manage_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/theme/decorate_style.dart';
import 'package:flutter_wallet/widgets/modals/switch_wallet_modal.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/widgets/u_grid_view.dart';
import 'package:flutter_wallet/widgets/u_list_view.dart';
import 'package:flutter_wallet/widgets/u_sliver_sticky_widget.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/api/generate/generate_sol.dart';
import 'package:flutter_wallet_chain/api/rpc/rpc_sol.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

///
class PropertyView extends GetView<PropertyController> {
  const PropertyView({Key? key}) : super(key: key);

  Widget _buildPropertyView() {
    return Scaffold(
      backgroundColor: controller.gradient[0],
      appBar: _TopBar(),
      body: NestedScrollView(
        controller: controller.scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildPropertyHeader(),
            _buildStickyTabBar(),
          ];
        },
        body: Obx(
          () => Container(
            color: Colors.white, // 底色
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: controller.padding),
              decoration: BoxDecoration(
                color: Colors.white, // 底色
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10, //阴影范围
                    spreadRadius: 15, //阴影浓度
                    color: const Color(0xFF000000).withOpacity(0.08), //阴影颜色
                  ),
                ],
              ),
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  _buildCoinList(),
                  _buildCollectGrid(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyHeader() {
    return SliverToBoxAdapter(
      child: Container(
        key: controller.headerGlobalKey,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: controller.gradient,
          ),
        ),
        height: 208,
        child: Column(
          children: [
            Gaps.vGap32,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  !controller.eyeOpen ? '' : LocalService.to.currencySymbol,
                  style: TextStyle(
                    fontFamily: 'DIN',
                    color: const Color(0xFFFFFFFF),
                    fontSize: 26.sp,
                  ),
                ),
                Gaps.hGap5,
                Flexible(
                  child: FittedBox(
                    child: Text(
                      !controller.eyeOpen
                          ? '******'
                          : WalletService.service
                              .getTotalBalance(
                                  WalletService.service.currentCoin!,
                                  WalletService.service.tokenList)
                              .toStringAsFixed(2),
                      style: TextStyle(
                        fontFamily: 'DIN',
                        color: const Color(0xFFFFFFFF),
                        fontSize: 33.sp,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Gaps.hGap10,
                InkWell(
                  onTap: () {
                    controller.switchEysStatus();
                  },
                  child: WalletLoadAssetImage(
                    controller.eyeOpen
                        ? 'property/icon_eye'
                        : 'property/icon_eye_close',
                    width: 17.w,
                    height: 11.h,
                  ),
                ),
              ],
            ),
            Gaps.vGap20,
            Gaps.vGap20,
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                  color: const Color(0xFF234CE6),
                  borderRadius: BorderRadius.circular(15)),
              child: Opacity(
                opacity: 0.72,
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: const WalletLoadAssetImage('property/icon_send'),
                        label: Text(
                          I18nKeys.transfer,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white),
                        ),
                        onPressed: () {
                          Get.toNamed(Routes.TRANSACTION, arguments: null);
                        },
                      ),
                    ),
                    Gaps.vvLine(width: 1, color: Colors.white.withOpacity(0.1)),
                    Expanded(
                      child: TextButton.icon(
                        icon:
                            const WalletLoadAssetImage('property/icon_receive'),
                        label: Text(
                          I18nKeys.receive,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white),
                        ),
                        onPressed: () {
                          Get.toNamed(Routes.PROPERTY_RECEIVE_QR_CODE);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStickyTabBar() {
    return USliverStickyWidget(
      minHeight: 49,
      maxHeight: 49,
      child: Obx(
        () => Container(
          padding: EdgeInsets.only(
            left: controller.padding,
            right: controller.padding,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [controller.gradient[1], Colors.white],
              stops: const [0.99, 1],
            ),
          ),
          child: Container(
            key: controller.tabBarGlobalKey,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: TabBar(
              controller: controller.tabController,
              labelColor: const Color(0xFF2750EB),
              indicator: const DapplineTabIndicator(
                borderSide: BorderSide(
                  width: 2,
                  color: Color(0xFF2750EB),
                ),
              ),
              unselectedLabelColor: const Color(0xFF666666),
              labelStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              tabs: controller.tabs
                  .map((e) => Tab(
                        text: e,
                        height: 49,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollectGrid() {
    return GetBuilder<PropertyController>(
        init: controller,
        id: 'collections',
        builder: (controller) {
          return KeepAliveWrapper(
            child: UGridView(
              padding: EdgeInsets.only(
                bottom: HomeController.to.bottomTabBarSize?.height ?? 0.0,
              ),
              controller: controller.collectionsController,
              onRefresh: controller.refreshNftCollections,
              itemBuilder: (context, index) {
                TokenInfoModel e = controller.collections[index];
                String name = I18nKeys.unknown;
                if (e.name != null) {
                  if (e.name!.contains('#')) {
                    name = e.name!.substring(0, e.name!.indexOf('#'));
                  } else {
                    name = e.name!;
                  }
                }
                return InkWell(
                  onTap: () {
                    Get.toNamed(Routes.NFT_TRANSACTION_LIST, arguments: e);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: WalletLoadImage(
                              e.image!,
                              width: 90,
                              height: 90,
                              defaultImg: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFCCCCCC),
                                    borderRadius: BorderRadius.circular(45)),
                              ),
                            )),
                        Gaps.vGap5,
                        Text(
                          name,
                          style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Gaps.vGap8,
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 1, bottom: 1),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE9EDFD),
                              borderRadius: BorderRadius.circular(11)),
                          child: Text(
                            '#' +
                                BigInt.parse(e.tokenId!, radix: 16).toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: const Color(0xFF000000).withOpacity(0.2),
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: controller.collections.length,
            ),
          );
        });
  }

  Widget _buildCoinList() {
    return KeepAliveWrapper(
      child: Obx(
        () => UListView(
          padding: EdgeInsets.only(
            top: controller.tabViewChildTopPadding,
            bottom: HomeController.to.bottomTabBarSize?.height ?? 0.0,
          ),
          controller: controller.listController,
          itemBuilder: (context, index) {
            return index == 0
                ? PropertyItemView(
                    onTap: () => controller
                        .onCoinClick(WalletService.service.currentCoin!),
                    coinName: WalletService.service.currentCoin!.coinUnit!,
                    icon: WalletLoadAssetImage(
                      WalletService.service.currentCoin!.getIcon(),
                      fit: BoxFit.fitHeight,
                    ),
                    coinAddress: WalletService.service.currentCoin!.coinName!,
                    coinAmount: WalletService.service
                        .getCoinBalance(WalletService.service.currentCoin!),
                    coinAmountCurrency: WalletService.service
                        .getCoinBalanceCurrency(
                            WalletService.service.currentCoin!),
                    show: controller.eyeOpen,
                  )
                : PropertyItemView(
                    onTap: () => controller.onTokenClick(
                        WalletService.service.tokenList[index - 1]),
                    icon: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: WalletLoadImage(
                          WalletService.service.tokenList[index - 1].tokenIcon!,
                          width: 44.w,
                          fit: BoxFit.fitHeight,
                          height: 44.w,
                          defaultImg: Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                                color: const Color(0xFFCCCCCC),
                                borderRadius: BorderRadius.circular(22.w)),
                          ),
                        )),
                    coinName:
                        WalletService.service.tokenList[index - 1].tokenUnit!,
                    coinAddress:
                        WalletService.service.tokenList[index - 1].tokenName!,
                    show: controller.eyeOpen,
                    coinAmount: WalletService.service.getTokenBalance(
                        WalletService.service.tokenList[index - 1]),
                    coinAmountCurrency: WalletService.service
                        .getTokenCurrencyBalance(
                            WalletService.service.tokenList[index - 1]),
                  );
          },
          onRefresh: controller.onRefresh,
          itemCount: WalletService.service.tokenList.length + 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PropertyController>(
        init: controller,
        builder: (controller) {
          return WalletService.service.currentCoin == null
              ? NoWalletView(
                  onTapCreateWallet: () {
                    //HomeController.checkDatabase4OldVersion();
                    Get.toNamed(Routes.WALLET_MANAGE);
                  },
                )
              : _buildPropertyView();
        });
  }
}

class _TopBar extends GetView<PropertyController>
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(44.h.ceilToDouble());

  void _showOptionsPopupMenu(BuildContext context) {
    Get.generalDialog(
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      // 自定义遮罩颜色
      pageBuilder: (context, animation, secondaryAnimation) {
        double heightCut = 0;
        if (WalletService.service.currentWallet!.mnemonic != null) {
          heightCut += 48;
        }
        if (WalletService.service.currentCoin!.coinUnit !=
                QiCoinType.ETH.coinUnit() &&
            WalletService.service.currentCoin!.coinUnit !=
                QiCoinType.AITD.coinUnit()) {
          heightCut += 48;
        }
        return Builder(builder: (context) {
          return Align(
            alignment: Alignment.topRight,
            child: Material(
              color: const Color(0x00000000),
              child: InkWell(
                highlightColor: Colors.transparent,
                radius: 0,
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 85, right: 15),
                  decoration: const BoxDecoration(
                    color: Colors.white, // 底色
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),
                  child: SizedBox(
                    height: 340 - heightCut,
                    width: LocalService.to.languageCode == 'jp'
                        ? 268.w
                        : LocalService.to.languageCode == 'en'
                            ? 198.w
                            : 150.w,
                    child: Column(
                      children: [
                        _buildOptionMenu(
                          iconPath: 'property/option_edit',
                          title: I18nKeys.changeWalletName,
                          onTap: () => UniModals.showSingleTextFieldModal(
                            title: Text(I18nKeys.changeWalletName),
                            hintText: I18nKeys.pleaseEnterWalletName,
                            initialText:
                                WalletService.service.currentWallet!.walletName,
                            onConfirm: (newName) async {
                              WalletService.service.currentWallet!.walletName =
                                  newName;
                              await DBService.to.walletDao.saveAndReturnId(
                                  WalletService.service.currentWallet!);
                              controller.update();
                              Get.back();
                              Get.showTopBanner(
                                I18nKeys.modifiedSuccessfully,
                                style: TopBannerStyle.Default,
                              );
                            },
                          ),
                        ),
                        WalletService.service.currentWallet!.mnemonic != null
                            ? _buildOptionMenu(
                                iconPath: 'property/option_mnemonic',
                                title: I18nKeys.backUpAuxWord,
                                onTap: () {
                                  UniModals.showVerifySecurityPasswordModal(
                                    onSuccess: () async {},
                                    onPasswordGet: (password) {
                                      Get.toNamed(
                                        Routes.WALLET_EXPORT,
                                        arguments: WalletExportArgs(
                                            mode: WalletExportMode.Mnemonic,
                                            coin: WalletService
                                                .service.currentCoin!,
                                            password: password),
                                      );
                                    },
                                  );
                                },
                              )
                            : Container(),
                        _buildOptionMenu(
                          iconPath: 'property/option_private',
                          title: I18nKeys.exportPrivateKey,
                          onTap: () {
                            UniModals.showVerifySecurityPasswordModal(
                                onSuccess: () async {},
                                onPasswordGet: (password) {
                                  Get.toNamed(
                                    Routes.WALLET_EXPORT,
                                    arguments: WalletExportArgs(
                                      mode: WalletExportMode.PrivateKey,
                                      password: password,
                                      coin: WalletService.service.currentCoin!,
                                    ),
                                  );
                                });
                          },
                        ),
                        (WalletService.service.currentCoin!.coinUnit ==
                                    QiCoinType.ETH.coinUnit() ||
                                WalletService.service.currentCoin!.coinUnit ==
                                    QiCoinType.AITD.coinUnit())
                            ? _buildOptionMenu(
                                iconPath: 'property/option_keystore',
                                title: I18nKeys.exportKeystore,
                                onTap: () {
                                  UniModals.showVerifySecurityPasswordModal(
                                      onSuccess: () async {},
                                      onPasswordGet: (password) {
                                        Get.toNamed(
                                          Routes.WALLET_EXPORT,
                                          parameters: {'password': password},
                                          arguments: WalletExportArgs(
                                              mode: WalletExportMode.Keystore,
                                              coin: WalletService
                                                  .service.currentCoin!,
                                              password: password),
                                        );
                                      });
                                },
                              )
                            : Container(),
                        _buildOptionMenu(
                            iconPath: 'property/option_delete',
                            title: I18nKeys.deleteWallet,
                            onTap: () {
                              UniModals.showVerifySecurityPasswordModal(
                                title: Text(I18nKeys.deleteWallet),
                                confirm: Text(I18nKeys.confirmDelete),
                                onSuccess: () {
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
                                      Get.back();

                                      final coin =
                                          WalletService.service.currentCoin!;

                                      List<Coin> coins = await DBService
                                          .service.coinDao
                                          .findAllByWalletId(coin.walletId!);
                                      if (coins.length == 1) {
                                        //如果只有一个币了，删除该钱包
                                        Wallet? wallet = await DBService
                                            .service.walletDao
                                            .findById(coin.walletId!);
                                        if (wallet != null) {
                                          DBService.service.walletDao
                                              .deleteAndReturnChangedRows(
                                                  wallet);
                                        }
                                      }
                                      DBService.to.coinDao
                                          .deleteAndReturnChangedRows(coin);
                                      await controller.reselectAddress();
                                      Get.find<HomeController>().checkConnect();
                                      Get.back();
                                      Get.showTopBanner(
                                          I18nKeys.confirmTheDeletion);
                                    },
                                  );
                                },
                              );
                            }),
                        _buildOptionMenu(
                          iconPath: 'property/option_add',
                          title: I18nKeys.addCurrency,
                          onTap: () async {
                            if (WalletService.service.currentCoin!.coinUnit ==
                                QiCoinType.SOL.coinUnit()) {
                              _showSolOptionsPopupMenu(context);
                              return;
                            }
                            Get.toNamed(Routes.TOKEN_LIST);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _showSolOptionsPopupMenu(BuildContext context) {
    Get.generalDialog(
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      // 自定义遮罩颜色
      pageBuilder: (context, animation, secondaryAnimation) {
        return Builder(builder: (context) {
          return Align(
            alignment: Alignment.topRight,
            child: Material(
              color: const Color(0x00000000),
              child: InkWell(
                highlightColor: Colors.transparent,
                radius: 0,
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 85, right: 15),
                  decoration: const BoxDecoration(
                    color: Colors.white, // 底色
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),
                  child: SizedBox(
                    height: 108,
                    width: LocalService.to.languageCode == 'jp'
                        ? 268.w
                        : LocalService.to.languageCode == 'en'
                            ? 198.w
                            : 150.w,
                    child: Column(
                      children: [
                        _buildOptionMenu(
                            iconPath: 'property/option_delete',
                            title: '添加代币',
                            onTap: () {
                              UniModals.showVerifySecurityPasswordModal(
                                title: Text(
                                    I18nKeys.pleaseEnterYourWalletPassword),
                                confirm: Text('下一步'),
                                onSuccess: () {},
                                onPasswordGet: (pwd) async {
                                  UniModals.showSolInputModal(
                                    title: Text('请输入合约地址'),
                                    confirm: Text('创建代币'),
                                    onPasswordGet: (contractAddress, add) async {
                                      Toast.showLoading();
                                      final coin = WalletService.service.currentCoin!;
                                      try{
                                        String address = await addSolanaToken(
                                            QiRpcService().currentNodeUrl,
                                            WalletCreateController.decrypt(
                                                coin.privateKey!, pwd),
                                            contractAddress);
                                        Token token = Token(
                                          coinId: coin.id,
                                          coinType: coin.coinType,
                                          tokenName: address,
                                          tokenType: 'solana token',
                                          contractAddress: contractAddress,
                                          tokenIcon: 'property/icon_coin_sol',
                                          tokenUnit: contractAddress,
                                          tokenDecimals: 9,
                                          description: contractAddress,
                                          dappUrl: contractAddress,
                                          tokenUrl: contractAddress,);
                                        token.preHandle();
                                        await DBService.to.tokenDao.saveAndReturnId(token);
                                        await controller.getTokenList();
                                      }catch(e){
                                        print(e);
                                      }
                                      Toast.hideLoading();
                                    },
                                  );
                                },
                              );
                            }),
                        _buildOptionMenu(
                          iconPath: 'property/option_add',
                          title: '导入代币',
                          onTap: () async {
                            UniModals.showSolInputModal(
                              title: Text('请输入代币信息'),
                              confirm: Text('导入代币'),
                              showSecond: true,
                              onPasswordGet: (contractAddress, address) async {
                                Toast.showLoading();
                                final coin = WalletService.service.currentCoin!;
                                Token token = Token(
                                  coinId: coin.id,
                                  coinType: coin.coinType,
                                  tokenName: address,
                                  tokenType: 'solana token',
                                  contractAddress: contractAddress,
                                  tokenIcon: 'property/icon_coin_sol',
                                  tokenUnit: contractAddress,
                                  tokenDecimals: 9,
                                  description: contractAddress,
                                  dappUrl: contractAddress,
                                  tokenUrl: contractAddress,);
                                token.preHandle();
                                await DBService.to.tokenDao.saveAndReturnId(token);
                                await controller.getTokenList();
                                Toast.hideLoading();
                              },
                            );

                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildOptionMenu({
    required String iconPath,
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: () {
        Get.back();
        onTap?.call();
      },
      child: Container(
        height: 48,
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 13, bottom: 13),
        child: Row(
          children: [
            WalletLoadAssetImage(iconPath, width: 18, height: 18),
            const SizedBox(width: 13),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: controller.gradient[0],
      child: Obx(
        () => Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: InkWell(
                onTap: () => Get.bottomSheet(
                  SwitchWalletModal(
                    coinType: QiCoinCode44.parse(
                        WalletService.service.currentCoin!.coinType ?? ''),
                    onSelectedWalletCallback: (coin) {
                      controller.onAddressSelect(coin);
                      Get.back();
                    },
                  ),
                  isScrollControlled: true,
                ),
                child: Opacity(
                  opacity: controller.barOpacity,
                  child: Container(
                    height: 26.h,
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0x11FFFFFF), width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WalletLoadAssetImage(
                          'property/icon_coin_${QiRpcService().coinType.chainName().toLowerCase()}',
                          width: 15,
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, right: 5),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 128),
                            child: Text(
                              WalletManageController.getWalletName(
                                  WalletService.service.currentWallet),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: WalletLoadAssetImage(
                            'property/icon_arrow_down',
                            width: 10.sp,
                            height: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Opacity(
                opacity: 1 - controller.barOpacity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WalletLoadAssetImage(
                        'property/icon_coin_${QiRpcService().coinType.chainName().toLowerCase()}',
                        width: 15,
                        height: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        QiRpcService().coinType.chainName(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 8,
              child: Opacity(
                opacity: controller.barOpacity,
                child: Row(
                  children: [
                    IconButton(
                      icon: WalletLoadAssetImage(
                        'property/icon_wallet',
                        width: 25.sp,
                        height: 25.sp,
                      ),
                      onPressed: () => Get.toNamed(Routes.WALLET_MANAGE),
                    ),
                    IconButton(
                      icon: WalletLoadAssetImage(
                        'property/icon_set',
                        width: 25.sp,
                        height: 25.sp,
                      ),
                      onPressed: () => _showOptionsPopupMenu(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
