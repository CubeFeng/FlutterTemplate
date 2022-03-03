// ignore_for_file: unnecessary_this
// ignore_for_file: prefer_adjacent_string_concatenation

part of 'entity.dart';

/// 交易记录
@Entity(
  tableName: 'tb_tx',
  indices: [
    Index(value: ['coin_id']),
    Index(value: ['token_id'])
  ],
)
class Tx {
  /// 自增主键
  @PrimaryKey(autoGenerate: true)
  @ColumnInfo(name: '_id')
  int? id;

  /// 所属币种ID
  @ColumnInfo(name: 'coin_id')
  int? coinId;

  /// 币种类型
  /// 比特币-BTC,以太币-ETH
  @ColumnInfo(name: 'coin_type')
  String? coinType;

  /// 所属代币ID
  @ColumnInfo(name: 'token_id')
  int? tokenId;

  /// 代币类型, 使用币种简称
  /// 泰达币 =>USDT，币安币 => BNB
  @ColumnInfo(name: 'token_type')
  String? tokenType;

  /// 交易Hash
  @ColumnInfo(name: 'tx_hash')
  String? txHash;

  /// 交易时间
  @ColumnInfo(name: 'tx_time')
  DateTime? txTime;

  /// 转账地址
  @ColumnInfo(name: 'from_address')
  String? fromAddress;

  /// 到账地址
  @ColumnInfo(name: 'to_address')
  String? toAddress;

  /// 交易金额
  @ColumnInfo(name: 'amount')
  BigInt? amount;

  /// 交易手续费
  @ColumnInfo(name: 'fee')
  BigInt? fee;

  /// 备注
  @ColumnInfo(name: 'remark')
  String? remark;

  /// 交易Index
  @ColumnInfo(name: 'tx_index')
  int? txIndex;

  /// 交易状态
  /// 等待打包 => 0，转账成功  => 1，转账失败 => -1
  @ColumnInfo(name: 'tx_status')
  TxStatus? txStatus;

  /// 区块高度
  @ColumnInfo(name: 'block_number')
  int? blockNumber;

  /// 区块Hash
  @ColumnInfo(name: 'block_hash')
  String? blockHash;

  /// 消耗的带宽（TRX 专有的字段）
  @ColumnInfo(name: 'trx_net_usage')
  int? trxNetUsage;

  /// 消耗的能量（TRX 专有的字段）
  @ColumnInfo(name: 'trx_enery_usage')
  int? trxEneryUsage;

  /// 手续费（TRX 专有的字段）
  @ColumnInfo(name: 'trx_net_fee')
  int? trxNetFee;

  /// 创建时间
  @ColumnInfo(name: 'create_time')
  DateTime? createTime;

  /// 更新时间
  @ColumnInfo(name: 'update_time')
  DateTime? updateTime;

//<editor-fold desc="Data Methods">

