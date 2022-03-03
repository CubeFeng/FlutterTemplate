import 'package:flutter_ucore/models/user/check_version_model_entity.dart';

checkVersionModelEntityFromJson(
    CheckVersionModelEntity data, Map<String, dynamic> json) {
  if (json['downloadUrl'] != null) {
    data.downloadUrl = json['downloadUrl'].toString();
  }
  if (json['forced'] != null) {
    data.forced = json['forced'] is String
        ? int.tryParse(json['forced'])
        : json['forced'].toInt();
  }
  if (json['id'] != null) {
    data.id =
        json['id'] is String ? int.tryParse(json['id']) : json['id'].toInt();
  }
  if (json['remark'] != null) {
    data.remark = json['remark'].toString();
  }
  if (json['version'] != null) {
    data.version = json['version'].toString();
  }
  if (json['content'] != null) {
    data.content = json['content'].toString();
  }
  return data;
}

Map<String, dynamic> checkVersionModelEntityToJson(
    CheckVersionModelEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['downloadUrl'] = entity.downloadUrl;
  data['forced'] = entity.forced;
  data['id'] = entity.id;
  data['remark'] = entity.remark;
  data['version'] = entity.version;
  data['content'] = entity.content;
  return data;
}
