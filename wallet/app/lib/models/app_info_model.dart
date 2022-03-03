import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AppInfoModel {
  /// 渠道类型
  String? channelType;

  /// 渠道名称
  String? channelName;

  /// 渠道版本
  String? channelVersion;

  /// 编译时间
  String? buildTime;

  /// git 提交ID
  String? commitId;

  /// git 分支
  String? branch;

  /// 应用原生版本号
  String? version;

  /// 编译版本号
  String? buildVersion;

  /// app 的包名
  String? packageName;

  /// 设置唯一标识
  String? deviceId;
}
