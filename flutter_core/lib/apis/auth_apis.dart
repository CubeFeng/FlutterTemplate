import 'package:flutter_ucore/apis/api_urls.dart';
import 'package:flutter_ucore/models/user_model.dart';
import 'package:flutter_ucore/services/app_service.dart';
import 'package:flutter_ucore/services/config_service.dart';
import 'package:flutter_ucore/services/http_service.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
// import 'package:flutter_base_kit/net/http/http.dart';

class AuthApi {
  /// 用户登录
  ///
  /// [account] 手机号/邮箱
  /// [neCaptchaValidate] 网易验证码
  /// [type] 登录类型 1: 刷脸登录; 2: 账号密码登录
  /// [password] 密码
  /// [image] 人脸图片
  /// [suffixName] 图片格式
  /// [faceToken] 人脸token
  static Future<ResponseModel<UserModel?>> authUserLogin({
    required String account,
    required String neCaptchaValidate,
    int type = 2,
    String? password,
    String? area,
    String? image,
    String? suffixName = 'png',
    String? faceToken,
  }) async {
    final appInfo = await AppService.service.info;
    final appConfig = ConfigService.service;

    String headerEncrypt = '';
    String passwordEncrypt = '';
    if (password != null) {
      final deviceId = appInfo?.deviceId?.substring(0, 16) ?? '';
      passwordEncrypt = EncryptUtils.aesEncrypt(password, deviceId);
      headerEncrypt = EncryptUtils.rsaEncrypt(deviceId, publicKey: appConfig.rsaPublicKey);
    }

    final Map<String, dynamic> data = {
      'device': appInfo?.deviceId,
      'deviceIp': '127.0.0.1',
      'operatingSystem': DeviceUtils.isAndroid ? 1 : 2,
      'account': account,
      'neCaptchaValidate': neCaptchaValidate,
      'type': type,
      'password': passwordEncrypt,
      'area': area,
      'image': image,
      'suffixName': suffixName,
      'token': faceToken,
    };
    return HttpService.to.http
        .post<UserModel>(ApiUrls.authUserLogin, data: data, options: Options(headers: {'encry': headerEncrypt}));
  }
}
