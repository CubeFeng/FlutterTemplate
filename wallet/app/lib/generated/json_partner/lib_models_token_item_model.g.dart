// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenItemModel _$TokenItemModelFromJson(Map<String, dynamic> json) =>
    TokenItemModel()
      ..consensus = _$safelyAsString(json['consensus'])
      ..coin = _$safelyAsString(json['coin'])
      ..coinUnit = _$safelyAsString(json['coinUnit'])
      ..contract = _$safelyAsString(json['contract'])
      ..gasLimit = _$safelyAsInt(json['gasLimit'])
      ..decimals = _$safelyAsInt(json['decimals'])
      ..confirmations = _$safelyAsInt(json['confirmations'])
      ..iconUrl = _$safelyAsString(json['iconUrl'])
      ..remark = _$safelyAsString(json['remark'])
      ..tokenUrl = _$safelyAsString(json['tokenUrl'])
      ..showToken = _$safelyAsString(json['showToken'])
      ..agreement = _$safelyAsString(json['agreement'])
      ..description = _$safelyAsString(json['description'])
      ..dappUrl = _$safelyAsString(json['dappUrl']);

Map<String, dynamic> _$TokenItemModelToJson(TokenItemModel instance) =>
    <String, dynamic>{
      'consensus': instance.consensus,
      'coin': instance.coin,
      'coinUnit': instance.coinUnit,
      'contract': instance.contract,
      'gasLimit': instance.gasLimit,
      'decimals': instance.decimals,
      'confirmations': instance.confirmations,
      'iconUrl': instance.iconUrl,
      'remark': instance.remark,
      'tokenUrl': instance.tokenUrl,
      'showToken': instance.showToken,
      'agreement': instance.agreement,
      'description': instance.description,
      'dappUrl': instance.dappUrl,
    };
