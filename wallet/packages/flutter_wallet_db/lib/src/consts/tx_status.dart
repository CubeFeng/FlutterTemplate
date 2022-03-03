part of 'consts.dart';

/// 交易状态
enum TxStatus {
  /// 等待打包 => 0
  PENDING,

  /// 转账成功  => 1
  SUCCEED,

  /// 转账失败 => -1
  FAILED,
}
