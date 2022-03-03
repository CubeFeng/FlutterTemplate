import 'package:flutter_ucore/models/user/oauth_app_info_model.dart';

oauthAppInfoModelFromJson(OauthAppInfoModel data, Map<String, dynamic> json) {
  if (json['appId'] != null) {
    data.appId = json['appId'].toString();
  }
  if (json['appName'] != null) {
    data.appName = json['appName'].toString();
  }
  if (json['appHeader'] != null) {
    data.appHeader = json['appHeader'].toString();
  }
  if (json['lastModifiedAt'] != null) {
    data.lastModifiedAt = json['lastModifiedAt'].toString();
  }
  return data;
}

Map<String, dynamic> oauthAppInfoModelToJson(OauthAppInfoModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['appId'] = entity.appId;
  data['appName'] = entity.appName;
  data['appHeader'] = entity.appHeader;
  data['lastModifiedAt'] = entity.lastModifiedAt;
  return data;
}
