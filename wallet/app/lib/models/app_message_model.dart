import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AppMessageModel {
  /// id
  String? id;

  /// 类型
  String? type;

  /// 标题
  String? title;

  /// 内容
  String? content;

  /// 创建时间
  String? createTime;

  /// 更新时间
  String? updateTime;

  /// 状态 1已经查看 0为查看
  String? status;
}
