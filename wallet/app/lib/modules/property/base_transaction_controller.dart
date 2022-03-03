import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/models/token_info_model.dart';
import 'package:flutter_wallet/modules/wallet/create/controllers/wallet_create_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';

import 'math_util.dart';

extension CoinIcon on Coin {
  String getIcon() {
    return 'property/icon_coin_${coinUnit!.toLowerCase()}';
  }
}

///
abstract class BaseTransactionController extends GetxController {
  ///
  TextEditingController addressController = TextEditingController();

  ///
  TextEditingController amountController = TextEditingController();

  ///
  TextEditingController gasLimitController = TextEditingController();

  ///
  TextEditingController gasPriceController = TextEditingController();

  ///
  TextEditingController nonceController = TextEditingController();

  FocusNode focusNodeGasPrice = FocusNode();
  FocusNode focusNodeGasLimit = FocusNode();
  FocusNode focusNodeNonce = FocusNode();

  var gasLimitError = true.obs;
  var gasPriceError = true.obs;
  var nonceError = true.obs;
  var gasValue = ''.obs;
  var gasValueCurrency = ''.obs;

  scanAddress(String address) {
    addressController.text = address;
    checkComplete(true);
  }

  double solFee = 0.000005;
  calculate() {
    if(coinInfo.coinUnit == 'SOL'){
      double fee = solFee;
      gasValue.value = fee.toStringAsFixed(6) + "" + coinInfo.coinUnit!;
      gasValueCurrency.value = "≈${LocalService.to.currencySymbol}" +
          WalletService.service.getCurrencyBalance(fee, null, null).toStringAsFixed(2) +
          "";
      return;
    }
    if (gasLimitError.isTrue || gasPriceError.isTrue) {
      gasValue.value = '--';
      gasValueCurrency.value = '';
    } else {
      double price = double.parse(gasPriceController.text);
      double limit = double.parse(gasLimitController.text);

      double fee = gasMathCustom(price, limit, custom: true);
      double feeDollar =
          WalletService.service.getCurrencyBalance(fee, null, null);
      gasValue.value = fee.toStringAsFixed(6) + "" + coinInfo.coinUnit!;
      gasValueCurrency.value = "≈${LocalService.to.currencySymbol}" +
          feeDollar.toStringAsFixed(2) +
          "";
    }
  }

  gasPriceErrorStr() {
    if (gasPriceController.text.isEmpty) {
      return I18nKeys.onlyNumbersCanBeEntered;
    }
    double limit = double.parse(gasPriceController.text);
    if (limit < 1) {
      return I18nKeys.onlyNumbersCanBeEntered;
    } else {
      return I18nKeys.onlyNumbersLes1000CanBeEntered;
    }
  }

  gasLimitErrorStr() {
    if (gasLimitController.text.isEmpty) {
      return I18nKeys.onlyNumbersCanBeEntered;
    }
    double limit = double.parse(gasLimitController.text);
    if (limit < 1) {
      return I18nKeys.onlyNumbersCanBeEntered;
    } else {
      return I18nKeys.onlyNumbersLes10000000000CanBeEntered;
    }
  }

  listenCustom() {
    gasLimitController.addListener(() {
      checkFeeError();
    });
    gasPriceController.addListener(() {
      checkFeeError();
    });
    nonceController.addListener(() {
      checkFeeError();
    });
  }

  checkFeeError() {
    if (gasLimitController.text.isEmpty) {
      gasLimitError.value = true;
    } else {
      double limit = double.parse(gasLimitController.text);
      if (limit < 1 || limit > pow(10, 10)) {
        gasLimitError.value = true;
      } else {
        gasLimitError.value = false;
      }
    }
    if (nonceController.text.isEmpty) {
      nonceError.value = true;
    } else {
      int n = int.parse(nonceController.text);
      nonceError.value = n < transactionCount!;
    }
    if (gasPriceController.text.isEmpty) {
      gasPriceError.value = true;
    } else {
      double price = double.parse(gasPriceController.text);
      if (price < 1 || price > 1000) {
        gasPriceError.value = true;
      } else {
        gasPriceError.value = false;
      }
    }
    calculate();
    checkComplete(false);
  }

