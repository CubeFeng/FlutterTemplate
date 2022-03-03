import 'package:flutter_ucore/generated/json/base/json_convert_content.dart';

class UserMessageModelEntity with JsonConvert<UserMessageModelEntity> {
  String? account; //当前登录的账号
  int? authState; //认证状态
  String? email; //邮箱
  int? expireTime; //token过期时间,单位秒
  String? headImg; //头像
  int? loginType; //登录方式：1-账号/人脸登录，2-账号/密码登录
  String? mobile; //绑定的手机号
  String? nickname; //用户昵称
  String? refreshToken; //刷新token
  String? regDate; //注册时间
  String? token;
  String? trueName; //真实姓名
  String? userId; //用户id
  String? userSn; //用户邀请码
}
