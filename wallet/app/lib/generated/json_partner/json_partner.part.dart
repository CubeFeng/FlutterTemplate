// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JsonPartner
// **************************************************************************

part of 'json_partner.dart';
  
dynamic _getToJson<T>(Type type, data) {
  switch (type) {
    case ApiHostModel:
      return _$ApiHostModelToJson(data);
  case VersionInfoModel:
      return _$VersionInfoModelToJson(data);
  case SwapItemModel:
      return _$SwapItemModelToJson(data);
  case AppMessageModel:
      return _$AppMessageModelToJson(data);
  case TransactionInfoModel:
      return _$TransactionInfoModelToJson(data);
  case TokenItemModel:
      return _$TokenItemModelToJson(data);
  case NodeInfoModel:
      return _$NodeInfoModelToJson(data);
  case WalletBannerModel:
      return _$WalletBannerModelToJson(data);
  case AppInfoModel:
      return _$AppInfoModelToJson(data);
  case TokenInfoModel:
      return _$TokenInfoModelToJson(data);
  case WalletSwapModel:
      return _$WalletSwapModelToJson(data);
  case UCNewsItemModel:
      return _$UCNewsItemModelToJson(data);
  case TransactionPageModel:
      return _$TransactionPageModelToJson(data);
  case WalletKindModel:
      return _$WalletKindModelToJson(data);

  }
  return data as T;
}

dynamic _fromJsonSingle<M>(json) {
  final type = M.toString();
    if (type == (ApiHostModel).toString()) {
    return _$ApiHostModelFromJson(json);
  }
    if (type == (VersionInfoModel).toString()) {
    return _$VersionInfoModelFromJson(json);
  }
    if (type == (SwapItemModel).toString()) {
    return _$SwapItemModelFromJson(json);
  }
    if (type == (AppMessageModel).toString()) {
    return _$AppMessageModelFromJson(json);
  }
    if (type == (TransactionInfoModel).toString()) {
    return _$TransactionInfoModelFromJson(json);
  }
    if (type == (TokenItemModel).toString()) {
    return _$TokenItemModelFromJson(json);
  }
    if (type == (NodeInfoModel).toString()) {
    return _$NodeInfoModelFromJson(json);
  }
    if (type == (WalletBannerModel).toString()) {
    return _$WalletBannerModelFromJson(json);
  }
    if (type == (AppInfoModel).toString()) {
    return _$AppInfoModelFromJson(json);
  }
    if (type == (TokenInfoModel).toString()) {
    return _$TokenInfoModelFromJson(json);
  }
    if (type == (WalletSwapModel).toString()) {
    return _$WalletSwapModelFromJson(json);
  }
    if (type == (UCNewsItemModel).toString()) {
    return _$UCNewsItemModelFromJson(json);
  }
    if (type == (TransactionPageModel).toString()) {
    return _$TransactionPageModelFromJson(json);
  }
    if (type == (WalletKindModel).toString()) {
    return _$WalletKindModelFromJson(json);
  }
  
  return null;
}

M _getListChildType<M>(List data) {
    if (<ApiHostModel>[] is M) {
    return data.map<ApiHostModel>((e) => _$ApiHostModelFromJson(e)).toList() as M;
  }
  if (<VersionInfoModel>[] is M) {
    return data.map<VersionInfoModel>((e) => _$VersionInfoModelFromJson(e)).toList() as M;
  }
  if (<SwapItemModel>[] is M) {
    return data.map<SwapItemModel>((e) => _$SwapItemModelFromJson(e)).toList() as M;
  }
  if (<AppMessageModel>[] is M) {
    return data.map<AppMessageModel>((e) => _$AppMessageModelFromJson(e)).toList() as M;
  }
  if (<TransactionInfoModel>[] is M) {
    return data.map<TransactionInfoModel>((e) => _$TransactionInfoModelFromJson(e)).toList() as M;
  }
  if (<TokenItemModel>[] is M) {
    return data.map<TokenItemModel>((e) => _$TokenItemModelFromJson(e)).toList() as M;
  }
  if (<NodeInfoModel>[] is M) {
    return data.map<NodeInfoModel>((e) => _$NodeInfoModelFromJson(e)).toList() as M;
  }
  if (<WalletBannerModel>[] is M) {
    return data.map<WalletBannerModel>((e) => _$WalletBannerModelFromJson(e)).toList() as M;
  }
  if (<AppInfoModel>[] is M) {
    return data.map<AppInfoModel>((e) => _$AppInfoModelFromJson(e)).toList() as M;
  }
  if (<TokenInfoModel>[] is M) {
    return data.map<TokenInfoModel>((e) => _$TokenInfoModelFromJson(e)).toList() as M;
  }
  if (<WalletSwapModel>[] is M) {
    return data.map<WalletSwapModel>((e) => _$WalletSwapModelFromJson(e)).toList() as M;
  }
  if (<UCNewsItemModel>[] is M) {
    return data.map<UCNewsItemModel>((e) => _$UCNewsItemModelFromJson(e)).toList() as M;
  }
  if (<TransactionPageModel>[] is M) {
    return data.map<TransactionPageModel>((e) => _$TransactionPageModelFromJson(e)).toList() as M;
  }
  if (<WalletKindModel>[] is M) {
    return data.map<WalletKindModel>((e) => _$WalletKindModelFromJson(e)).toList() as M;
  }

  throw Exception('not support type');
}

