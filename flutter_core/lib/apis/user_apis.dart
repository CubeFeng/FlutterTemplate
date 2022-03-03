import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/api_urls.dart';
import 'package:flutter_ucore/models/app_info_model.dart';
import 'package:flutter_ucore/models/user/check_version_model_entity.dart';
import 'package:flutter_ucore/models/user/oauth_app_info_model.dart';
import 'package:flutter_ucore/models/user/user_head_name_model_entity.dart';
import 'package:flutter_ucore/models/user/user_message_model_entity.dart';
import 'package:flutter_ucore/models/user/user_state_model_entity.dart';
import 'package:flutter_ucore/services/app_service.dart';
import 'package:flutter_ucore/services/config_service.dart';
import 'package:flutter_ucore/services/http_service.dart';
import 'package:http_parser/http_parser.dart';

class UserApi {
  /// 上传图片
  /// [ fileBase64] base64加密
  ///[md5]md5值
  ///[suffixName]后缀名称 例如.txt .jpg .png 等
  static Future<ResponseModel<String>> rssFileUpload({
    String? md5,
    String? suffixName,
    String? fileBase64,
  }) async {
    return HttpService.to.http.post<String>(
      ApiUrls.rssFileUpload,
      data: {
        "md5": md5 ?? '',
        "suffixName": suffixName ?? '',
        "fileBase64": fileBase64 ?? '',
      },
    );
  }

  /// 照片/视频文件上传
  ///[file]视频文件
  ///[type]1-认证照片，2-视频
  static Future<ResponseModel<String>> rssFileUploadImg({
    required String file,
    required String type,
  }) async {
    final params = {
      'type': type,
    };
    final files = [file].map((f) {
      return MapEntry(
          'file',
          MultipartFile.fromFileSync(f,
              filename: type == '2' ? 'video.mp4' : 'image.jpg',
              contentType: type == '2' ? MediaType('video', 'mp4') : MediaType('image', 'png')));
    }).toList();

    final FormData formData = FormData.fromMap(params);
    formData.files.addAll(files);

    return HttpService.to.http.post<String>(
      ApiUrls.rssFileUploadImg,
      data: formData,
      contentType: ContentType.formData,
    );
  }

  /// 绑定用户人脸信息
  ///[image]人脸图片 BASE64
  ///[suffixName]后缀名称 例如 .jpg .png 等
  ///[deviceIp]设备IP
  ///[device]设备号

  static Future<ResponseModel<bool>> userFaceAdd({
    String? image,
    String? suffixName,
  }) async {
    final AppService appService = Get.find<AppService>();
    final AppInfoModel? appInfo = await appService.info;
    return HttpService.to.http.post<bool>(
      ApiUrls.userFaceAdd,
      data: {
        "image": image ?? '',
        "suffixName": suffixName ?? '',
        "device": appInfo?.deviceId ?? '',
        "deviceIp": '127.0.0.1',
      },
    );
  }

  /// 查找人脸是否存在
  ///[image]人脸图片 BASE64
  ///[suffixName]后缀名称 例如 .jpg .png 等
  static Future<ResponseModel<bool>> userFaceSearch({
    String? image,
    String? suffixName,
  }) async {
    return HttpService.to.http.post<bool>(
      ApiUrls.userFaceSearch,
      data: {
        "image": image ?? '',
        "suffixName": suffixName ?? '',
      },
    );
  }

