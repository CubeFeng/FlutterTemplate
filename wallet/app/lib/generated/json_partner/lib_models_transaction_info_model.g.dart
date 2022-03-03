// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionInfoModel _$TransactionInfoModelFromJson(
        Map<String, dynamic> json) =>
    TransactionInfoModel()
      ..amount = _$safelyAsString(json['amount'])
      ..blockHash = _$safelyAsString(json['blockHash'])
      ..blockNumber = _$safelyAsInt(json['blockNumber'])
      ..blocktime = _$safelyAsInt(json['blocktime'])
      ..coin = _$safelyAsString(json['coin'])
      ..contractAddress = _$safelyAsString(json['contractAddress'])
      ..fromAddr = _$safelyAsString(json['fromAddr'])
      ..toAddr = _$safelyAsString(json['toAddr'])
      ..gasLimit = _$safelyAsString(json['gasLimit'])
      ..gasPrice = _$safelyAsString(json['gasPrice'])
      ..minerFee = _$safelyAsString(json['minerFee'])
      ..remark = _$safelyAsString(json['remark'])
      ..status = _$safelyAsInt(json['status'])
      ..txHash = _$safelyAsString(json['txHash'])
      ..txIndex = _$safelyAsInt(json['txIndex']);

Map<String, dynamic> _$TransactionInfoModelToJson(
        TransactionInfoModel instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'blockHash': instance.blockHash,
      'blockNumber': instance.blockNumber,
      'blocktime': instance.blocktime,
      'coin': instance.coin,
      'contractAddress': instance.contractAddress,
      'fromAddr': instance.fromAddr,
      'toAddr': instance.toAddr,
      'gasLimit': instance.gasLimit,
      'gasPrice': instance.gasPrice,
      'minerFee': instance.minerFee,
      'remark': instance.remark,
      'status': instance.status,
      'txHash': instance.txHash,
      'txIndex': instance.txIndex,
    };
