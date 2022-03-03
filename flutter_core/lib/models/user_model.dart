import 'package:flutter_ucore/generated/json/base/json_convert_content.dart';

class UserModel with JsonConvert<UserModel> {
  /// 用户id
  String? userId;

  /// 当前登录的账号
  String? account;

  /// 认证状态
  int? authState;

  /// 邮箱
  String? email;

  /// token过期时间,单位秒
  int? expireTime;

  /// 头像
  String? headImg;

  /// 登录方式：1-账号/人脸登录，2-账号/密码登录
  int? loginType;

  /// 绑定的手机号
  String? mobile;

  /// 用户昵称
  String? nickname;

  /// 刷新token
  String? refreshToken;

  /// token
  String? token;

  /// 注册时间
  String? regDate;

  /// 真实姓名
  String? trueName;

  /// 用户邀请码
  String? userSn;
}