  /// 提交实名认证
  ///[activeImg1]活体照片1
  ///[activeImg2]活体照片2
  ///[activeImg3]活体照片3
  /// [appOcrAudit]App匹配失败类型:1-证件照无法识别；2-活体照无法识别；
  /// 3-输入证件照与上传证件号不一致；4-输入姓名与上传证件姓名不一致；5-证件头像与活体匹配不一致
  /// [idCardBack]证件背面照
  /// [idCardFront]证件正面照
  /// [idCardHold]手持证件照
  /// [idVideoUrl]认证视频
  /// [mobile]手机号
  /// [name]	用户真实姓名
  /// [neCaptchaValidate]二次验证带过来的validate
  /// [paperWorkNumber]证件号
  /// [paperWorkType]证件类型:1—身份证；2—护照；3—其他；4—国外身份证；5-港澳台省份证
  /// [status]认证状态:默认为0；5.不需要审核；
  static Future<ResponseModel<bool>> userAuthAddUserAuth({
    String? activeImg1,
    String? activeImg2,
    String? activeImg3,
    required int appOcrAudit,
    String? idCardBack,
    String? idCardFront,
    String? idCardHold,
    String? idVideoUrl,
    String? mobile,
    String? name,
    String? neCaptchaValidate,
    String? paperWorkNumber,
    int? paperWorkType,
    int? status,
  }) async {
    return HttpService.to.http.post<bool>(
      ApiUrls.userAuthAddUserAuth,
      data: {
        "activeImg1": activeImg1 ?? '',
        "activeImg2": activeImg2 ?? '',
        "activeImg3": activeImg3 ?? '',
        "appOcrAudit": appOcrAudit,
        "idCardBack": idCardBack ?? '',
        "idCardFront": idCardFront ?? '',
        "idCardHold": idCardHold ?? '',
        "idVideoUrl": idVideoUrl ?? '',
        "mobile": mobile ?? '',
        "name": name ?? '',
        "neCaptchaValidate": neCaptchaValidate ?? '',
        "paperWorkNumber": paperWorkNumber ?? '',
        "paperWorkType": paperWorkType ?? '',
        "status": status ?? '',
      },
    );
  }

  /// 网易滑动式校验码验证
  ///[neCaptchaValidate]
  static Future<ResponseModel<dynamic>> userAuthInfoCheckNetEase({
    String? neCaptchaValidate,
  }) async {
    return HttpService.to.http.post<dynamic>(
      ApiUrls.userAuthInfoCheckNetEase,
      data: {
        "neCaptchaValidate": neCaptchaValidate ?? '',
      },
    );
  }

  /// 检查最新版本
  ///[osType]1-安卓，2-ios
  static Future<ResponseModel<CheckVersionModelEntity>> checkVersion({
    int? osType,
  }) async {
    return HttpService.to.http.get<CheckVersionModelEntity>('${ApiUrls.checkVersion}${osType ?? 1}',
        options: Options(headers: {'x-auth-token': 'noAuth'}));
  }

  /// 提交建议
  ///[contactDetails]   联系方式
  ///[content] 建议内容
  ///[imag] 相关图片
  ///[type] 建议类型：0-其他；1-APP布局优化；2-新增功能；3-主题源不够

  static Future<ResponseModel<bool>> suggestSubmit({
    String? contactDetails,
    String? content,
    String? image,
    int? type,
  }) async {
    return HttpService.to.http.post<bool>(
      ApiUrls.suggestSubmit,
      data: {
        "contactDetails": contactDetails ?? '',
        "content": content ?? '',
        "imag": image ?? '',
        "type": type ?? 0,
      },
    );
  }

  /// 用户人脸注册
  ///[account]账号，人脸注册时传值
  ///[area]地区
  ///[areaCode]手机区号
  ///[commendCode] 邀请码
  ///[device] 设备号
  ///[deviceIp] 设备IP
  ///[image]人脸图片base64
  ///[operatingSystem]操作系统 1Android 2 ios
  ///[password]密码
  ///[suffixName]后缀名称 例如 jpg png 等

