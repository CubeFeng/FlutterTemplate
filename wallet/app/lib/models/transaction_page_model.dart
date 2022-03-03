import 'package:flutter_wallet/generated/json_partner/json_partner.dart';
import 'package:flutter_wallet/models/transaction_info_model.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TransactionPageModel {
  int? size;
  int? total;
  int? current;
  int? pages;
  @JsonKey(toJson: $TransactionInfoModelListToJson)
  List<TransactionInfoModel>? records;
}

List<dynamic>? $TransactionInfoModelListToJson(
        List<TransactionInfoModel>? source) =>
    source?.map((e) => e.toJson()).toList();
