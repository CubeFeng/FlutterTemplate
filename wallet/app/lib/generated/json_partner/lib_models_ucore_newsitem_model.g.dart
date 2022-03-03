// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UCNewsItemModel _$UCNewsItemModelFromJson(Map<String, dynamic> json) =>
    UCNewsItemModel()
      ..id = _$safelyAsInt(json['id'])
      ..newsTitle = _$safelyAsString(json['newsTitle'])
      ..newsBriefly = _$safelyAsString(json['newsBriefly'])
      ..titleImg = _$safelyAsString(json['titleImg'])
      ..rssName = _$safelyAsString(json['rssName'])
      ..time =
          json['time'] == null ? null : DateTime.parse(_$safelyAsString(json['time'])!)
      ..sourceUrl = _$safelyAsString(json['sourceUrl'])
      ..sourceId = _$safelyAsInt(json['sourceId'])
      ..isSubscribe = _$safelyAsInt(json['isSubscribe']);

Map<String, dynamic> _$UCNewsItemModelToJson(UCNewsItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'newsTitle': instance.newsTitle,
      'newsBriefly': instance.newsBriefly,
      'titleImg': instance.titleImg,
      'rssName': instance.rssName,
      'time': instance.time?.toIso8601String(),
      'sourceUrl': instance.sourceUrl,
      'sourceId': instance.sourceId,
      'isSubscribe': instance.isSubscribe,
    };
