///钱包导入方式
enum WalletImportType {
  /// 助记词.
  menmonic,

  /// 私钥.
  privatyKey,

  /// KeyStore 文件.
  keyStore,
}
///钱包创建方式
enum WalletCreateType {
  /// 网络扩展
  netExtend,

  /// 创建HD
  hdCreate,

  /// 导入HD
  hdImport,

  /// 创建单链
  singleCreate,

  /// 单链导入
  singleImport,
}

extension WalletImportTypeExtension on WalletImportType {
  // String get type => describeEnum(this);
  String get typeName {
    switch (this) {
      case WalletImportType.menmonic:
        return 'menmonic';
      case WalletImportType.privatyKey:
        return 'privatyKey';
      case WalletImportType.keyStore:
        return 'keyStore';
      default:
        return 'menmonic';
    }
  }
}

WalletImportType getImpType(String value) {

  switch (value) {
    case 'menmonic':
      return WalletImportType.menmonic;
    case 'privatyKey':
      return WalletImportType.privatyKey;
    case 'keyStore':
      return WalletImportType.keyStore;
    default:
      return WalletImportType.menmonic;
  }
}

extension WalletCreateTypeExtension on WalletCreateType {
  // String get type => describeEnum(this);
  String get typeName {
    switch (this) {
      case WalletCreateType.netExtend:
        return 'netExtend';
      case WalletCreateType.hdCreate:
        return 'hdCreate';
      case WalletCreateType.hdImport:
        return 'hdImport';
      case WalletCreateType.singleCreate:
        return 'singleCreate';
      case WalletCreateType.singleImport:
        return 'singleImport';
      default:
        return 'singleImport';
    }
  }
}

WalletCreateType getCreateType(String value) {

  switch (value) {
    case 'netExtend':
      return WalletCreateType.netExtend;
    case 'hdCreate':
      return WalletCreateType.hdCreate;
    case 'hdImport':
      return WalletCreateType.hdImport;
    case 'singleCreate':
      return WalletCreateType.singleCreate;
    case 'singleImport':
      return WalletCreateType.singleImport;
    default:
      return WalletCreateType.singleImport;
  }
}

class ImportTypeModel {
  final String title;

  final String subtitle;

  final String iconpath;

  final WalletImportType importType;

  ImportTypeModel(this.title, this.subtitle, this.iconpath, this.importType);

  List<Object?> get props => throw UnimplementedError();
}

class WalletItemModel {
  final String title;

  final String iconPath;

  ///状态 创建中0 成功1 失败2
  String status;

  WalletItemModel(this.title, this.iconPath, this.status,);

  List<Object?> get props => throw UnimplementedError();
}
