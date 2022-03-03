import 'package:flutter_ucore/models/user_model.dart';

userModelFromJson(UserModel data, Map<String, dynamic> json) {
  if (json['userId'] != null) {
    data.userId = json['userId'].toString();
  }
  if (json['account'] != null) {
    data.account = json['account'].toString();
  }
  if (json['authState'] != null) {
    data.authState = json['authState'] is String ? int.tryParse(json['authState']) : json['authState'].toInt();
  }
  if (json['email'] != null) {
    data.email = json['email'].toString();
  }
  if (json['expireTime'] != null) {
    data.expireTime = json['expireTime'] is String ? int.tryParse(json['expireTime']) : json['expireTime'].toInt();
  }
  if (json['headImg'] != null) {
    data.headImg = json['headImg'].toString();
  }
  if (json['loginType'] != null) {
    data.loginType = json['loginType'] is String ? int.tryParse(json['loginType']) : json['loginType'].toInt();
  }
  if (json['mobile'] != null) {
    data.mobile = json['mobile'].toString();
  }
  if (json['nickname'] != null) {
    data.nickname = json['nickname'].toString();
  }
  if (json['refreshToken'] != null) {
    data.refreshToken = json['refreshToken'].toString();
  }
  if (json['token'] != null) {
    data.token = json['token'].toString();
  }
  if (json['regDate'] != null) {
    data.regDate = json['regDate'].toString();
  }
  if (json['trueName'] != null) {
    data.trueName = json['trueName'].toString();
  }
  if (json['userSn'] != null) {
    data.userSn = json['userSn'].toString();
  }
  return data;
}

Map<String, dynamic> userModelToJson(UserModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['userId'] = entity.userId;
  data['account'] = entity.account;
  data['authState'] = entity.authState;
  data['email'] = entity.email;
  data['expireTime'] = entity.expireTime;
  data['headImg'] = entity.headImg;
  data['loginType'] = entity.loginType;
  data['mobile'] = entity.mobile;
  data['nickname'] = entity.nickname;
  data['refreshToken'] = entity.refreshToken;
  data['token'] = entity.token;
  data['regDate'] = entity.regDate;
  data['trueName'] = entity.trueName;
  data['userSn'] = entity.userSn;
  return data;
}
