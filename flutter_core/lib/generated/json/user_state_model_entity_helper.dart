import 'package:flutter_ucore/models/user/user_state_model_entity.dart';

userStateModelEntityFromJson(UserStateModelEntity data, Map<String, dynamic> json) {
  if (json['email'] != null) {
    data.email = json['email'].toString();
  }
  if (json['isFace'] != null) {
    data.isFace = json['isFace'] is String ? int.tryParse(json['isFace']) : json['isFace'].toInt();
  }
  if (json['mobile'] != null) {
    data.mobile = json['mobile'].toString();
  }
  if (json['status'] != null) {
    data.status = json['status'] is String ? int.tryParse(json['status']) : json['status'].toInt();
  }
  return data;
}

Map<String, dynamic> userStateModelEntityToJson(UserStateModelEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['email'] = entity.email;
  data['isFace'] = entity.isFace;
  data['mobile'] = entity.mobile;
  data['status'] = entity.status;
  return data;
}
