import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:get/get.dart';

///
class HDWalletNetworkController extends GetxController {
  late Coin coin;
  List<Coin> coinList = [];

  @override
  void onInit() {
    super.onInit();
    coin = Get.arguments;
  }

  hasCoin(QiCoinType coinType) {
    for (var element in coinList) {
      if (element.coinUnit == coinType.coinUnit()) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    Wallet? wallet = await DBService.service.walletDao.findById(coin.walletId!);
    coinList = await DBService.service.coinDao.findAllByWalletId(wallet!.id!);
    update();
  }

  bool isSelected() {
    for (var element in selectedStatus.keys) {
      if (selectedStatus[element]!) {
        return true;
      }
    }
    return false;
  }

  Map<QiCoinType, bool> selectedStatus = {};

  void switchChainStatus(QiCoinType coinType) {
    if (selectedStatus[coinType] == null || !selectedStatus[coinType]!) {
      selectedStatus[coinType] = true;
    } else {
      selectedStatus[coinType] = false;
    }
    update();
  }
}