/// ApiHostModelFactory
extension ApiHostModelFactory on ApiHostModel {
  /// fromJson
  static ApiHostModel fromJson(json) => JsonPartner.fromJsonAsT<ApiHostModel>(json);
  
  /// toJson
  Map<String, dynamic> toJson() => JsonPartner.toJsonByT(this);
}

/// VersionInfoModelFactory
extension VersionInfoModelFactory on VersionInfoModel {
  /// fromJson
  static VersionInfoModel fromJson(json) => JsonPartner.fromJsonAsT<VersionInfoModel>(json);
  
  /// toJson
  Map<String, dynamic> toJson() => JsonPartner.toJsonByT(this);
}

/// SwapItemModelFactory
extension SwapItemModelFactory on SwapItemModel {
  /// fromJson
  static SwapItemModel fromJson(json) => JsonPartner.fromJsonAsT<SwapItemModel>(json);
  
  /// toJson
  Map<String, dynamic> toJson() => JsonPartner.toJsonByT(this);
}

/// AppMessageModelFactory
extension AppMessageModelFactory on AppMessageModel {
  /// fromJson
  static AppMessageModel fromJson(json) => JsonPartner.fromJsonAsT<AppMessageModel>(json);
  
  /// toJson
  Map<String, dynamic> toJson() => JsonPartner.toJsonByT(this);
}

/// TransactionInfoModelFactory
extension TransactionInfoModelFactory on TransactionInfoModel {
  /// fromJson
  static TransactionInfoModel fromJson(json) => JsonPartner.fromJsonAsT<TransactionInfoModel>(json);
  
  /// toJson
  Map<String, dynamic> toJson() => JsonPartner.toJsonByT(this);
}

/// TokenItemModelFactory
extension TokenItemModelFactory on TokenItemModel {
  /// fromJson
  static TokenItemModel fromJson(json) => JsonPartner.fromJsonAsT<TokenItemModel>(json);
  
  /// toJson
  Map<String, dynamic> toJson() => JsonPartner.toJsonByT(this);
}

/// NodeInfoModelFactory
extension NodeInfoModelFactory on NodeInfoModel {
  /// fromJson
  static NodeInfoModel fromJson(json) => JsonPartner.fromJsonAsT<NodeInfoModel>(json);
  
  /// toJson
  Map<String, dynamic> toJson() => JsonPartner.toJsonByT(this);
}

/// WalletBannerModelFactory
extension WalletBannerModelFactory on WalletBannerModel {
  /// fromJson
  static WalletBannerModel fromJson(json) => JsonPartner.fromJsonAsT<WalletBannerModel>(json);
  
  /// toJson
  Map<String, dynamic> toJson() => JsonPartner.toJsonByT(this);
}

/// AppInfoModelFactory
extension AppInfoModelFactory on AppInfoModel {
  /// fromJson
  static AppInfoModel fromJson(json) => JsonPartner.fromJsonAsT<AppInfoModel>(json);
  
  /// toJson
  Map<String, dynamic> toJson() => JsonPartner.toJsonByT(this);
}

/// TokenInfoModelFactory
extension TokenInfoModelFactory on TokenInfoModel {
  /// fromJson
  static TokenInfoModel fromJson(json) => JsonPartner.fromJsonAsT<TokenInfoModel>(json);
  
  /// toJson
  Map<String, dynamic> toJson() => JsonPartner.toJsonByT(this);
}

/// WalletSwapModelFactory
extension WalletSwapModelFactory on WalletSwapModel {
  /// fromJson
  static WalletSwapModel fromJson(json) => JsonPartner.fromJsonAsT<WalletSwapModel>(json);
  
  /// toJson
  Map<String, dynamic> toJson() => JsonPartner.toJsonByT(this);
}

/// UCNewsItemModelFactory
extension UCNewsItemModelFactory on UCNewsItemModel {
  /// fromJson
  static UCNewsItemModel fromJson(json) => JsonPartner.fromJsonAsT<UCNewsItemModel>(json);
  
  /// toJson
  Map<String, dynamic> toJson() => JsonPartner.toJsonByT(this);
}

/// TransactionPageModelFactory
extension TransactionPageModelFactory on TransactionPageModel {
  /// fromJson
  static TransactionPageModel fromJson(json) => JsonPartner.fromJsonAsT<TransactionPageModel>(json);
  
  /// toJson
  Map<String, dynamic> toJson() => JsonPartner.toJsonByT(this);
}

/// WalletKindModelFactory
extension WalletKindModelFactory on WalletKindModel {
  /// fromJson
  static WalletKindModel fromJson(json) => JsonPartner.fromJsonAsT<WalletKindModel>(json);
  
  /// toJson
  Map<String, dynamic> toJson() => JsonPartner.toJsonByT(this);
}
