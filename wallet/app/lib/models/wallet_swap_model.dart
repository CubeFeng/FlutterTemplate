import 'package:flutter_wallet/generated/json_partner/json_partner.dart';
import 'package:flutter_wallet/models/wallet_banner_model.dart';
import 'package:flutter_wallet/models/wallet_kind_model.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class WalletSwapModel {
  @JsonKey(toJson: $WalletBannerModelListToJson)
  List<WalletBannerModel>? walletBanner;
  @JsonKey(toJson: $WalletKindModelListToJson)
  List<WalletKindModel>? walletKind;

  WalletSwapModel({
    this.walletBanner,
    this.walletKind,
  });

  Map<String, dynamic> toDeepJson() => <String, dynamic>{
        'walletBanner': walletBanner?.map((e) => e.toJson()).toList(),
        'walletKind': walletKind?.map((e) => e.toJson()).toList(),
      };
}

List<dynamic>? $WalletBannerModelListToJson(List<WalletBannerModel>? source) =>
    source?.map((e) => e.toJson()).toList();

List<dynamic>? $WalletKindModelListToJson(List<WalletKindModel>? source) =>
    source?.map((e) => e.toJson()).toList();
