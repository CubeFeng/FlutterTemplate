import 'package:flutter_template/generated/json/base/json_convert_content.dart';

class AppInfoModel with JsonConvert<AppInfoModel> {
  String? channelType;
  String? channelName;
  String? channelVersion;
  String? buildTime;
  String? commitId;
  String? branch;
  String? version;
  String? buildVersion;
  String? packageName;
  String? deviceId;
}