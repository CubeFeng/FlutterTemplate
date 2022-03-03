// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletSwapModel _$WalletSwapModelFromJson(Map<String, dynamic> json) =>
    WalletSwapModel(
      walletBanner: (json['walletBanner'] as List<dynamic>?)
          ?.map((e) => _$WalletBannerModelFromJson(e as Map<String, dynamic>))
          .toList(),
      walletKind: (json['walletKind'] as List<dynamic>?)
          ?.map((e) => _$WalletKindModelFromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WalletSwapModelToJson(WalletSwapModel instance) =>
    <String, dynamic>{
      'walletBanner': $WalletBannerModelListToJson(instance.walletBanner),
      'walletKind': $WalletKindModelListToJson(instance.walletKind),
    };
