import 'package:flutter_ucore/models/user/app_information_model.dart';

appInformationModelFromJson(AppInformationModel data, Map<String, dynamic> json) {
  if (json['appId'] != null) {
    data.appId = json['appId'].toString();
  }
  if (json['appHeader'] != null) {
    data.appHeader = json['appHeader'].toString();
  }
  if (json['appName'] != null) {
    data.appName = json['appName'].toString();
  }
  return data;
}

Map<String, dynamic> appInformationModelToJson(AppInformationModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['appId'] = entity.appId;
  data['appHeader'] = entity.appHeader;
  data['appName'] = entity.appName;
  return data;
}
