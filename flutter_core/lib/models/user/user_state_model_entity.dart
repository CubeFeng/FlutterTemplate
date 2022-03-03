import 'package:flutter_ucore/generated/json/base/json_convert_content.dart';

class UserStateModelEntity with JsonConvert<UserStateModelEntity> {
  String? email; //用户绑定邮箱
  int? isFace; //是否用户绑定人脸
  String? mobile; //用户绑定手机号
  int? status; //用户实名状态
}
