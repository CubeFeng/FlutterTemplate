// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwapItemModel _$SwapItemModelFromJson(Map<String, dynamic> json) =>
    SwapItemModel()
      ..id = _$safelyAsInt(json['id'])
      ..iconUrl = _$safelyAsString(json['iconUrl'])
      ..downloadUrl = _$safelyAsString(json['downloadUrl'])
      ..name = _$safelyAsString(json['name'])
      ..desc = _$safelyAsString(json['desc'])
      ..whiteLink = _$safelyAsString(json['whiteLink'])
      ..coin = _$safelyAsString(json['coin'])
      ..kind = _$safelyAsInt(json['kind']);

Map<String, dynamic> _$SwapItemModelToJson(SwapItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'iconUrl': instance.iconUrl,
      'downloadUrl': instance.downloadUrl,
      'name': instance.name,
      'desc': instance.desc,
      'whiteLink': instance.whiteLink,
      'coin': instance.coin,
      'kind': instance.kind,
    };
