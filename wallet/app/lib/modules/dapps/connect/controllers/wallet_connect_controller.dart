import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/dapps/connect/controllers/wallet_connect_history_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/wallet_connect_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

class WalletConnectController extends GetxController {
  final String connectUrl = Get.parameters["connectUrl"] ?? "";

  ConnectService connectService = ConnectService();
  Coin? coin;
  Wallet? wallet;

  @override
  void onReady() {
    super.onReady();
    connectService = WalletConnectService.service.qrScanHandler(connectUrl);
    connectService.setListener(() async {
      if(Get.isRegistered<WalletConnectController>()){
        if (connectService.status == '1') {
          QiCoinType coinType =
          qiFindChainById(connectService.getWCClient().chainId);
          if (coinType == QiRpcService().coinType) {
            coin = WalletService.service.currentCoin;
            wallet = WalletService.service.currentWallet;
          } else {
            await initCoinInfo();
          }
          update();
          return;
        }
        if (connectService.status == '2') {
          Get.back();
          Get.toNamed(Routes.Dapp_Wallet_Connect_Detail,
              parameters: {"connectUrl": connectService.connectUrl});
          return;
        }
        if (connectService.status == '3') {
          if (connectService.preStatus == '0') {
            Get.back();
          }
          Get.showTopBanner(I18nKeys.connectionFailedPleaseCheckTheNetwork);
          return;
        }
        update();
      }
    });
    connectService.connect(connectUrl);

    DBService.service.dbChanged.listen((_) async {
      print('dbChanged');
      await initCoinInfo();
      update();
    });
  }

  initCoinInfo() async {
    if (coin == null) {
      final coinList = await DBService.to.coinDao.findAll();
      if (coinList.isNotEmpty) {
        QiCoinType coinType =
            qiFindChainById(connectService.getWCClient().chainId);
        for (var element in coinList) {
          if (element.coinType == coinType.chainName()) {
            coin = element;
          }
        }
        if (coin != null) {
          wallet =
              (await DBService.service.walletDao.findById(coin!.walletId!))!;
          await WalletService.service.refreshCoinBalance([coin!]);
        }
      }
    }
  }

  @override
  onClose() {
    super.onClose();
    if (connectService.isConnecting()) {
      connectService.killSession();
    }
  }

  connectToPreviousSession() {
    connectService.connectToPreviousSession();
  }

  approveSession() {
    if (coin == null) {
      QiCoinType coinType =
          qiFindChainById(connectService.getWCClient().chainId);
      //还没添加过钱包，弹窗提示
      UniModals.showGeneralSingleActionPromptModal(
          message: Text(
              I18nRawKeys
                  .thisDAPPOnlySupportsChainYouDontHaveWalletYetDoYouWantToAddWallet
                  .trPlaceholder([coinType.coinUnit(), coinType.coinUnit()]),
              textAlign: TextAlign.center),
          actionTitle: I18nKeys.addWallet,
          image: const WalletLoadAssetImage("user/icon_dapp_tip"),
          onConfirm: () {
            Get.back();
            Get.toNamed(Routes.WALLET_MANAGE);
          });
      return;
    }
    try {
      connectService.approveSession(coin!);
    } catch (e) {
      Get.back();
      Get.showTopBanner(I18nKeys.connectionFailedPleaseCheckTheNetwork);
    }
  }

  rejectSession() {
    connectService.rejectSession();
  }

  killSession() {
    connectService.killSession();
  }

  Future<void> selectCoin(Coin coin) async {
    this.coin = coin;
    await WalletService.service.refreshCoinBalance([coin]);
    wallet = (await DBService.service.walletDao.findById(coin.walletId!))!;
    update();
  }
}
