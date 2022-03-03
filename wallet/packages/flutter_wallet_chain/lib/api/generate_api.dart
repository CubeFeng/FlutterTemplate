import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/foundation.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/btc/bitcoin_flutter.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';

import 'generate_service.dart';

/// 返回随机一个助记词.
String qiGenerateMnemonic() {
  return bip39.generateMnemonic();
}

/// 验证助记词是否是有效.
bool qiValidateMnemonic(String mnemonic) {
  return bip39.validateMnemonic(mnemonic);
}

/// 验证privateKey是否是有效.
bool qiValidatePrivateKey(QiCoinType coinType, String privateKey) {
  return IGenerateService.getGenerateService(coinType)
      .qiValidatePrivateKey(coinType, privateKey);
}

/// 通过助记词创建钱包密钥对
Future<QiCoinKeypair> qiGenerateKeypairWithMnemonic(
    {required QiCoinType coinType, required String mnemonic}) {
  return compute(
      _qiGenerateKeypair, {'coinType': coinType, 'mnemonic': mnemonic});
}

/// 通过币种和助记词生成钱包密钥对,可用于助记词创建钱包或助记词导入生成钱包.
Future<QiCoinKeypair> _qiGenerateKeypair(Map<String, dynamic> args) async {
  final coinType = args['coinType']! as QiCoinType;
  final mnemonic = args['mnemonic']! as String;
  return await IGenerateService.getGenerateService(coinType)
      .qiGenerateKeypair(coinType, mnemonic);
}

/// 通过私钥生成地址.
Future<QiCoinKeypair> qiGenerateKeypairWithPrivateKey(
    QiCoinType coinType, String privateKey) async {
  return await IGenerateService.getGenerateService(coinType)
      .qiGenerateKeypairWithPrivateKey(coinType, privateKey);
}

NetworkType getNet(QiCoinType coinType) {
  return isTestNet() ? testnet : bitcoin;
}
