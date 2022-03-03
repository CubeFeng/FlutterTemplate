import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:get/get.dart';

///
class HDWalletManageController extends GetxController {
  late Coin coin;
  List<Coin> coinList = [];
  String walletName = '';

  @override
  void onInit() {
    super.onInit();
    coin = Get.arguments;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    Wallet? wallet = await DBService.service.walletDao.findById(coin.walletId!);
    if (wallet != null) {
      walletName = wallet.walletName ?? '';
      if (walletName.isEmpty) {
        String positionStr =
            wallet.id! < 10 ? ("0${wallet.id}") : ("${wallet.id}");
        walletName = "${I18nKeys.hdWallet}-$positionStr";
      }
    }
    List<Coin> coinLists = await DBService.service.coinDao.findAllByWalletId(wallet!.id!);
    for (var element in coinLists) {
      for (var coinType in QiRpcService().supportCoins) {
        if (element.coinUnit == coinType.coinUnit()) {
          coinList.add(element);
        }
      }
    }
    update();
    await WalletService.service.refreshCoinBalance(coinList, refresh: false);
    update();
  }

  isSelect(Coin coin) {
    if (coin.id == WalletService.service.currentCoin!.id) {
      return true;
    }
    return false;
  }

  isFullChain() {
    bool full = true;
    for (var coinType in QiRpcService().supportCoins) {
      bool contain = false;
      for (var element in coinList) {
        if (element.coinUnit == coinType.coinUnit()) {
          contain = true;
        }
      }
      print(contain);
      if (!contain) {
        full = false;
      }
    }
    return full;
  }
}
