// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionPageModel _$TransactionPageModelFromJson(
        Map<String, dynamic> json) =>
    TransactionPageModel()
      ..size = _$safelyAsInt(json['size'])
      ..total = _$safelyAsInt(json['total'])
      ..current = _$safelyAsInt(json['current'])
      ..pages = _$safelyAsInt(json['pages'])
      ..records = (json['records'] as List<dynamic>?)
          ?.map((e) => _$TransactionInfoModelFromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$TransactionPageModelToJson(
        TransactionPageModel instance) =>
    <String, dynamic>{
      'size': instance.size,
      'total': instance.total,
      'current': instance.current,
      'pages': instance.pages,
      'records': $TransactionInfoModelListToJson(instance.records),
    };
