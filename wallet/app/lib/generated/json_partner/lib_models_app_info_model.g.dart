// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppInfoModel _$AppInfoModelFromJson(Map<String, dynamic> json) => AppInfoModel()
  ..channelType = _$safelyAsString(json['channelType'])
  ..channelName = _$safelyAsString(json['channelName'])
  ..channelVersion = _$safelyAsString(json['channelVersion'])
  ..buildTime = _$safelyAsString(json['buildTime'])
  ..commitId = _$safelyAsString(json['commitId'])
  ..branch = _$safelyAsString(json['branch'])
  ..version = _$safelyAsString(json['version'])
  ..buildVersion = _$safelyAsString(json['buildVersion'])
  ..packageName = _$safelyAsString(json['packageName'])
  ..deviceId = _$safelyAsString(json['deviceId']);

Map<String, dynamic> _$AppInfoModelToJson(AppInfoModel instance) =>
    <String, dynamic>{
      'channelType': instance.channelType,
      'channelName': instance.channelName,
      'channelVersion': instance.channelVersion,
      'buildTime': instance.buildTime,
      'commitId': instance.commitId,
      'branch': instance.branch,
      'version': instance.version,
      'buildVersion': instance.buildVersion,
      'packageName': instance.packageName,
      'deviceId': instance.deviceId,
    };
