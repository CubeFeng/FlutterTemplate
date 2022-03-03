// ignore_for_file: unnecessary_this
// ignore_for_file: prefer_adjacent_string_concatenation

part of 'entity.dart';

/// 币种
@Entity(
  tableName: 'tb_coin',
  indices: [
    Index(value: ['wallet_id'])
  ],
)
class Coin {
  /// 自增主键
  @PrimaryKey(autoGenerate: true)
  @ColumnInfo(name: '_id')
  int? id;

  /// 所属钱包ID
  @ColumnInfo(name: 'wallet_id')
  int? walletId;

  /// 私钥
  @ColumnInfo(name: 'private_key')
  String? privateKey;

  /// 公钥
  @ColumnInfo(name: 'public_key')
  String? publicKey;

  /// 币种类型
  /// 比特币-BTC,以太币-ETH
  @ColumnInfo(name: 'coin_type')
  String? coinType;

  /// 币种名称
  @ColumnInfo(name: 'coin_name')
  String? coinName;

  /// 币种地址
  @ColumnInfo(name: 'coin_address')
  String? coinAddress;

  /// 币种单位
  @ColumnInfo(name: 'coin_unit')
  String? coinUnit;

  /// 币种精度
  @ColumnInfo(name: 'coin_decimals')
  int? coinDecimals;

  /// 排序
  @ColumnInfo(name: 'sort_index')
  int? sortIndex;

  /// 创建时间
  @ColumnInfo(name: 'create_time')
  DateTime? createTime;

  /// 更新时间
  @ColumnInfo(name: 'update_time')
  DateTime? updateTime;

//<editor-fold desc="Data Methods">

  Coin({
    this.id,
    this.walletId,
    this.privateKey,
    this.publicKey,
    this.coinType,
    this.coinName,
    this.coinAddress,
    this.coinUnit,
    this.coinDecimals,
    this.sortIndex,
    this.createTime,
    this.updateTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Coin &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          walletId == other.walletId &&
          privateKey == other.privateKey &&
          publicKey == other.publicKey &&
          coinType == other.coinType &&
          coinName == other.coinName &&
          coinAddress == other.coinAddress &&
          coinUnit == other.coinUnit &&
          coinDecimals == other.coinDecimals &&
          sortIndex == other.sortIndex &&
          createTime == other.createTime &&
          updateTime == other.updateTime);

  @override
  int get hashCode =>
      id.hashCode ^
      walletId.hashCode ^
      privateKey.hashCode ^
      publicKey.hashCode ^
      coinType.hashCode ^
      coinName.hashCode ^
      coinAddress.hashCode ^
      coinUnit.hashCode ^
      coinDecimals.hashCode ^
      sortIndex.hashCode ^
      createTime.hashCode ^
      updateTime.hashCode;

  @override
  String toString() {
    return 'Coin{' +
        ' id: $id,' +
        ' walletId: $walletId,' +
        ' privateKey: $privateKey,' +
        ' publicKey: $publicKey,' +
        ' coinType: $coinType,' +
        ' coinName: $coinName,' +
        ' coinAddress: $coinAddress,' +
        ' coinUnit: $coinUnit,' +
        ' coinDecimals: $coinDecimals,' +
        ' sortIndex: $sortIndex,' +
        ' createTime: $createTime,' +
        ' updateTime: $updateTime,' +
        '}';
  }

  Coin copyWith({
    int? id,
    int? walletId,
    String? privateKey,
    String? publicKey,
    String? coinType,
    String? coinName,
    String? coinAddress,
    String? coinUnit,
    int? coinDecimals,
    int? sortIndex,
    DateTime? createTime,
    DateTime? updateTime,
  }) {
    return Coin(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      privateKey: privateKey ?? this.privateKey,
      publicKey: publicKey ?? this.publicKey,
      coinType: coinType ?? this.coinType,
      coinName: coinName ?? this.coinName,
      coinAddress: coinAddress ?? this.coinAddress,
      coinUnit: coinUnit ?? this.coinUnit,
      coinDecimals: coinDecimals ?? this.coinDecimals,
      sortIndex: sortIndex ?? this.sortIndex,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'walletId': this.walletId,
      'privateKey': this.privateKey,
      'publicKey': this.publicKey,
      'coinType': this.coinType,
      'coinName': this.coinName,
      'coinAddress': this.coinAddress,
      'coinUnit': this.coinUnit,
      'coinDecimals': this.coinDecimals,
      'sortIndex': this.sortIndex,
      'createTime': this.createTime,
      'updateTime': this.updateTime,
    };
  }

  factory Coin.fromMap(Map<String, dynamic> map) {
    return Coin(
      id: map['id'] as int?,
      walletId: map['walletId'] as int?,
      privateKey: map['privateKey'] as String?,
      publicKey: map['publicKey'] as String?,
      coinType: map['coinType'] as String?,
      coinName: map['coinName'] as String?,
      coinAddress: map['coinAddress'] as String?,
      coinUnit: map['coinUnit'] as String?,
      coinDecimals: map['coinDecimals'] as int?,
      sortIndex: map['sortIndex'] as int?,
      createTime: map['createTime'] as DateTime?,
      updateTime: map['updateTime'] as DateTime?,
    );
  }

//</editor-fold>
}
