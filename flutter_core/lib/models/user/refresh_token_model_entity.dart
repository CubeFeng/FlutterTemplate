import 'package:flutter_ucore/generated/json/base/json_convert_content.dart';

class RefreshTokenModelEntity with JsonConvert<RefreshTokenModelEntity> {
  int? expireTime; //token过期时间,单位秒
  String? refreshToken; //刷新token
  String? token;
}
