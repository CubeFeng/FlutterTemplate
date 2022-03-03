import 'dart:math';

import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/property/controllers/property_controller.dart';
import 'package:flutter_wallet/modules/wallet/create/controllers/wallet_create_controller.dart';
import 'package:flutter_wallet/services/security_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/widgets/modals/switch_wallet_modal.dart';
import 'package:flutter_wallet/widgets/modals/transaction_fee_modal.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:flutter_wallet_dapp_browser/flutter_wallet_dapp_browser.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/crypto.dart';

// ignore: implementation_imports
import 'package:web3dart/src/crypto/formatting.dart';

class JavaScriptHandler extends DappsJavaScriptHandlerInterceptor {
  final Map<String, dynamic> _signedData = {};

  @override
  Future<List<String>> handlerScript(
      String handlerName, int id, List args) async {
    print(args);
    if (WalletService.service.currentCoin == null) {
      //TODO: 还没添加过钱包，弹窗提示
    } else {
      switch (handlerName) {
        case 'requestAccounts':
          DappsBrowserService.service
              .changeAddress(WalletService.service.currentCoin!.coinAddress!);
          return [WalletService.service.currentCoin!.coinAddress!];
        case 'signTransaction':
        case 'offlineSignTransaction':
          var object = args[0]['object'];
          String data = object['data'] ?? '';
          String gas = strip0x(object['gas'] ?? '');
          String value = strip0x(object['value'] ?? '0');
          Get.bottomSheet(
            TransactionFeeModal(
              onConfirmCallback: (gasPrice) async {
                try{
                  Coin coinInfo = WalletService.service.currentCoin!;
                  double fee;
                  int priceSelect = BigInt.from(gasPrice).toInt();
                  int limitSelect = BigInt.parse(gas, radix: 16).toInt();

                  fee =
                      priceSelect * limitSelect / pow(10, coinInfo.coinDecimals!);
                  await WalletService.service.refreshCoinBalance([coinInfo]);
                  if (fee + BigInt.parse(value, radix: 16).toInt() / pow(10, coinInfo.coinDecimals!) >
                      WalletService.service.getCoinBalanceDouble(coinInfo)) {
                    String tip =
                        '${coinInfo.coinUnit}${I18nKeys.theBalanceIsNotEnoughToPayTheHandlingFee}';
                    Get.showTopBanner(tip, style: TopBannerStyle.Error);
                    return;
                  }
                }catch(e){
                  print(e);
                }
                Get.back();

                EtherAmount price = EtherAmount.inWei(BigInt.from(gasPrice));
                final isOpenBiometryPay =
                    await SecurityService.to.isOpenBiometryPay;
                UniModals.showVerifySecurityPasswordModal(
                  onSuccess: () {},
                  onPasswordGet: (password) async {
                    try {
                      int count = await QiRpcService().getTransactionCount(
                          WalletService.service.currentCoin!.coinAddress!);

                      Transaction transaction = Transaction(
                          to: EthereumAddress.fromHex(object['to']),
                          gasPrice: price,
                          maxGas: BigInt.parse(gas, radix: 16).toInt(),
                          data: hexToBytes(data),
                          nonce: count,
                          value: EtherAmount.inWei(
                              BigInt.parse(value, radix: 16)));

                      String txHash = '';

                      /// signTransaction
                      if (handlerName == 'signTransaction') {
                        txHash = await QiRpcService().sendTransaction(
                            transaction,
                            privateKey: WalletCreateController.decrypt(
                                WalletService.service.currentCoin!.privateKey!,
                                password));
                      } else if (handlerName == 'offlineSignTransaction') {
                        final signed = await QiRpcService().signTransaction(
                            transaction,
                            privateKey: WalletCreateController.decrypt(
                                WalletService.service.currentCoin!.privateKey!,
                                password));
                        final sha3Buffer = keccak256(EthUtils.toBuffer(signed));
                        txHash = bytesToHex(sha3Buffer, include0x: true);
                        _signedData[txHash] = signed;
                      }
                      logger.info('tx: $txHash');
                      DappsBrowserService.service.sendResult(id, txHash);
                    } catch (e) {
                      print(e);
                      DappsBrowserService.service.sendError(id, e.toString());
                    }
                  },
                  passwordAuthOnly: !isOpenBiometryPay,
                  switchPasswordAuto: !isOpenBiometryPay,
                );
              },
              amount: value,
              gasLimit: BigInt.from(int.parse(gas, radix: 16)),
            ),
            isScrollControlled: true,
          );
          break;
        case 'sendSignedTransaction':
          var object = args[0]['object'];
          String txHash = object ?? '';

          if (_signedData.containsKey(txHash)) {
            final _txHash = await QiRpcService()
                .sendRawTransaction(EthUtils.toBuffer(_signedData[txHash]));
            if (txHash == _txHash) {
              _signedData.remove(txHash);
              return [txHash];
            } else {
              throw DappException('$txHash invalid!');
            }
          } else {
            throw DappException('$txHash is not exist!');
          }
        case 'signTypedMessage':
        case "signPersonalMessage":
          final isOpenBiometryPay = await SecurityService.to.isOpenBiometryPay;
          UniModals.showVerifySecurityPasswordModal(
            onSuccess: () {},
            onPasswordGet: (password) {
              var object = args[0]['object'];
              String data = object['data'] ?? '';
              var hash = QiRpcService().signTypeMessage(data,
                  privateKey: WalletCreateController.decrypt(
                      WalletService.service.currentCoin!.privateKey!,
                      password));
              DappsBrowserService.service.sendResult(id, hash);
            },
            passwordAuthOnly: !isOpenBiometryPay,
            switchPasswordAuto: !isOpenBiometryPay,
          );
          break;
        case 'switchEthereumChain':
          var object = args[0]['object'];
          String chainId = object['chainId'] ?? '';
          QiCoinType coinType = qiFindChainById(
              BigInt.tryParse(chainId.substring(2), radix: 16)!.toInt());
          Get.bottomSheet(
            SwitchWalletModal(
              coinType: coinType,
              singleChain: true,
              onSelectedWalletCallback: (coin) async {
                Get.back();
                await Get.find<PropertyController>().onAddressSelect(coin);
                String configureJson = "{chainId:" +
                    chainId +
                    ",rpcUrl:\"" +
                    QiRpcService().currentRpc.nodes[0] +
                    "\",isDebug:true}";
                String response =
                    "window.ethereum.setConfig(" + configureJson + ")";
                DappsBrowserService.service
                    .evaluateJavascript(source: response);
                DappsBrowserService.service.sendResult(id, '1');
              },
            ),
            isScrollControlled: true,
          );
      }
    }
    return [];
  }
}

class DappException implements Exception {
  final dynamic message;

  DappException([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "Exception";
    return "$message";
  }
}
