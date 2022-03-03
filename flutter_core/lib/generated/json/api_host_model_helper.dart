import 'package:flutter_ucore/apis/api_host_model.dart';

apiHostModelFromJson(ApiHostModel data, Map<String, dynamic> json) {
  if (json['apiHost'] != null) {
    data.apiHost = json['apiHost'].toString();
  }
  if (json['wsHost'] != null) {
    data.wsHost = json['wsHost'].toString();
  }
  if (json['helpHost'] != null) {
    data.helpHost = json['helpHost'].toString();
  }
  return data;
}

Map<String, dynamic> apiHostModelToJson(ApiHostModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['apiHost'] = entity.apiHost;
  data['wsHost'] = entity.wsHost;
  data['helpHost'] = entity.helpHost;
  return data;
}
