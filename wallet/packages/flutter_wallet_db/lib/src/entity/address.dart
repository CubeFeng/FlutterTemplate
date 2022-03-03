// ignore_for_file: unnecessary_this
// ignore_for_file: prefer_adjacent_string_concatenation

part of 'entity.dart';

/// 地址簿
@Entity(
  tableName: 'tb_address',
)
class Address {
  /// 自增主键
  @PrimaryKey(autoGenerate: true)
  @ColumnInfo(name: '_id')
  int? id;

  /// 名称
  @ColumnInfo(name: 'name')
  String? name;

  /// 币种类型
  /// 比特币-BTC,以太币-ETH
  @ColumnInfo(name: 'coin_type')
  String? coinType;

  /// 币种地址
  @ColumnInfo(name: 'coin_address')
  String? coinAddress;

  /// 备注
  @ColumnInfo(name: 'remark')
  String? remark;

  /// 创建时间
  @ColumnInfo(name: 'create_time')
  DateTime? createTime;

  /// 更新时间
  @ColumnInfo(name: 'update_time')
  DateTime? updateTime;

//<editor-fold desc="Data Methods">

  Address({
    this.id,
    this.name,
    this.coinType,
    this.coinAddress,
    this.remark,
    this.createTime,
    this.updateTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Address &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          coinType == other.coinType &&
          coinAddress == other.coinAddress &&
          remark == other.remark &&
          createTime == other.createTime &&
          updateTime == other.updateTime);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      coinType.hashCode ^
      coinAddress.hashCode ^
      remark.hashCode ^
      createTime.hashCode ^
      updateTime.hashCode;

  @override
  String toString() {
    return 'Address{' +
        ' id: $id,' +
        ' name: $name,' +
        ' coinType: $coinType,' +
        ' coinAddress: $coinAddress,' +
        ' remark: $remark,' +
        ' createTime: $createTime,' +
        ' updateTime: $updateTime,' +
        '}';
  }

  Address copyWith({
    int? id,
    String? name,
    String? coinType,
    String? coinAddress,
    String? remark,
    DateTime? createTime,
    DateTime? updateTime,
  }) {
    return Address(
      id: id ?? this.id,
      name: name ?? this.name,
      coinType: coinType ?? this.coinType,
      coinAddress: coinAddress ?? this.coinAddress,
      remark: remark ?? this.remark,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'coinType': this.coinType,
      'coinAddress': this.coinAddress,
      'remark': this.remark,
      'createTime': this.createTime,
      'updateTime': this.updateTime,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] as int?,
      name: map['name'] as String?,
      coinType: map['coinType'] as String?,
      coinAddress: map['coinAddress'] as String?,
      remark: map['remark'] as String?,
      createTime: map['createTime'] as DateTime?,
      updateTime: map['updateTime'] as DateTime?,
    );
  }

//</editor-fold>
}
