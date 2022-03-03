// ignore_for_file: unnecessary_this
// ignore_for_file: prefer_adjacent_string_concatenation

part of 'entity.dart';

/// 代币
@Entity(
  tableName: 'tb_token',
  indices: [
    Index(value: ['coin_id'])
  ],
)
class Token {
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

  /// 代币名称, 使用币种简称
  /// 泰达币 =>USDT，币安币 => BNB
  @ColumnInfo(name: 'token_name')
  String? tokenName;

  /// 代币类型, 使用币种简称
  /// 泰达币 =>USDT，币安币 => BNB
  @ColumnInfo(name: 'token_type')
  String? tokenType;

  /// 合约地址
  @ColumnInfo(name: 'contract_address')
  String? contractAddress;

  /// 代币图标
  @ColumnInfo(name: 'token_icon')
  String? tokenIcon;

  /// 代币单位
  @ColumnInfo(name: 'token_unit')
  String? tokenUnit;

  /// 代币精度
  @ColumnInfo(name: 'token_decimals')
  int? tokenDecimals;

  /// 作者
  @ColumnInfo(name: 'author')
  String? author;

  /// 平台
  @ColumnInfo(name: 'platform')
  String? platform;

  /// 描述
  @ColumnInfo(name: 'description')
  String? description;

  /// DApp URL
  @ColumnInfo(name: 'dapp_url')
  String? dappUrl;

  /// 代币 URL
  @ColumnInfo(name: 'token_url')
  String? tokenUrl;

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

  Token({
    this.id,
    this.coinId,
    this.coinType,
    this.tokenName,
    this.tokenType,
    this.contractAddress,
    this.tokenIcon,
    this.tokenUnit,
    this.tokenDecimals,
    this.author,
    this.platform,
    this.description,
    this.dappUrl,
    this.tokenUrl,
    this.sortIndex,
    this.createTime,
    this.updateTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Token &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          coinId == other.coinId &&
          coinType == other.coinType &&
          tokenName == other.tokenName &&
          tokenType == other.tokenType &&
          contractAddress == other.contractAddress &&
          tokenIcon == other.tokenIcon &&
          tokenUnit == other.tokenUnit &&
          tokenDecimals == other.tokenDecimals &&
          author == other.author &&
          platform == other.platform &&
          description == other.description &&
          dappUrl == other.dappUrl &&
          tokenUrl == other.tokenUrl &&
          sortIndex == other.sortIndex &&
          createTime == other.createTime &&
          updateTime == other.updateTime);

  @override
  int get hashCode =>
      id.hashCode ^
      coinId.hashCode ^
      coinType.hashCode ^
      tokenName.hashCode ^
      tokenType.hashCode ^
      contractAddress.hashCode ^
      tokenIcon.hashCode ^
      tokenUnit.hashCode ^
      tokenDecimals.hashCode ^
      author.hashCode ^
      platform.hashCode ^
      description.hashCode ^
      dappUrl.hashCode ^
      tokenUrl.hashCode ^
      sortIndex.hashCode ^
      createTime.hashCode ^
      updateTime.hashCode;

  @override
  String toString() {
    return 'Token{' +
        ' id: $id,' +
        ' coinId: $coinId,' +
        ' coinType: $coinType,' +
        ' tokenName: $tokenName,' +
        ' tokenType: $tokenType,' +
        ' contractAddress: $contractAddress,' +
        ' tokenIcon: $tokenIcon,' +
        ' tokenUnit: $tokenUnit,' +
        ' tokenDecimals: $tokenDecimals,' +
        ' author: $author,' +
        ' platform: $platform,' +
        ' description: $description,' +
        ' dappUrl: $dappUrl,' +
        ' tokenUrl: $tokenUrl,' +
        ' sortIndex: $sortIndex,' +
        ' createTime: $createTime,' +
        ' updateTime: $updateTime,' +
        '}';
  }

  Token copyWith({
    int? id,
    int? coinId,
    String? coinType,
    String? tokenName,
    String? tokenType,
    String? contractAddress,
    String? tokenIcon,
    String? tokenUnit,
    int? tokenDecimals,
    String? author,
    String? platform,
    String? description,
    String? dappUrl,
    String? tokenUrl,
    int? sortIndex,
    DateTime? createTime,
    DateTime? updateTime,
  }) {
    return Token(
      id: id ?? this.id,
      coinId: coinId ?? this.coinId,
      coinType: coinType ?? this.coinType,
      tokenName: tokenName ?? this.tokenName,
      tokenType: tokenType ?? this.tokenType,
      contractAddress: contractAddress ?? this.contractAddress,
      tokenIcon: tokenIcon ?? this.tokenIcon,
      tokenUnit: tokenUnit ?? this.tokenUnit,
      tokenDecimals: tokenDecimals ?? this.tokenDecimals,
      author: author ?? this.author,
      platform: platform ?? this.platform,
      description: description ?? this.description,
      dappUrl: dappUrl ?? this.dappUrl,
      tokenUrl: tokenUrl ?? this.tokenUrl,
      sortIndex: sortIndex ?? this.sortIndex,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'coinId': this.coinId,
      'coinType': this.coinType,
      'tokenName': this.tokenName,
      'tokenType': this.tokenType,
      'contractAddress': this.contractAddress,
      'tokenIcon': this.tokenIcon,
      'tokenUnit': this.tokenUnit,
      'tokenDecimals': this.tokenDecimals,
      'author': this.author,
      'platform': this.platform,
      'description': this.description,
      'dappUrl': this.dappUrl,
      'tokenUrl': this.tokenUrl,
      'sortIndex': this.sortIndex,
      'createTime': this.createTime,
      'updateTime': this.updateTime,
    };
  }

  factory Token.fromMap(Map<String, dynamic> map) {
    return Token(
      id: map['id'] as int?,
      coinId: map['coinId'] as int?,
      coinType: map['coinType'] as String?,
      tokenName: map['tokenName'] as String?,
      tokenType: map['tokenType'] as String?,
      contractAddress: map['contractAddress'] as String?,
      tokenIcon: map['tokenIcon'] as String?,
      tokenUnit: map['tokenUnit'] as String?,
      tokenDecimals: map['tokenDecimals'] as int?,
      author: map['author'] as String?,
      platform: map['platform'] as String?,
      description: map['description'] as String?,
      dappUrl: map['dappUrl'] as String?,
      tokenUrl: map['tokenUrl'] as String?,
      sortIndex: map['sortIndex'] as int?,
      createTime: map['createTime'] as DateTime?,
      updateTime: map['updateTime'] as DateTime?,
    );
  }

//</editor-fold>
}