  checkComplete(bool updateForce) {
    bool error = false;
    if (!isAddress(addressController.text, coin: coinInfo)) {
      error = true;
    } else if (amountController.text.isEmpty) {
      if (nftInfo == null) {
        error = true;
      }
    } else if (feeModeCustom) {
      error = gasLimitError.isTrue || gasPriceError.isTrue || nonceError.isTrue;
      if(coinInfo.coinUnit == 'SOL'){
        error = false;
      }
    }
    if (error != inputNotComplete) {
      inputNotComplete = error;
      update();
    } else {
      if (updateForce) {
        update();
      }
    }
  }

  bool inputNotComplete = true;

  ///
  double feePercent = 0.3;

  bool feeModeCustom = false;

  Future<void> switchFeeMode() async {
    feeModeCustom = !feeModeCustom;
    if (feeModeCustom && transactionCount == null) {
      transactionCount =
          await QiRpcService().getTransactionCount(coinInfo.coinAddress!);
    }
    if (feeModeCustom) {
      if (gasLimitController.text.isEmpty) {
        gasLimitController.text = gasLimit.toString();
      }
      if (gasPriceController.text.isEmpty) {
        gasPriceController.text = (currentGas / pow(10, 9)).toStringAsFixed(2);
      }
      if (nonceController.text.isEmpty) {
        nonceController.text = transactionCount.toString();
      }
    }
    checkComplete(true);
  }

  ///
  void onProgressChange(double val) {
    feePercent = val;
    update();
  }

  ///
  void onProgressStart() {
    print('start');
    focusFee = true;
    focusNodeAddress.unfocus();
    focusNodeAmount.unfocus();
    update();
  }

  ///
  void onProgressEnd() {
    print('end');
    focusFee = false;
    update();
  }

  getNftName() {
    String name = I18nKeys.unknown;
    if (nftInfo!.name != null) {
      if (nftInfo!.name!.contains('#')) {
        name = nftInfo!.name!.substring(0, nftInfo!.name!.indexOf('#'));
      } else {
        name = nftInfo!.name!;
      }
    }
    return name + '  #' + BigInt.parse(nftInfo!.tokenId!, radix: 16).toString();
  }

  late Coin coinInfo;
  Token? tokenInfo;
  TokenInfoModel? nftInfo;
  FocusNode focusNodeAddress = FocusNode();
  FocusNode focusNodeAmount = FocusNode();

  bool focusFee = false;
  bool showAddressPopWindow = false;
  bool showClipboardPopWindow = false;
  String clipboardAddress = '';

  getCoinIcon() {
    if (tokenInfo != null) {
      return WalletLoadImage(
        tokenInfo!.tokenIcon!,
        width: 14,
        height: 14,
      );
    } else {
      return WalletLoadAssetImage(
        coinInfo.getIcon(),
        width: 14,
        height: 14,
      );
    }
  }

  getCoinType() {
    return QiCoinCode44.parse(coinInfo.coinUnit!);
  }

  getCoinUnit() {
    if (tokenInfo != null) {
      return tokenInfo!.tokenUnit;
    } else {
      return coinInfo.coinUnit;
    }
  }

  getCoinBalance() {
    if (tokenInfo != null) {
      return '${WalletService.service.getTokenBalance(tokenInfo!)} ${tokenInfo!.tokenUnit}';
    }
    return '${WalletService.service.getCoinBalance(coinInfo)} ${coinInfo.coinUnit}';
  }

  getCurrentGas() {
    double highGas = (gasPrice * BigInt.from(5)).toDouble();
    double lowGas = highGas / 100;
    currentGas = lowGas + (highGas - lowGas) * feePercent;
    if (currentGas < pow(10, coinInfo.coinDecimals! ~/ 2)) {
      currentGas = pow(10, coinInfo.coinDecimals! ~/ 2).toDouble();
    }
    double fee = gasMath(currentGas, gasLimit.toDouble());
    return fee.toStringAsFixed(6) + "" + coinInfo.coinUnit!;
  }