  Tx({
    this.id,
    this.coinId,
    this.coinType,
    this.tokenId,
    this.tokenType,
    this.txHash,
    this.txTime,
    this.fromAddress,
    this.toAddress,
    this.amount,
    this.fee,
    this.remark,
    this.txIndex,
    this.txStatus,
    this.blockNumber,
    this.blockHash,
    this.trxNetUsage,
    this.trxEneryUsage,
    this.trxNetFee,
    this.createTime,
    this.updateTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tx &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          coinId == other.coinId &&
          coinType == other.coinType &&
          tokenId == other.tokenId &&
          tokenType == other.tokenType &&
          txHash == other.txHash &&
          txTime == other.txTime &&
          fromAddress == other.fromAddress &&
          toAddress == other.toAddress &&
          amount == other.amount &&
          fee == other.fee &&
          remark == other.remark &&
          txIndex == other.txIndex &&
          txStatus == other.txStatus &&
          blockNumber == other.blockNumber &&
          blockHash == other.blockHash &&
          trxNetUsage == other.trxNetUsage &&
          trxEneryUsage == other.trxEneryUsage &&
          trxNetFee == other.trxNetFee &&
          createTime == other.createTime &&
          updateTime == other.updateTime);

  @override
  int get hashCode =>
      id.hashCode ^
      coinId.hashCode ^
      coinType.hashCode ^
      tokenId.hashCode ^
      tokenType.hashCode ^
      txHash.hashCode ^
      txTime.hashCode ^
      fromAddress.hashCode ^
      toAddress.hashCode ^
      amount.hashCode ^
      fee.hashCode ^
      remark.hashCode ^
      txIndex.hashCode ^
      txStatus.hashCode ^
      blockNumber.hashCode ^
      blockHash.hashCode ^
      trxNetUsage.hashCode ^
      trxEneryUsage.hashCode ^
      trxNetFee.hashCode ^
      createTime.hashCode ^
      updateTime.hashCode;

  @override
  String toString() {
    return 'Tx{' +
        ' id: $id,' +
        ' coinId: $coinId,' +
        ' coinType: $coinType,' +
        ' tokenId: $tokenId,' +
        ' tokenType: $tokenType,' +
        ' txHash: $txHash,' +
        ' txTime: $txTime,' +
        ' fromAddress: $fromAddress,' +
        ' toAddress: $toAddress,' +
        ' amount: $amount,' +
        ' fee: $fee,' +
        ' remark: $remark,' +
        ' txIndex: $txIndex,' +
        ' txStatus: $txStatus,' +
        ' blockNumber: $blockNumber,' +
        ' blockHash: $blockHash,' +
        ' trxNetUsage: $trxNetUsage,' +
        ' trxEneryUsage: $trxEneryUsage,' +
        ' trxNetFee: $trxNetFee,' +
        ' createTime: $createTime,' +
        ' updateTime: $updateTime,' +
        '}';
  }

  Tx copyWith({
    int? id,
    int? coinId,
    String? coinType,
    int? tokenId,
    String? tokenType,
    String? txHash,
    DateTime? txTime,
    String? fromAddress,
    String? toAddress,
    BigInt? amount,
    BigInt? fee,
    String? remark,
    int? txIndex,
    TxStatus? txStatus,
    int? blockNumber,
    String? blockHash,
    int? trxNetUsage,
    int? trxEneryUsage,
    int? trxNetFee,
    DateTime? createTime,
    DateTime? updateTime,
  }) {
    return Tx(
      id: id ?? this.id,
      coinId: coinId ?? this.coinId,
      coinType: coinType ?? this.coinType,
      tokenId: tokenId ?? this.tokenId,
      tokenType: tokenType ?? this.tokenType,
      txHash: txHash ?? this.txHash,
      txTime: txTime ?? this.txTime,
      fromAddress: fromAddress ?? this.fromAddress,
      toAddress: toAddress ?? this.toAddress,
      amount: amount ?? this.amount,
      fee: fee ?? this.fee,
      remark: remark ?? this.remark,
      txIndex: txIndex ?? this.txIndex,
      txStatus: txStatus ?? this.txStatus,
      blockNumber: blockNumber ?? this.blockNumber,
      blockHash: blockHash ?? this.blockHash,
      trxNetUsage: trxNetUsage ?? this.trxNetUsage,
      trxEneryUsage: trxEneryUsage ?? this.trxEneryUsage,
      trxNetFee: trxNetFee ?? this.trxNetFee,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'coinId': this.coinId,
      'coinType': this.coinType,
      'tokenId': this.tokenId,
      'tokenType': this.tokenType,
      'txHash': this.txHash,
      'txTime': this.txTime,
      'fromAddress': this.fromAddress,
      'toAddress': this.toAddress,
      'amount': this.amount,
      'fee': this.fee,
      'remark': this.remark,
      'txIndex': this.txIndex,
      'txStatus': this.txStatus,
      'blockNumber': this.blockNumber,
      'blockHash': this.blockHash,
      'trxNetUsage': this.trxNetUsage,
      'trxEneryUsage': this.trxEneryUsage,
      'trxNetFee': this.trxNetFee,
      'createTime': this.createTime,
      'updateTime': this.updateTime,
    };
  }

  factory Tx.fromMap(Map<String, dynamic> map) {
    return Tx(
      id: map['id'] as int?,
      coinId: map['coinId'] as int?,
      coinType: map['coinType'] as String?,
      tokenId: map['tokenId'] as int?,
      tokenType: map['tokenType'] as String?,
      txHash: map['txHash'] as String?,
      txTime: map['txTime'] as DateTime?,
      fromAddress: map['fromAddress'] as String?,
      toAddress: map['toAddress'] as String?,
      amount: map['amount'] as BigInt?,
      fee: map['fee'] as BigInt?,
      remark: map['remark'] as String?,
      txIndex: map['txIndex'] as int?,
      txStatus: map['txStatus'] as TxStatus?,
      blockNumber: map['blockNumber'] as int?,
      blockHash: map['blockHash'] as String?,
      trxNetUsage: map['trxNetUsage'] as int?,
      trxEneryUsage: map['trxEneryUsage'] as int?,
      trxNetFee: map['trxNetFee'] as int?,
      createTime: map['createTime'] as DateTime?,
      updateTime: map['updateTime'] as DateTime?,
    );
  }

//</editor-fold>
}
