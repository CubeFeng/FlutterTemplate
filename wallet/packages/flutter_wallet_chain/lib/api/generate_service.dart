
import 'package:flutter_wallet_chain/api/generate/generate_eth.dart';
import 'package:flutter_wallet_chain/api/generate/generate_sol.dart';
import 'package:flutter_wallet_chain/api/generate/generate_trx.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';

import 'generate/generate_btc.dart';

abstract class IGenerateService {
  ///
  static IGenerateService getGenerateService(QiCoinType coinType) {
    if (coinType == QiCoinType.AITD || coinType == QiCoinType.ETH) {
      return GenerateEth();
    } else if (coinType == QiCoinType.TRX) {
      return GenerateTrx();
    } else if (coinType == QiCoinType.SOL) {
      return GenerateSol();
    } else {
      return GenerateBtc();
    }
  }

  /// 验证privateKey是否是有效.
  bool qiValidatePrivateKey(QiCoinType coinType, String privateKey);

  /// 通过币种和助记词生成钱包密钥对,可用于助记词创建钱包或助记词导入生成钱包.
  Future<QiCoinKeypair> qiGenerateKeypair(QiCoinType coinType, String mnemonic);

  /// 通过私钥生成地址.
  Future<QiCoinKeypair> qiGenerateKeypairWithPrivateKey(
      QiCoinType coinType, String privateKey);
}
