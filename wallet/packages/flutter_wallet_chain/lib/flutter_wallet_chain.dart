library flutter_wallet_chain;

import 'model/wallet_info.dart';

export 'api/generate_api.dart';
export 'api/generate_api_keystore.dart';
export 'api/rpc_api.dart';
export 'model/wallet_info.dart';
export 'model/net_info.dart';
export 'utils/eth_utils.dart';
export 'api/rpc/rpc_btc.dart';


/// 链是否开启
const isSupports = {
  QiCoinType.ETH: '上线时间2021-11-26',
  QiCoinType.AITD: '上线时间2021-11-26',
  QiCoinType.BTC: null,
  QiCoinType.TRX: null,
  QiCoinType.SOL: null,
};