  gasMath(double price, double limit, {custom = false}) {
    return price * limit / pow(10, coinInfo.coinDecimals!);
  }

  gasMathCustom(double price, double limit, {custom = false}) {
    return price * limit / pow(10, coinInfo.coinDecimals! ~/ 2);
  }

  getCurrentGasCurrency() {
    double highGas = (gasPrice * BigInt.from(5)).toDouble();
    double lowGas = highGas / 100;
    currentGas = lowGas + (highGas - lowGas) * feePercent;
    if (currentGas < pow(10, coinInfo.coinDecimals! ~/ 2)) {
      currentGas = pow(10, coinInfo.coinDecimals! ~/ 2).toDouble();
    }

    double fee = gasMath(currentGas, gasLimit.toDouble());
    double feeDollar =
        WalletService.service.getCurrencyBalance(fee, null, null);
    return "≈${LocalService.to.currencySymbol}" +
        feeDollar.toStringAsFixed(2) +
        "";
  }

  switch2Coin(Coin coin) {
    tokenInfo = null;
    update();
    getGasLimit();
  }

  switch2Token(Token token) {
    tokenInfo = token;
    update();
    getGasLimit();
  }

  int? transactionCount;

  static bool isAddress(String? text, {coin}) {
    Coin? coinInfo = coin;
    if (coinInfo != null &&
        QiCoinCode44.parse(coinInfo.coinUnit!) == QiCoinType.BTC) {
      if (text == null) {
        return false;
      }
      int len = text.length;
      if (isTestNet()) {
        return text.startsWith('m') && text.length == 34;
      }
      if (len < 25) {
        return false;
      }
      if (text.startsWith('1')) {
        return len >= 26 && len <= 34;
      }
      if (text.startsWith('3')) {
        return len == 34;
      }
      if (text.startsWith('bc1')) {
        return len > 34;
      }
      return false;
    }else if(coinInfo != null &&
        QiCoinCode44.parse(coinInfo.coinUnit!) == QiCoinType.SOL){
      return text != null && text.length == 44;
    }
    return text != null && text.length == 42 && text.startsWith('0x');
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    coinInfo = WalletService.service.currentCoin!;
    if (Get.arguments is Token) {
      tokenInfo = Get.arguments;
    }
    if (Get.arguments is TokenInfoModel) {
      nftInfo = Get.arguments;
    }
    listenCustom();
    addressController.addListener(() {
      if (addressController.text.isNotEmpty) {
        if (isAddress(addressController.text, coin: coinInfo)) {
          showClipboardPopWindow = false;
          showAddressPopWindow = false;
          update();
        } else {
          print('isNotAAddress');
          if (showClipboardPopWindow) {
            showClipboardPopWindow = false;
            update();
          }

          ///模糊匹配
          filter(addressController.text);

          if (addressList.isEmpty && addressUsedList.isEmpty) {
            showAddressPopWindow = false;
          } else {
            showAddressPopWindow = true;
          }
          update();
        }
      } else {
        if (focusNodeAddress.hasFocus) {
          if (addressList.isEmpty && addressUsedList.isEmpty) {
          } else {
            showAddressPopWindow = true;
            filter('');
            update();
          }
        }
      }
      checkComplete(true);
    });
    focusNodeAddress.addListener(() {
      showAddressPopWindow = focusNodeAddress.hasFocus;
      if (addressList.isEmpty && addressUsedList.isEmpty) {
        showAddressPopWindow = false;
      }
      print(showAddressPopWindow);
      if (!focusNodeAddress.hasFocus) {
        showClipboardPopWindow = false;
      }
      checkComplete(true);
    });
    amountController.addListener(() {
      checkComplete(true);
    });

    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && isAddress(data.text, coin: coinInfo)) {
      clipboardAddress = data.text!;
      showClipboardPopWindow = true;
      focusNodeAddress.requestFocus();
    }
    addressListTotal = await DBService.service.addressDao
        .findByType(QiRpcService().coinType.coinUnit());
    List<Tx> txList = await DBService.service.txDao
        .findByCoinType(QiRpcService().coinType.coinUnit());
    for (var item in txList) {
      bool inList = false;
      for (var element in addressUsedListTotal) {
        if (element.toAddress == item.toAddress) {
          inList = true;
        }
      }
      if (!inList) {
        addressUsedListTotal.insert(0, item);
        if (addressUsedListTotal.length > 9) {
          break;
        }
      }
    }
    filter('');
    update();
  }

  filter(String key) {
    addressList.clear();
    for (var item in addressListTotal) {
      if (item.coinAddress!.contains(key)) {
        addressList.add(item);
      }
    }
    addressUsedList.clear();
    for (var item in addressUsedListTotal) {
      if (item.toAddress!.contains(key)) {
        addressUsedList.add(item);
      }
    }
  }

  List<Address> addressListTotal = [];
  List<Tx> addressUsedListTotal = [];

  List<Address> addressList = [];
  List<Tx> addressUsedList = [];

  closeAddressTip() {
    focusNodeAddress.unfocus();
  }

  selectClipboard() {
    addressController.text = clipboardAddress;
    focusNodeAddress.unfocus();
    focusNodeAmount.requestFocus();
  }

  selectAddress(String address) {
    addressController.text = address;
    focusNodeAddress.unfocus();
    focusNodeAmount.requestFocus();
  }

  BigInt gasPrice = BigInt.from(2000000000);

  //普通转账gasLimit
  BigInt gasLimit = BigInt.from(21000);

  getGasLimit() async {
    try {
      if (nftInfo != null) {
        final params = [
          EthereumAddress.fromHex(coinInfo.coinAddress!),
          EthereumAddress.fromHex('0x300c5a78403d3f9d2c241394fcbbb6dd2487bf13'),
          BigInt.parse(nftInfo!.tokenId!, radix: 16)
        ];
        final data = const ContractFunction('safeTransferFrom', [
          FunctionParameter('_from', AddressType()),
          FunctionParameter('_to', AddressType()),
          FunctionParameter('_tokenId', UintType())
        ]).encodeCall(params);
        //合约转账gasLimit
        BigInt limit = await QiRpcService().estimateGas(
          from: EthereumAddress.fromHex(coinInfo.coinAddress!),
          to: EthereumAddress.fromHex(nftInfo!.contractAddress!),
          data: data,
        );
        if (limit < BigInt.from(90000)) {
          gasLimit = limit + BigInt.from(90000);
        } else {
          gasLimit = limit;
        }
      } else if (tokenInfo != null) {
        const function = ContractFunction('transfer', [
          FunctionParameter('_to', AddressType()),
          FunctionParameter('_value', UintType())
        ]);
        final params = [
          EthereumAddress.fromHex('0x300c5a78403d3f9d2c241394fcbbb6dd2487bf13'),
          BigInt.parse('0')
        ];
        BigInt limit = await QiRpcService().estimateGas(
          from: EthereumAddress.fromHex(coinInfo.coinAddress!),
          to: EthereumAddress.fromHex(tokenInfo!.contractAddress!),
          data: function.encodeCall(params),
        );
        if (limit < BigInt.from(60000)) {
          gasLimit = limit + BigInt.from(60000);
        } else {
          gasLimit = limit;
        }
      } else {
        gasLimit = await QiRpcService().estimateGas();
      }
      gasLimitController.text = gasLimit.toString();
    } catch (e) {
      print(e);
      gasLimit = BigInt.from(90000);
    }
    update();
  }

  @override
  void onReady() async {
    super.onReady();
    gasPrice = await QiRpcService().getGasPrice();
    getGasLimit();
  }

  transactionAll() {
    bool? showAmountClearModal = StorageUtils.sp.read<bool>('transactionAll');
    if (showAmountClearModal ?? true) {
      UniModals.showAmountClearModal(onConfirm: () {
        Get.back();
        StorageUtils.sp.write('transactionAll', false);
      });
      return;
    }

    if (tokenInfo != null) {
      double amount =
          WalletService.service.tokenAmountMaps[coinInfo][tokenInfo] ?? 0;
      amountController.text = MathToll.doubleKeepDown(amount, 6);
      checkComplete(false);
      return;
    }
    double amount = WalletService.service.amountMap[coinInfo] ?? 0;
    double fee = gasMath(currentGas, gasLimit.toDouble());
    amountController.text = MathToll.doubleKeepDown((amount - fee), 6);
    checkComplete(false);
  }

  double currentGas = 1;

  ///
  void verify() {}

  bool checkRight() {
    if (addressController.text.isEmpty) {
      checkComplete(true);
      return false;
    }

    if (addressController.text.toLowerCase() ==
        coinInfo.coinAddress!.toLowerCase()) {
      Get.showTopBanner(I18nKeys.youCantTransferItToYourself,
          style: TopBannerStyle.Error);
      return false;
    }

    double fee;
    if (feeModeCustom) {
      double price = double.parse(gasPriceController.text);
      double limit = double.parse(gasLimitController.text);

      fee = price * limit / pow(10, coinInfo.coinDecimals! ~/ 2);
    } else {
      fee = currentGas * gasLimit.toDouble() / pow(10, coinInfo.coinDecimals!);
    }
    if(coinInfo.coinUnit == 'SOL'){
      fee = solFee;
    }

    if (fee > WalletService.service.getCoinBalanceDouble(coinInfo)) {
      Get.showTopBanner(
          '${coinInfo.coinUnit}${I18nKeys.theBalanceIsNotEnoughToPayTheHandlingFee}',
          style: TopBannerStyle.Error);
      return false;
    }

    if (feeModeCustom) {
      if (fee * pow(10, coinInfo.coinDecimals! ~/ 2) < 21000) {
        Get.showTopBanner(I18nKeys.gasistoolow, style: TopBannerStyle.Error);
        return false;
      }
    }

    if (tokenInfo != null) {
      if (double.parse(amountController.text) >
          WalletService.service.getTokenBalanceDouble(tokenInfo!)) {
        Get.showTopBanner(
            '${tokenInfo!.tokenUnit}${I18nKeys.sorryYourCreditIsRunningLow}',
            style: TopBannerStyle.Error);
        return false;
      }
    } else if (nftInfo != null) {
    } else {
      if (double.parse(amountController.text) + fee >
          WalletService.service.getCoinBalanceDouble(coinInfo)) {
        Get.showTopBanner(
            '${coinInfo.coinUnit}${I18nKeys.sorryYourCreditIsRunningLow}',
            style: TopBannerStyle.Error);
        return false;
      }
    }
    return true;
  }

  getAmountConfirm() {
    if (nftInfo != null) {
      return getNftName();
    }
    if (tokenInfo != null) {
      return '${amountController.text} ${tokenInfo!.tokenUnit}';
    }
    return '${amountController.text} ${coinInfo.coinUnit}';
  }

  getAmountCurrencyConfirm() {
    if (nftInfo != null) {
      return '';
    }
    double amountDollar = WalletService.service.getCurrencyBalance(
        double.parse(amountController.text),
        null,
        tokenInfo != null ? tokenInfo!.contractAddress : null);

    return '≈${LocalService.to.currencySymbol} ${amountDollar.toStringAsFixed(2)}';
  }

  getAddressConfirm() {
    return addressController.text;
  }

  String getTitle() {
    if (tokenInfo != null) {
      return tokenInfo!.tokenUnit! + ' ' + I18nKeys.transfer;
    }
    return coinInfo.coinUnit! + ' ' + I18nKeys.transfer;
  }

  ///
  Future<void> executeTransaction(String password) async {
    if (nftInfo != null) {
      return executeNftTransaction(password);
    }
    if (tokenInfo != null) {
      return executeTokenTransaction(password);
    }
    return executeCoinTransaction(password);
  }

  Future<void> executeCoinTransaction(String password) async {
    Toast.showLoading();
    try {
      final String result;
      final Decimal amountWei = Decimal.parse(amountController.text) *
          Decimal.fromBigInt(BigInt.from(10).pow(coinInfo.coinDecimals!));
      if (getCoinType() == QiCoinType.BTC || getCoinType() == QiCoinType.SOL) {
        result = await QiRpcService().sendBtcTransaction(
            coinInfo.coinAddress!,
            addressController.text,
            double.parse(amountController.text) * pow(10, coinInfo.coinDecimals!),
            feeModeCustom
                ? double.parse(gasPriceController.text)
                : (currentGas / pow(10, 4)),
            WalletCreateController.decrypt(coinInfo.privateKey!, password));
      } else {
        EtherAmount price = EtherAmount.inWei(BigInt.from(currentGas));
        int limit = gasLimit.toInt();
        if (feeModeCustom) {
          BigInt pInt = BigInt.from(double.parse(gasPriceController.text) *
              pow(10, coinInfo.coinDecimals! ~/ 2));
          price = EtherAmount.inWei(pInt);
          limit = double.parse(gasLimitController.text) ~/ 1;
        }
        print(currentGas);
        result = await QiRpcService().sendTransaction(
            Transaction(
                to: EthereumAddress.fromHex(addressController.text),
                gasPrice: price,
                maxGas: limit,
                nonce: feeModeCustom
                    ? int.parse(nonceController.text)
                    : transactionCount,
                value: EtherAmount.fromUnitAndValue(
                    EtherUnit.wei, amountWei.toString())),
            privateKey:
                WalletCreateController.decrypt(coinInfo.privateKey!, password));
        print('https://aitd-explorer-pre.aitd.io/tx/$result');
      }
      await DBService.service.txDao.saveAndReturnId(Tx(
        coinType: coinInfo.coinType,
        amount: BigInt.parse(amountWei.toString()),
        fromAddress: coinInfo.coinAddress,
        toAddress: addressController.text,
        txHash: result,
        txTime: DateTime.now(),
        txStatus: TxStatus.PENDING,
      ));
      //Get.back(result: result);

      Toast.hideLoading();
      double amountDollar = WalletService.service.getCurrencyBalance(
          double.parse(amountController.text),
          null,
          tokenInfo != null ? tokenInfo!.contractAddress : null);

      Get.toNamed(Routes.TRANSACTION_RESULT, parameters: {
        'address': addressController.text,
        'amount':
            '-${amountController.text} ${tokenInfo != null ? tokenInfo!.tokenUnit : coinInfo.coinUnit}',
        'amountCurrency':
            '≈${LocalService.to.currencySymbol} ${amountDollar.toStringAsFixed(2)}'
      });
    } catch (e) {
      print(e);
      Toast.hideLoading();
      Get.showTopBanner(e.toString());
    }
  }

  Future<void> executeTokenTransaction(String password) async {
    Toast.showLoading();
    try {
      EtherAmount price = EtherAmount.inWei(BigInt.from(currentGas));
      print(price);
      int limit = gasLimit.toInt();
      if (feeModeCustom) {
        BigInt pInt = BigInt.from(double.parse(gasPriceController.text) *
            pow(10, coinInfo.coinDecimals! ~/ 2));
        price = EtherAmount.inWei(pInt);
        limit = double.parse(gasLimitController.text) ~/ 1;
      }

      final Decimal amountWei;
      final String result;

      amountWei = Decimal.parse(amountController.text) *
          Decimal.fromBigInt(BigInt.from(10).pow(tokenInfo!.tokenDecimals!));
      const function = ContractFunction('transfer', [
        FunctionParameter('_to', AddressType()),
        FunctionParameter('_value', UintType())
      ]);
      final params = [
        EthereumAddress.fromHex(addressController.text),
        BigInt.parse(amountWei.toString())
      ];
      final data = function.encodeCall(params);
      result = await QiRpcService().sendTransaction(
          Transaction(
              to: EthereumAddress.fromHex(tokenInfo!.contractAddress!),
              gasPrice: price,
              maxGas: limit,
              data: data,
              nonce: feeModeCustom
                  ? int.parse(nonceController.text)
                  : transactionCount,
              value: EtherAmount.zero()),
          privateKey:
              WalletCreateController.decrypt(coinInfo.privateKey!, password));
      await DBService.service.txDao.saveAndReturnId(Tx(
        coinType: tokenInfo!.tokenType,
        tokenType: tokenInfo!.contractAddress,
        amount: BigInt.parse(amountWei.toString()),
        fromAddress: coinInfo.coinAddress,
        toAddress: addressController.text,
        txHash: result,
        txTime: DateTime.now(),
        txStatus: TxStatus.PENDING,
      ));
      print('https://aitd-explorer-pre.aitd.io/tx/$result');

      Toast.hideLoading();
      double amountDollar = WalletService.service.getCurrencyBalance(
          double.parse(amountController.text),
          null,
          tokenInfo != null ? tokenInfo!.contractAddress : null);
      Get.toNamed(Routes.TRANSACTION_RESULT, parameters: {
        'address': addressController.text,
        'amount':
            '-${amountController.text} ${tokenInfo != null ? tokenInfo!.tokenUnit : coinInfo.coinUnit}',
        'amountCurrency':
            '≈${LocalService.to.currencySymbol} ${amountDollar.toStringAsFixed(2)}'
      });
    } catch (e) {
      print(e);
      Toast.hideLoading();
      Get.showTopBanner(e.toString());
    }
  }

  Future<void> executeNftTransaction(String password) async {
    Toast.showLoading();
    try {
      EtherAmount price = EtherAmount.inWei(BigInt.from(currentGas));
      print(price);
      int limit = gasLimit.toInt();
      if (feeModeCustom) {
        BigInt pInt = BigInt.from(double.parse(gasPriceController.text) *
            pow(10, coinInfo.coinDecimals! ~/ 2));
        price = EtherAmount.inWei(pInt);
        limit = double.parse(gasLimitController.text) ~/ 1;
      }

      final String result;
      const function = ContractFunction('safeTransferFrom', [
        FunctionParameter('_from', AddressType()),
        FunctionParameter('_to', AddressType()),
        FunctionParameter('_tokenId', UintType())
      ]);
      final params = [
        EthereumAddress.fromHex(coinInfo.coinAddress!),
        EthereumAddress.fromHex(addressController.text),
        BigInt.parse(nftInfo!.tokenId!, radix: 16)
      ];
      final data = function.encodeCall(params);

      result = await QiRpcService().sendTransaction(
          Transaction(
              to: EthereumAddress.fromHex(nftInfo!.contractAddress!),
              gasPrice: price,
              maxGas: limit,
              data: data,
              nonce: feeModeCustom
                  ? int.parse(nonceController.text)
                  : transactionCount,
              value: EtherAmount.zero()),
          privateKey:
              WalletCreateController.decrypt(coinInfo.privateKey!, password));
      await DBService.service.txDao.saveAndReturnId(Tx(
        coinType: nftInfo!.tokenId,
        tokenType: nftInfo!.contractAddress,
        amount: BigInt.one,
        fromAddress: coinInfo.coinAddress,
        toAddress: addressController.text,
        txHash: result,
        txTime: DateTime.now(),
        txStatus: TxStatus.PENDING,
      ));
      print('https://aitd-explorer-pre.aitd.io/tx/$result');
      //Get.back(result: result);

      Toast.hideLoading();
      String name = I18nKeys.unknown;
      if (nftInfo!.name != null) {
        if (nftInfo!.name!.contains('#')) {
          name = nftInfo!.name!.substring(0, nftInfo!.name!.indexOf('#'));
        } else {
          name = nftInfo!.name!;
        }
      }
      Get.toNamed(Routes.TRANSACTION_NFT_RESULT, parameters: {
        'address': addressController.text,
        'tokenName': name,
        'tokenId': nftInfo!.tokenId!,
        'image': nftInfo!.image!
      });
    } catch (e) {
      print(e);
      Toast.hideLoading();
      Get.showTopBanner(e.toString());
    }
  }
}
