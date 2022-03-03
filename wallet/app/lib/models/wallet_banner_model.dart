import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class WalletBannerModel {
  /// icon
  String? icon;

  /// tokenUrl
  String? link;

  WalletBannerModel({
    this.icon,
    this.link,
  });


}
