// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionInfoModel _$VersionInfoModelFromJson(Map<String, dynamic> json) =>
    VersionInfoModel()
      ..versionNo = _$safelyAsString(json['versionNo'])
      ..minVersionNo = _$safelyAsString(json['minVersionNo'])
      ..h5Url = _$safelyAsString(json['h5Url'])
      ..serialNo = _$safelyAsString(json['serialNo'])
      ..versionContent = _$safelyAsString(json['versionContent'])
      ..downloadUrl = _$safelyAsString(json['downloadUrl'])
      ..forceUpdate = _$safelyAsBool(json['forceUpdate']);

Map<String, dynamic> _$VersionInfoModelToJson(VersionInfoModel instance) =>
    <String, dynamic>{
      'versionNo': instance.versionNo,
      'minVersionNo': instance.minVersionNo,
      'h5Url': instance.h5Url,
      'serialNo': instance.serialNo,
      'versionContent': instance.versionContent,
      'downloadUrl': instance.downloadUrl,
      'forceUpdate': instance.forceUpdate,
    };