  static Future<ResponseModel<UserMessageModelEntity>> userFaceRegister({
    String? account,
    String? area,
    String? areaCode,
    String? commendCode,
    String? device,
    String? deviceIp,
    String? image,
    int? operatingSystem,
    String? password,
    String? suffixName,
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

    return HttpService.to.http.post<UserMessageModelEntity>(ApiUrls.userFaceRegister,
        data: {
          "account": account ?? '',
          "area": area ?? '',
          "areaCode": areaCode ?? '',
          "commendCode": commendCode ?? '',
          "device": appInfo?.deviceId ?? '',
          "deviceIp": deviceIp ?? '127.0.0.1',
          "image": image ?? '',
          "operatingSystem": defaultTargetPlatform == TargetPlatform.android ? 1 : 2,
          "password": passwordEncrypt,
          "suffixName": suffixName ?? '',
        },
        options: Options(headers: {'encry': headerEncrypt}));
  }

  /// 找回密码
  ///[account]账号
  ///[captcha] 验证码key
  ///[captchaKey]验证码key
  ///[device] 设备号
  ///[deviceIp] ip地址
  ///[operatingSystem] 操作系统 1Android 2 ios
  ///[password] 新密码

  static Future<ResponseModel<bool>> userFindUserPwd({
    String? account,
    String? captcha,
    String? captchaKey,
    String? device,
    String? deviceIp,
    int? operatingSystem,
    String? password,
  }) async {
    final AppService appService = Get.find<AppService>();
    final AppInfoModel? appInfo = await appService.info;
    return HttpService.to.http.post<bool>(
      ApiUrls.userFindUserPwd,
      data: {
        "account": account ?? '',
        "captcha": captcha ?? '',
        "captchaKey": captchaKey ?? '',
        "device": appInfo?.deviceId ?? '',
        "deviceIp": deviceIp ?? '127.0.0.1',
        "operatingSystem": defaultTargetPlatform == TargetPlatform.android ? 1 : 2,
        "password": password ?? '',
      },
    );
  }

  /// 用户登出
  static Future<ResponseModel<bool>> userLoginOut() async {
    return HttpService.to.http.get<bool>(
      ApiUrls.userLoginOut,
    );
  }

  /// 查询用户绑定信息
  static Future<ResponseModel<UserStateModelEntity>> userQueryUserBand() async {
    return HttpService.to.http.get<UserStateModelEntity>(
      ApiUrls.userQueryUserBand,
    );
  }

  // /// 刷新token
  // ///[refreshToken]
  // static Future<ResponseModel<RefreshTokenModelEntity>> userRefresh({
  //   String? refreshToken,
  // }) async {
  //   return HttpService.to.http.get<RefreshTokenModelEntity>(
  //     ApiUrls.userRefresh,
  //     queryParameters: {
  //       "refreshToken": refreshToken ?? '',
  //     },
  //   );
  // }

  /// 用户邮箱注册
  ///[account]账号，人脸注册时传值
  ///[area]地区
  ///[areaCode]手机区号
  ///[captcha] 验证码
  /// [captchaKey]验证码key
  ///[commendCode] 邀请码
  ///[device] 设备号
  ///[deviceIp] 设备IP
  ///[email]
  ///[image]人脸图片base64
  ///[neCaptchaValidate]
  ///[operatingSystem]操作系统 1Android 2 ios
  ///[password]密码
  ///[type]注册方式:1人脸账号；3邮箱注册

  static Future<ResponseModel<UserMessageModelEntity>> userRegister({
    required String neCaptchaValidate,
    required String password,
    String? email,
    String? account,
    String? area,
    String? areaCode,
    String? captcha,
    String? captchaKey,
    String? commendCode,
    String? device,
    String? deviceIp,
    String? image,
    int? operatingSystem,
    int? type,
  }) async {
    final appInfo = await AppService.service.info;
    final appConfig = ConfigService.service;
    final deviceId = appInfo?.deviceId?.substring(0, 16) ?? '';
    String passwordEncrypt = EncryptUtils.aesEncrypt(password, deviceId);
    String headerEncrypt = EncryptUtils.rsaEncrypt(deviceId, publicKey: appConfig.rsaPublicKey);

    return HttpService.to.http.post<UserMessageModelEntity>(ApiUrls.userRegister,
        data: {
          "neCaptchaValidate": neCaptchaValidate,
          "account": account ?? '',
          "area": area ?? '',
          "areaCode": areaCode ?? '',
          "captcha": captcha ?? '',
          "captchaKey": captchaKey ?? '',
          "commendCode": commendCode ?? '',
          "device": appInfo?.deviceId ?? '',
          "deviceIp": deviceIp ?? '127.0.0.1',
          "email": email ?? '',
          "image": image ?? '',
          "operatingSystem": defaultTargetPlatform == TargetPlatform.android ? 1 : 2,
          "password": passwordEncrypt,
          "type": type ?? '',
        },
        options: Options(headers: {'encry': headerEncrypt}));
  }

  /// 邮箱验证码
  ///[email] 邮箱
  ///[type] 类型：1-注册，2-找回密码，3-绑定
  static Future<ResponseModel<String>> userRegisterCaptchaEmail({
    required String email,
    required int type,
  }) async {
    return HttpService.to.http.post<String>(
      ApiUrls.userRegisterCaptchaEmail,
      data: {
        "email": email,
        "type": type,
      },
    );
  }

  /// 登录修改密码
  ///[area] 地区
  ///[device] 设备号
  ///[deviceIp] ip地址
  ///[operatingSystem] 操作系统 1Android 2 ios
  ///[passwordNew] 新密码
  ///[passwordOld] 原密码

  static Future<ResponseModel<bool>> userResetUserPwd({
    String? area,
    String? device,
    String? deviceIp,
    int? operatingSystem,
    required String passwordNew,
    required String passwordOld,
  }) async {
    final AppService appService = Get.find<AppService>();
    final AppInfoModel? appInfo = await appService.info;
    final appConfig = ConfigService.service;
    final deviceId = appInfo?.deviceId?.substring(0, 16) ?? '';
    final passwordNewEncrypt = EncryptUtils.aesEncrypt(passwordNew, deviceId);
    final passwordOldEncrypt = EncryptUtils.aesEncrypt(passwordOld, deviceId);
    final headerEncrypt = EncryptUtils.rsaEncrypt(deviceId, publicKey: appConfig.rsaPublicKey);
    return HttpService.to.http.post<bool>(
      ApiUrls.userResetUserPwd,
      data: {
        "area": area ?? '',
        "device": appInfo?.deviceId ?? '',
        "deviceIp": deviceIp ?? '127.0.0.1',
        "operatingSystem": defaultTargetPlatform == TargetPlatform.android ? 1 : 2,
        "passwordNew": passwordNewEncrypt,
        "passwordOld": passwordOldEncrypt,
      },
      options: Options(headers: {'encry': headerEncrypt}),
    );
  }

  /// 绑定用户信息
  ///[captcha] 验证码
  ///[captchaKey]验证码key
  ///[device] 设备号
  ///[deviceIp] 设备IP
  ///[email]
  ///[operatingSystem]操作系统 1Android 2 ios

  static Future<ResponseModel<bool>> userSaveUserBand({
    String? captcha,
    String? captchaKey,
    String? device,
    String? deviceIp,
    String? email,
    int? operatingSystem,
  }) async {
    final AppService appService = Get.find<AppService>();
    final AppInfoModel? appInfo = await appService.info;
    return HttpService.to.http.post<bool>(
      ApiUrls.userSaveUserBand,
      data: {
        "captcha": captcha ?? '',
        "captchaKey": captchaKey ?? '',
        "device": appInfo?.deviceId ?? '',
        "deviceIp": deviceIp ?? '127.0.0.1',
        "email": email ?? '',
        "operatingSystem": defaultTargetPlatform == TargetPlatform.android ? 1 : 2,
      },
    );
  }

  ///修改用户信息
  ///[headImg]头像
  ///[nickname] 昵称
  ///[device] 设备号
  ///[deviceIp] 设备IP
  ///[operatingSystem]操作系统 1Android 2 ios

  static Future<ResponseModel<UserHeadNameModelEntity>> userUpdateUserInfo({
    String? headImg,
    String? nickname,
    String? device,
    String? deviceIp,
    int? operatingSystem,
  }) async {
    final AppService appService = Get.find<AppService>();
    final AppInfoModel? appInfo = await appService.info;
    return HttpService.to.http.post<UserHeadNameModelEntity>(
      ApiUrls.userUpdateUserInfo,
      data: {
        "headImg": headImg ?? '',
        "nickname": nickname ?? '',
        "device": appInfo?.deviceId ?? '',
        "deviceIp": deviceIp ?? '127.0.0.1',
        "operatingSystem": defaultTargetPlatform == TargetPlatform.android ? 1 : 2,
      },
    );
  }

  /// 获取用户授权的应用
  static Future<ResponseModel<List<OauthAppInfoModel>>> myAuthAppList() {
    return HttpService.to.http.get<List<OauthAppInfoModel>>(ApiUrls.myAuthAppList);
  }
}
