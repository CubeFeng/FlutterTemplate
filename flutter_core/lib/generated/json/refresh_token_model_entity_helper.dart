import 'package:flutter_ucore/models/user/refresh_token_model_entity.dart';

refreshTokenModelEntityFromJson(RefreshTokenModelEntity data, Map<String, dynamic> json) {
  if (json['expireTime'] != null) {
    data.expireTime = json['expireTime'] is String ? int.tryParse(json['expireTime']) : json['expireTime'].toInt();
  }
  if (json['refreshToken'] != null) {
    data.refreshToken = json['refreshToken'].toString();
  }
  if (json['token'] != null) {
    data.token = json['token'].toString();
  }
  return data;
}

Map<String, dynamic> refreshTokenModelEntityToJson(RefreshTokenModelEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['expireTime'] = entity.expireTime;
  data['refreshToken'] = entity.refreshToken;
  data['token'] = entity.token;
  return data;
}
