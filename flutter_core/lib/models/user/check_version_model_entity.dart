import 'package:flutter_ucore/generated/json/base/json_convert_content.dart';

class CheckVersionModelEntity with JsonConvert<CheckVersionModelEntity> {
  String? downloadUrl; //下载地址：
  int? forced; //是否强制 0 不强制 1 强制
  int? id; //id
  String? remark; //备注
  String? version; //版本
  String? content;
}
