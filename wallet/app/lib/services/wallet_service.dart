import 'dart:convert' as convert;

import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/apis/api_urls.dart';
import 'package:flutter_wallet/modules/dapps/controllers/dapp_browser_controller.dart';
import 'package:flutter_wallet/modules/dapps/handler/dapp_javascript_handler.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet_chain/api/rpc/rpc_sol.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_dapp_browser/flutter_wallet_dapp_browser.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

import 'db_service.dart';
import 'http_service.dart';

/// 数据库服务
class WalletService extends GetxService {
  /// 数据库服务实例
  static WalletService get to => Get.find();

  /// 数据库服务实例
  static WalletService get service => Get.find();

  ///
  List<Token> tokenList = [];

  ///当前使用的地址
  Coin? currentCoin;
  Wallet? currentWallet;

  ///
  QiCoinType? selectCoinType;

  @override
  void onInit() {
    super.onInit();
    loadCoin();
  }

  loadCoin() {
    /// 获取上一次选中使用的地址
    final selectCoinMap =
        StorageUtils.sp.read<Map<String, dynamic>>('currentCoin');
    if (selectCoinMap != null) {
      currentCoin = Coin.fromMap(selectCoinMap);
    }
    if (currentCoin != null) {
      final selectCoinType = QiCoinCode44.parse(currentCoin!.coinType ?? '');
      QiRpcService().switchChain(
          selectCoinType,
          StorageUtils.sp
              .read<String>('currentNode-' + (currentCoin!.coinType ?? '')));
      //currentCoin!.coinAddress = '0xef6881ae30792f2a973b0256588b5aefb06b1641';//设置测试地址，方便调试
    }
  }

  refreshBalance() async {
    await refreshCoinBalance([currentCoin!]);
    await refreshTokenBalance(tokenList, currentCoin!);
  }

  resetCoin(Coin coin) {
    currentCoin = coin;
    coin.createTime = null;
    coin.updateTime = null;
    StorageUtils.sp.write('currentCoin', coin.toMap());
  }

  /// 重新选择地址
  reselectAddress() async {
    print('>>reselectAddress>>');
    currentCoin = null;
    final coinList = await DBService.to.coinDao.findAll();
    if (coinList.isNotEmpty) {
      for (var element in coinList) {
        if (element.coinType ==
                QiRpcService().currentRpc.coinType.chainName() &&
            currentCoin == null) {
          currentCoin = element;
        }
      }
      currentCoin ??= coinList[0];
      selectCoinType = QiCoinCode44.parse(currentCoin!.coinType!);
      QiRpcService().switchChain(
          selectCoinType!,
          StorageUtils.sp
              .read<String>('currentNode-' + (currentCoin!.coinType ?? '')));
      await StorageUtils.sp.write('coinType', selectCoinType!.chainName());

      currentCoin!.createTime = null;
      currentCoin!.updateTime = null;
      await StorageUtils.sp.write('currentCoin', currentCoin!.toMap());
    } else {
      await StorageUtils.sp.delete('currentCoin');
    }
  }

  checkEmpty() async {
    if (currentCoin == null) {
      final coinList = await DBService.to.coinDao.findAll();
      if (coinList.isNotEmpty) {
        //第一次本地新增地址触发，自动选中默认的链地址
        for (var element in coinList) {
          if (element.coinType == QiRpcService().coinType.chainName()) {
            currentCoin = element;
          }
        }
        currentCoin ??= coinList[0];
        if (currentCoin != null) {
          selectCoinType = QiCoinCode44.parse(currentCoin!.coinType!);
          QiRpcService().switchChain(
              selectCoinType!,
              StorageUtils.sp.read<String>(
                  'currentNode-' + (currentCoin!.coinType ?? '')));
          await StorageUtils.sp.write('coinType', selectCoinType!.chainName());
          currentCoin!.createTime = null;
          currentCoin!.updateTime = null;
          await StorageUtils.sp.write('currentCoin', currentCoin!.toMap());
        }
      }
    }
  }

