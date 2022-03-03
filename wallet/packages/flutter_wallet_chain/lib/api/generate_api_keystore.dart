import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

/// 通过keystore创建钱包密钥对
Future<QiCoinKeypair> qiGenerateWalletWithKeystore(
    {required String password, required String keystore}) {
  return compute(_qiGenerateKeypairWithKeystore,
      {'password': password, 'keystore': keystore});
}

/// 通过keystore导入钱包
QiCoinKeypair _qiGenerateKeypairWithKeystore(Map<String, dynamic> args) {
  final keystore = args['keystore']! as String;
  final password = args['password']! as String;
  final wallet = Wallet.fromJson(keystore, password);
  final keypair = QiCoinKeypair();

  keypair.privateKey = bytesToHex(wallet.privateKey.privateKey);
  keypair.publicKey = bytesToHex(wallet.privateKey.encodedPublicKey);
  keypair.address = wallet.privateKey.address.hex;
  return keypair;
}

/// 通过私钥导出keystore, 随机
Future<String> qiGenerateKeystore(
    {required String password, required String privateKey}) {
  return compute(
      _qiGenerateKeystore, {'password': password, 'privateKey': privateKey});
}

/// 通过私钥导出keystore, 随机
String _qiGenerateKeystore(Map<String, dynamic> args) {
  final password = args['password']! as String;
  final privateKey = args['privateKey']! as String;
  final random = args['random'];
  final wallet = Wallet.createNew(
      EthPrivateKey.fromHex(privateKey), password, random ?? Random.secure(),
      scryptN: 1 << 12, p: 6);
  return wallet.toJson();
}
