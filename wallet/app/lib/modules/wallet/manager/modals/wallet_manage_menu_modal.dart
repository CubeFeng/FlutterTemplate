import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/home/controllers/home_controller.dart';
import 'package:flutter_wallet/modules/property/controllers/property_controller.dart';
import 'package:flutter_wallet/modules/wallet/export/controllers/wallet_export_controller.dart';
import 'package:flutter_wallet/modules/wallet/manager/controllers/wallet_manage_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

class WalletManageMenuModal extends StatefulWidget {
  final Coin coin;
  final Wallet wallet;

  const WalletManageMenuModal(
      {Key? key, required this.coin, required this.wallet})
      : super(key: key);

  @override
  State<WalletManageMenuModal> createState() => _WalletManageMenuModalState();
}

class _WalletManageMenuModalState extends State<WalletManageMenuModal>
    with WidgetsBindingObserver {
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
      padding: EdgeInsets.only(
        top: 15.h,
        bottom: 20.h + Get.safetyBottomBarHeight,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.r),
          topRight: Radius.circular(15.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(
            iconPath: 'property/option_edit',
            title: I18nKeys.changeWalletName,
            onTap: () async {
              UniModals.showSingleTextFieldModal(
                title: Text(I18nKeys.changeWalletName),
                hintText: I18nKeys.pleaseEnterWalletName,
                initialText: widget.wallet.walletName,
                onConfirm: (newName) async {
                  if (widget.wallet.id ==
                      WalletService.service.currentWallet!.id) {
                    WalletService.service.currentWallet!.walletName = newName;
                    await DBService.to.walletDao
                        .saveAndReturnId(WalletService.service.currentWallet!);
                    Get.find<PropertyController>().update();
                  } else {
                    widget.wallet.walletName = newName;
                    await DBService.service.walletDao
                        .saveAndReturnId(widget.wallet);
                  }
                  Get.find<WalletManageController>().onReady();
                  Get.back();
                  Get.showTopBanner(I18nKeys.modifiedSuccessfully);
                },
              );
            },
          ),
          widget.wallet.mnemonic != null
              ? Column(children: [
                  _buildDivider(),
                  _buildMenuItem(
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
                                coin: widget.coin,
                                password: password,
                              ),
                            );
                          });
                    },
                  ),
                ])
              : Container(),
          _buildDivider(),
          _buildMenuItem(
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
                      coin: widget.coin,
                      password: password,
                    ),
                  );
                },
              );
            },
          ),
          _buildDivider(),
          (widget.coin.coinUnit == QiCoinType.ETH.coinUnit() ||
                  widget.coin.coinUnit == QiCoinType.AITD.coinUnit())
              ? _buildMenuItem(
                  iconPath: 'property/option_keystore',
                  title: I18nKeys.exportKeystore,
                  onTap: () {
                    UniModals.showVerifySecurityPasswordModal(
                      onSuccess: () {},
                      onPasswordGet: (password) {
                        Get.toNamed(
                          Routes.WALLET_EXPORT,
                          parameters: {'password': password},
                          arguments: WalletExportArgs(
                            mode: WalletExportMode.Keystore,
                            coin: widget.coin,
                            password: password,
                          ),
                        );
                      },
                    );
                  },
                )
              : Container(),
          _buildDivider(),
          _buildMenuItem(
              iconPath: 'property/option_delete',
              title: I18nKeys.deleteWallet,
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
                        List<Coin> coins = await DBService.service.coinDao
                            .findAllByWalletId(widget.coin.walletId!);
                        if (coins.length == 1) {
                          //如果只有一个币了，删除该钱包
                          Wallet? wallet = await DBService.service.walletDao
                              .findById(widget.coin.walletId!);
                          if (wallet != null) {
                            DBService.service.walletDao
                                .deleteAndReturnChangedRows(wallet);
                          }
                        }
                        DBService.to.coinDao
                            .deleteAndReturnChangedRows(widget.coin);
                        if (widget.coin.id ==
                            WalletService.service.currentCoin!.id) {
                          await Get.find<PropertyController>()
                              .reselectAddress();
                        }
                        Get.find<WalletManageController>().onReady();
                        Get.find<HomeController>().checkConnect();
                        Get.back();
                        Get.showTopBanner(I18nKeys.confirmTheDeletion);
                      },
                    );
                  },
                );
              }),
          _buildPartDivider(),
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => Get.back(),
              child: SizedBox(
                height: 64.h,
                child: Center(
                    child: Text(
                  I18nKeys.cancel,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 64.h,
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Get.back();
            onTap();
          },
          child: Row(
            children: [
              SizedBox(width: 27.w),
              WalletLoadAssetImage(iconPath,
                  width: 18.w, height: 18.h, fit: BoxFit.cover),
              SizedBox(width: 16.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartDivider() =>
      Container(height: 6.h, color: const Color(0xFFF8F8F8));

  Widget _buildDivider() =>
      Container(height: 1.h, color: const Color(0xFFF8F8F8));
}