  changeNodeUrl(QiCoinType coin, String node) {
    if (currentCoin != null) {
      if (currentCoin!.coinUnit == coin.coinUnit()) {
        DappsBrowserService.service.config(
            chainId: QiRpcService().currentRpc.chainId,
            rpcUrl: node,
            javaScriptHandler: JavaScriptHandler(),
            navigationActionHandler: NavigationActionHandler());
      }
    }
  }

  getTokenList() async {
    currentWallet =
        await DBService.to.walletDao.findById(currentCoin!.walletId!);
    String? node =
        StorageUtils.sp.read<String>('currentNode-' + (currentCoin!.coinUnit!));
    DappsBrowserService.service.config(
        chainId: QiRpcService().currentRpc.chainId,
        rpcUrl: node ?? QiRpcService().currentRpc.nodes[0],
        javaScriptHandler: JavaScriptHandler(),
        navigationActionHandler: NavigationActionHandler());
    tokenList =
        await DBService.to.tokenDao.findAllByCoinType(currentCoin!.coinType!);
  }

  ///汇率
  Map<String, dynamic> coinRateMaps = {};

  refreshCoinRate() async {
    ResponseModel<String> coinRate =
        await HttpService.service.http.get<String>(ApiUrls.getCoinRate);
    final String response;
    if (coinRate.data != null) {
      response = coinRate.data!;
      StorageUtils.sp.write('coinRate', response);
    } else {
      String? localCache = StorageUtils.sp.read<String>('coinRate');
      if (localCache != null) {
        response = localCache;
      } else {
        response = '{}';
      }
    }
    coinRateMaps = convert.jsonDecode(response);
  }

  /// 代币的余额
  final tokenAmountMaps = {};

  /// 主币的余额
  final amountMap = {};

  double getTotalBalanceCurrency(Coin coin) {
    if (currentCoin == null) {
      return 0.0;
    }
    return getTotalBalance(coin, tokenCache[coin] ?? []);
  }

  getTotalBalance(Coin coin, List<Token> tokenList) {
    double totalBalance = 0;
    //代币数量
    for (var element in tokenList) {
      if (!element.tokenType!.endsWith('721')) {
        totalBalance += getTokenCurrencyBalance(element, coin: coin);
      }
    }

    double amountCount = amountMap[coin] ?? 0;
    totalBalance += getCurrencyBalance(amountCount, coin, null);

    return totalBalance;
  }

  getCoinBalance(Coin? coin) {
    if (amountMap.containsKey(coin)) {
      String balanceStr = amountMap[coin].toString();
      if (balanceStr.contains('e')) {
        return '0';
      }
      int index = balanceStr.indexOf('.');
      if (index > 0) {
        if (balanceStr.length - index > 6) {
          String repBalance = balanceStr.replaceAll('0', '');
          if (repBalance == '.') {
            return '0';
          } else {
            return amountMap[coin].toStringAsFixed(6);
          }
        } else {
          String repBalance = balanceStr.replaceAll('0', '');
          if (repBalance == '.') {
            return '0';
          } else {
            return balanceStr;
          }
        }
      } else {
        return balanceStr;
      }
    }
    return '-';
  }

  getCoinBalanceDouble(Coin coin) {
    return amountMap[coin] ?? 0;
  }


  refreshCoinBalance(List<Coin> coinList, {refresh = true}) async {
    for (var coin in coinList) {
      if (amountMap.containsKey(coin)) {
        if (!refresh) {
          continue;
        }
      }
      try {
        final BigInt amount;
        QiCoinType coinType = QiCoinCode44.parse(coin.coinType!);
        if (QiRpcService().coinType == coinType) {
          amount = await QiRpcService().getBalance(coin.coinAddress!);
        } else {
          String? node =
              StorageUtils.sp.read<String>('currentNode-' + (coin.coinUnit!));
          amount = await QiRpcService.getCoinBalance(coinType, node, coin.coinAddress!);
        }
        amountMap[coin] = amount / BigInt.from(10).pow(coin.coinDecimals!);
        StorageUtils.sp
            .write(coin.coinUnit! + ':' + coin.coinAddress!, amountMap[coin]);
      } catch (e) {
        print(e);
        amountMap[coin] = StorageUtils.sp
            .read<double>(coin.coinUnit! + ':' + coin.coinAddress!, 0);
      }
    }
  }

