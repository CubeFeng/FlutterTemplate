import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class WalletKindModel {
  /// icon
  int? id;

  /// tokenUrl
  String? name;

  WalletKindModel({
    this.id,
    this.name,
  });


}
