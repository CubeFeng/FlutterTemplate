import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TokenItemModel {
  String? consensus;
  String? coin;
  String? coinUnit;
  String? contract;
  int? gasLimit;
  int? decimals;
  int? confirmations;
  String? iconUrl;
  String? remark;
  String? tokenUrl;
  String? showToken;
  String? agreement;
  String? description;
  String? dappUrl;
}
