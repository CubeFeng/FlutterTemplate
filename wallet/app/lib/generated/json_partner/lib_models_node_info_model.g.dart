// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeInfoModel _$NodeInfoModelFromJson(Map<String, dynamic> json) =>
    NodeInfoModel()
      ..id = _$safelyAsInt(json['id'])
      ..coin = _$safelyAsString(json['coin'])
      ..nodeName = _$safelyAsString(json['nodeName'])
      ..nodeUrl = _$safelyAsString(json['nodeUrl']);

Map<String, dynamic> _$NodeInfoModelToJson(NodeInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coin': instance.coin,
      'nodeName': instance.nodeName,
      'nodeUrl': instance.nodeUrl,
    };
