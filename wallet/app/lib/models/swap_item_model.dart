import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SwapItemModel {
  /// id
  int? id;

  /// iconUrl
  String? iconUrl;

  /// downloadUrl
  String? downloadUrl;

  /// name
  String? name;

  /// desc
  String? desc;

  /// whiteLink
  String? whiteLink;

  /// coin
  String? coin;

  /// kind 	1 DAPP 2 WEB 3 ACROSS_CHAIN
  int? kind;
}
