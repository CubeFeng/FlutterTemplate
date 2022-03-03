import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/wallet/create/controllers/wallet_create_controller.dart';
import 'package:flutter_wallet/modules/wallet/manager/modals/wallet_choice_type_modal.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:get/get.dart';

///
class WalletManageController extends GetxController {
  ///
  final Map<QiCoinType, List<Coin>> coinsMap = {};
  late List<Wallet> wallets;

  ///
  QiCoinType? selectCoinType = QiRpcService().supportCoins[0];

  @override
  void onInit() {
    coinsMap[selectCoinType!] = [];
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    cachePassword = null;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    reload();
  }

  Future<void> reload() async {
    print('WalletManageController reload');
    wallets = await DBService.service.walletDao.findAll();
    for (var element in QiRpcService().supportCoins) {
      final coinList =
          await DBService.to.coinDao.findAllByCoinType(element.chainName());
      coinsMap[element] = coinList;
      print('$element : ${coinList.length}' );
    }
    update();
    await WalletService.service
        .refreshCoinBalance(coinsMap[selectCoinType!]!, refresh: false);
    update();
  }

  ///是否是HD钱包
  static bool isHD(List<Wallet> wallets, Coin coin) {
    bool res = false;
    for (var element in wallets) {
      if (element.id == coin.walletId) {
        res = element.walletType == WalletType.HD;
      }
    }
    return res;
  }

  ///是否是HD钱包
  static bool isHDWallet(Wallet? wallet) {
    if (wallet == null) {
      return false;
    }
    return wallet.walletType == WalletType.HD;
  }

  ///获取钱包名称
  static String getCoinWalletName(List<Wallet> wallets, Coin coin) {
    for (var element in wallets) {
      if (element.id == coin.walletId) {
        return getWalletName(element);
      }
    }
    return '';
  }

  popDialog(password) {
    cachePassword = password;
    final coinType = selectCoinType!;
    Get.dialog(
      WalletChoiceTypeModal(chainName: coinType.chainName()),
      useSafeArea: false,
      transitionDuration: const Duration(milliseconds: 100),
    );
  }

  ///获取钱包名称
  static String getWalletName(Wallet? wallet) {
    if (wallet == null) {
      return '';
    }
    String name = wallet.walletName ?? '';
    if (name.isEmpty) {
      String positionStr =
          wallet.id! < 10 ? ("0${wallet.id}") : ("${wallet.id}");
      if (wallet.walletType == WalletType.HD) {
        name = "${I18nKeys.hdWallet}-$positionStr";
      } else {
        name =
            "${wallet.walletSource == WalletSource.CREATE ? I18nKeys.createWallet : I18nKeys.importWallet.trPlaceholder([
                    ''
                  ])}-$positionStr";
      }
    }
    return name;
  }

  ///
  Future<void> selectTab(QiCoinType e) async {
    selectCoinType = e;
    update();

    await WalletService.to.refreshCoinBalance(
      coinsMap[selectCoinType] ?? [],
      refresh: true,
    );
    update();

    for (Coin coin in (coinsMap[selectCoinType] ?? [])) {
      if (coin.coinUnit == WalletService.service.currentCoin!.coinUnit) {
        await WalletService.to
            .refreshTokenBalance(WalletService.service.tokenList, coin);
      } else {
        List<Token> tokenList =
            await DBService.service.tokenDao.findAllByCoinType(coin.coinType!);
        await WalletService.to.refreshTokenBalance(tokenList, coin);
      }
    }
    update();
  }

  isSelect(Coin coin) {
    if (WalletService.service.currentCoin == null) {
      return false;
    }
    return coin.id == WalletService.service.currentCoin!.id;
  }
}
