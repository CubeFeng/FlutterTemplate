// ignore_for_file: unnecessary_this
// ignore_for_file: prefer_adjacent_string_concatenation

part of 'entity.dart';

/// 钱包
@Entity(
  tableName: 'tb_wallet',
)
class Wallet {
  /// 自增主键
  @PrimaryKey(autoGenerate: true)
  @ColumnInfo(name: '_id')
  int? id;

  /// 钱包名称
  @ColumnInfo(name: 'wallet_name')
  String? walletName;

  /// 钱包类型
  /// HD多链钱包 => 0，多重签名 => 1，NFC钱包 => 2，单链钱包 => 100
  @ColumnInfo(name: 'wallet_type')
  WalletType? walletType;

  /// 助记词
  @ColumnInfo(name: 'mnemonic')
  String? mnemonic;

  /// 钱包来源
  /// 创建 => 0，导入  => 1
  @ColumnInfo(name: 'wallet_source')
  WalletSource? walletSource;

  /// 创建时间
  @ColumnInfo(name: 'create_time')
  DateTime? createTime;

  /// 更新时间
  @ColumnInfo(name: 'update_time')
  DateTime? updateTime;

//<editor-fold desc="Data Methods">

  Wallet({
    this.id,
    this.walletName,
    this.walletType,
    this.mnemonic,
    this.walletSource,
    this.createTime,
    this.updateTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Wallet &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          walletName == other.walletName &&
          walletType == other.walletType &&
          mnemonic == other.mnemonic &&
          walletSource == other.walletSource &&
          createTime == other.createTime &&
          updateTime == other.updateTime);

  @override
  int get hashCode =>
      id.hashCode ^
      walletName.hashCode ^
      walletType.hashCode ^
      mnemonic.hashCode ^
      walletSource.hashCode ^
      createTime.hashCode ^
      updateTime.hashCode;

  @override
  String toString() {
    return 'Wallet{' +
        ' id: $id,' +
        ' walletName: $walletName,' +
        ' walletType: $walletType,' +
        ' mnemonic: $mnemonic,' +
        ' walletSource: $walletSource,' +
        ' createTime: $createTime,' +
        ' updateTime: $updateTime,' +
        '}';
  }

  Wallet copyWith({
    int? id,
    String? walletName,
    WalletType? walletType,
    String? mnemonic,
    WalletSource? walletSource,
    DateTime? createTime,
    DateTime? updateTime,
  }) {
    return Wallet(
      id: id ?? this.id,
      walletName: walletName ?? this.walletName,
      walletType: walletType ?? this.walletType,
      mnemonic: mnemonic ?? this.mnemonic,
      walletSource: walletSource ?? this.walletSource,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'walletName': this.walletName,
      'walletType': this.walletType,
      'mnemonic': this.mnemonic,
      'walletSource': this.walletSource,
      'createTime': this.createTime,
      'updateTime': this.updateTime,
    };
  }

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      id: map['id'] as int?,
      walletName: map['walletName'] as String?,
      walletType: map['walletType'] as WalletType?,
      mnemonic: map['mnemonic'] as String?,
      walletSource: map['walletSource'] as WalletSource?,
      createTime: map['createTime'] as DateTime?,
      updateTime: map['updateTime'] as DateTime?,
    );
  }

//</editor-fold>
}