  getCoinBalanceCurrency(Coin coin) {
    double balance = amountMap[coin] ?? 0;
    return getCurrencyBalance(balance, coin, null);
  }

  getTokenBalance(Token token, {coin}) {
    coin ??= currentCoin;
    Map tokenAmountMap = tokenAmountMaps[coin] ?? {};
    if (tokenAmountMap.containsKey(token)) {
      String balanceStr = tokenAmountMap[token].toString();
      if (balanceStr.contains('e')) {
        return '0';
      }
      int index = balanceStr.indexOf('.');
      if (index > 0) {
        if (balanceStr.length - index > 6) {
          String repBalance = balanceStr.replaceAll('0', '');
          if (repBalance == '.') {
            return '0';
          } else {
            return tokenAmountMap[token].toStringAsFixed(6);
          }
        } else {
          String repBalance = balanceStr.replaceAll('0', '');
          if (repBalance == '.') {
            return '0';
          } else {
            if (balanceStr.contains('e')) {
              return '0';
            }
            return balanceStr;
          }
        }
      } else {
        return balanceStr;
      }
    }
    return '-';
  }

  getTokenBalanceDouble(Token token, {coin}) {
    coin ??= currentCoin;
    Map tokenAmountMap = tokenAmountMaps[coin] ?? {};
    return tokenAmountMap[token] ?? 0;
  }

  Map tokenCache = {};

  refreshTokenBalance(List<Token> tokenList, Coin coin) async {
    tokenCache[coin] = tokenList;
    tokenAmountMaps[coin] ??= {};
    for (var token in tokenList) {
      try {
        final amount = await QiRpcService()
            .getTokenBalance(token.contractAddress!, coin.coinAddress!);
        tokenAmountMaps[coin][token] =
            amount / BigInt.from(10).pow(token.tokenDecimals!);
        StorageUtils.sp.write(
            coin.coinAddress! +
                '>' +
                token.tokenUnit! +
                ':' +
                token.contractAddress!,
            tokenAmountMaps[coin][token]);
      } catch (e) {
        print(e);
        tokenAmountMaps[coin][token] = StorageUtils.sp.read<double>(
            coin.coinAddress! +
                '>' +
                token.tokenUnit! +
                ':' +
                token.contractAddress!,
            0);
      }
    }
  }

  ///通过token coin balance转换相应法币
  getTokenCurrencyBalance(Token token, {coin}) {
    coin ??= currentCoin;
    Map tokenAmountMap = tokenAmountMaps[coin] ?? {};
    if (token.tokenType!.endsWith('721')) {
      return null;
    }
    double amountCount = (tokenAmountMap[token] ?? 0);
    return getCurrencyBalance(amountCount, coin, token.contractAddress);
  }

  ///通过coin balance转换相应法币
  getCurrencyBalance(double balance, Coin? coin, String? contractAddress) {
    coin ??= currentCoin;
    if (contractAddress != null && contractAddress.isNotEmpty) {
      balance = balance * double.parse((coinRateMaps[contractAddress] ?? '1'));
    } else {
      balance = balance *
          double.parse(
              (coinRateMaps[coin!.coinUnit!.toLowerCase() + 'usdt'] ?? '1'));
    }
    String coinRateKey =
        "usd" + LocalService.to.currencyObservable.value.toLowerCase();

    balance = balance * double.parse((coinRateMaps[coinRateKey] ?? '1'));
    return balance;
  }
}
