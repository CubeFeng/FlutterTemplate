import 'package:flutter_ucore/models/user/user_head_name_model_entity.dart';

userHeadNameModelEntityFromJson(UserHeadNameModelEntity data, Map<String, dynamic> json) {
  if (json['headImg'] != null) {
    data.headImg = json['headImg'].toString();
  }
  if (json['nickname'] != null) {
    data.nickname = json['nickname'].toString();
  }
  return data;
}

Map<String, dynamic> userHeadNameModelEntityToJson(UserHeadNameModelEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['headImg'] = entity.headImg;
  data['nickname'] = entity.nickname;
  return data;
}
