import 'package:flutter_wallet_chain/model/wallet_info.dart';

/// 网络环境配置.
enum QiChainNet {
  /// 测试网.
  TEST_NET,

  /// 主网.
  MAIN_CHAIN_NET
}

/// 网络环境配置模型.
class QiRpcConfig {
  /// 链.
  final QiCoinType coinType;

  /// 节点列表.
  List<String> nodes;

  /// 链的ID.
  final int chainId;

  /// 初始化.
  QiRpcConfig(this.coinType, this.nodes, this.chainId);


  /// 网络环境配置模型.
  static QiRpcConfig fromJson(Map<String, dynamic> jsonObj) {
    final QiCoinType coinType;
    switch (jsonObj['chain']) {
      case 'aitd':
        coinType = QiCoinType.AITD;
        break;
      case 'eth':
        coinType = QiCoinType.ETH;
        break;
      case 'trx':
        coinType = QiCoinType.TRX;
        break;
      case 'sol':
        coinType = QiCoinType.SOL;
        break;
      default:
        coinType = QiCoinType.BTC;
    }
    return QiRpcConfig(coinType, jsonObj['nodes'], jsonObj['chainId']);
  }
}
