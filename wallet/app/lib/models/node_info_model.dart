import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class NodeInfoModel {
  int? id;
  String? coin;
  String? nodeName;
  String? nodeUrl;
}
