// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JsonPartner
// **************************************************************************


import 'package:flutter_wallet/apis/api_host_model.dart';
import 'package:flutter_wallet/models/version_info_model.dart';
import 'package:flutter_wallet/models/swap_item_model.dart';
import 'package:flutter_wallet/models/app_message_model.dart';
import 'package:flutter_wallet/models/transaction_info_model.dart';
import 'package:flutter_wallet/models/token_item_model.dart';
import 'package:flutter_wallet/models/node_info_model.dart';
import 'package:flutter_wallet/models/wallet_banner_model.dart';
import 'package:flutter_wallet/models/app_info_model.dart';
import 'package:flutter_wallet/models/token_info_model.dart';
import 'package:flutter_wallet/models/wallet_swap_model.dart';
import 'package:flutter_wallet/models/ucore_newsitem_model.dart';
import 'package:flutter_wallet/models/transaction_page_model.dart';
import 'package:flutter_wallet/models/wallet_kind_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lib_apis_api_host_model.g.dart';
part 'lib_models_version_info_model.g.dart';
part 'lib_models_swap_item_model.g.dart';
part 'lib_models_app_message_model.g.dart';
part 'lib_models_transaction_info_model.g.dart';
part 'lib_models_token_item_model.g.dart';
part 'lib_models_node_info_model.g.dart';
part 'lib_models_wallet_banner_model.g.dart';
part 'lib_models_app_info_model.g.dart';
part 'lib_models_token_info_model.g.dart';
part 'lib_models_wallet_swap_model.g.dart';
part 'lib_models_ucore_newsitem_model.g.dart';
part 'lib_models_transaction_page_model.g.dart';
part 'lib_models_wallet_kind_model.g.dart';
part 'json_partner.part.dart';

/// JsonPartner
mixin JsonPartner<T> {
  /// toJson
  Map<String, dynamic> toJson() => _getToJson<T>(runtimeType, this);

  /// toJsonByT
  static Map<String, dynamic> toJsonByT<M>(M m) => _getToJson<M>(m.runtimeType, m);

  /// fromJsonAsT
  static M fromJsonAsT<M>(json) => (json is List) ? _getListChildType<M>(json) : _fromJsonSingle<M>(json) as M;
}

bool? _$safelyAsBool(value) => (value is bool) ? value : null;
int? _$safelyAsInt(value) => (value is int) ? value : (value is num) ? value.toInt() : (value is String) ? int.tryParse(value) : int.tryParse(value?.toString() ?? '');
double? _$safelyAsDouble(value) => (value is double) ? value : (value is num) ? value.toDouble() : (value is String) ? double.tryParse(value) : double.tryParse(value?.toString() ?? '');
String? _$safelyAsString(value) => (value is String) ? value : value?.toString();
