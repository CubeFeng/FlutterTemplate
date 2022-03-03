// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppMessageModel _$AppMessageModelFromJson(Map<String, dynamic> json) =>
    AppMessageModel()
      ..id = _$safelyAsString(json['id'])
      ..type = _$safelyAsString(json['type'])
      ..title = _$safelyAsString(json['title'])
      ..content = _$safelyAsString(json['content'])
      ..createTime = _$safelyAsString(json['createTime'])
      ..updateTime = _$safelyAsString(json['updateTime'])
      ..status = _$safelyAsString(json['status']);

Map<String, dynamic> _$AppMessageModelToJson(AppMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'content': instance.content,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'status': instance.status,
    };
