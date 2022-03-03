import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TransactionInfoModel {
  String? amount;
  String? blockHash;
  int? blockNumber;
  int? blocktime;
  String? coin;
  String? contractAddress;
  String? fromAddr;
  String? toAddr;
  String? gasLimit;
  String? gasPrice;
  String? minerFee;
  String? remark;
  int? status;
  String? txHash;
  int? txIndex;
}
