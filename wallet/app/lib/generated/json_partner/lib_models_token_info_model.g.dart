// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenInfoModel _$TokenInfoModelFromJson(Map<String, dynamic> json) =>
    TokenInfoModel()
      ..id = _$safelyAsInt(json['id'])
      ..tokenId = _$safelyAsString(json['tokenId'])
      ..tokenUrl = _$safelyAsString(json['tokenUrl'])
      ..dappUrl = _$safelyAsString(json['dappUrl'])
      ..description = _$safelyAsString(json['description'])
      ..name = _$safelyAsString(json['name'])
      ..author = _$safelyAsString(json['author'])
      ..image = _$safelyAsString(json['image'])
      ..ownerAddress = _$safelyAsString(json['ownerAddress'])
      ..contractAddress = _$safelyAsString(json['contractAddress'])
      ..txHash = _$safelyAsString(json['txHash'])
      ..status = _$safelyAsString(json['status'])
      ..createTime = _$safelyAsString(json['createTime'])
      ..updateTime = _$safelyAsString(json['updateTime']);

Map<String, dynamic> _$TokenInfoModelToJson(TokenInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tokenId': instance.tokenId,
      'tokenUrl': instance.tokenUrl,
      'dappUrl': instance.dappUrl,
      'description': instance.description,
      'name': instance.name,
      'author': instance.author,
      'image': instance.image,
      'ownerAddress': instance.ownerAddress,
      'contractAddress': instance.contractAddress,
      'txHash': instance.txHash,
      'status': instance.status,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };
