// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletKindModel _$WalletKindModelFromJson(Map<String, dynamic> json) =>
    WalletKindModel(
      id: _$safelyAsInt(json['id']),
      name: _$safelyAsString(json['name']),
    );

Map<String, dynamic> _$WalletKindModelToJson(WalletKindModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
