import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TokenInfoModel {
  /// id
  int? id;

  /// tokenId
  String? tokenId;

  /// tokenUrl
  String? tokenUrl;

  /// tokenUrl
  String? dappUrl;

  /// description
  String? description;

  /// name
  String? name;

  /// author
  String? author;

  /// image
  String? image;

  /// ownerAddress
  String? ownerAddress;

  /// contractAddress
  String? contractAddress;

  /// txHash
  String? txHash;

  /// status
  String? status;

  /// createTime
  String? createTime;

  /// updateTime
  String? updateTime;
}
