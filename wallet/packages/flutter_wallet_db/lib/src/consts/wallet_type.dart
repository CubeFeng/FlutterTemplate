part of 'consts.dart';

/// 钱包类型
enum WalletType {
  /// HD多链钱包 => 0
  HD,

  /// 多重签名 => 1
  MULTI_SIGN,

  /// NFC钱包 => 2
  NFC,

  /// 单链钱包 => 100
  SINGLE_CHAIN,
}
