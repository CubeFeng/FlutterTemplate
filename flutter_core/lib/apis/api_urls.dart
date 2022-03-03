import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/common/app_env.dart';
import 'package:flutter_base_kit/common/constant.dart';

import 'api_host_model.dart';

class ApiUrls {
  /// 是否是生产环境
  /// [isProduction] 只针对于API Host
  static const bool isProduction = false;

  /// apiHost
  static late ApiHostModel _apiHost;

  static ApiHostModel get apiHost => _apiHost;

  static Future<void> initApiUrls() async {
    /// 获取当前的apiHost环境
    final AppEnvironments env = AppEnv.currentEnv();

    /// 加载资源文件
    final String jsonString = await rootBundle.loadString('assets/config/api.config.json');
    final dynamic jsonObj = json.decode(jsonString);
    switch (env) {
      case AppEnvironments.dev:
        _apiHost = ApiHostModel().fromJson(jsonObj['dev'] as Map<String, dynamic>);
        break;
      case AppEnvironments.test:
        _apiHost = ApiHostModel().fromJson(jsonObj['test'] as Map<String, dynamic>);
        break;
      case AppEnvironments.pre:
        _apiHost = ApiHostModel().fromJson(jsonObj['pre'] as Map<String, dynamic>);
        break;
      case AppEnvironments.prod:
        _apiHost = ApiHostModel().fromJson(jsonObj['prod'] as Map<String, dynamic>);
        break;
      case AppEnvironments.custom:

        /// 如果是自定义环境, 那么先判断是否有在app内进行设置
        final customApiUrlConfigObj = SpUtil.getObject(Constant.customApiUrlConfigCacheKey);
        if (customApiUrlConfigObj != null) {
          _apiHost = ApiHostModel().fromJson(customApiUrlConfigObj as Map<String, dynamic>);
        } else {
          _apiHost = ApiHostModel().fromJson(jsonObj['custom'] as Map<String, dynamic>);
        }
        break;
    }
  }

  static String get testApihost => _apiHost.apiHost + '/home';

  /// ========================== OAuth2 ======================================
  static String get oauth2Url => _apiHost.apiHost + "/advisory-oauth/oauth2/authorize";

  static String get oauth2RedirectUrl => _apiHost.apiHost + "/advisory-oauth/oauth2/code";

  /// ========================== 用户资讯 ======================================
  /// 查询用户阅读数和订阅数
  static String get newsQueryUserRssAdvisoryNum =>
      _apiHost.apiHost + '/api/advisory/v1/userApp/QueryUserRssAdvisoryNum';

  /// 资讯列表分页
  static String get newsQueryAdvisoryList => _apiHost.apiHost + '/api/advisory/v1/userApp/queryAdvisoryList';

  /// 查询阅读历史列表分页
  static String get newsQueryRecordUserReadHistory =>
      _apiHost.apiHost + '/api/advisory/v1/userApp/queryRecordUserReadHistory';

  /// 订阅源下的资讯列表分页
  static String get newsQueryRssAdvisoryList => _apiHost.apiHost + '/api/advisory/v1/userApp/queryRssAdvisoryList';

  /// 查询所有订阅源
  static String get newsQueryRssList => _apiHost.apiHost + '/api/advisory/v1/userApp/queryRssList';

  /// 查询当前用户的所有订阅源
  static String get newsQueryRssListCurrent => _apiHost.apiHost + '/api/advisory/v1/userApp/queryRssListCurrent';

  /// 查询所有分类名称
  static String get newsQueryAllCategory => _apiHost.apiHost + '/api/advisory/v1/userApp/qyeryAllCategory';

  /// 记录用户阅读历史
  static String get newsRecordUserReadHistory => _apiHost.apiHost + '/api/advisory/v1/userApp/recordUserReadHistory';

  /// 登录同步用户订阅
  static String get newsRecordUserRssSource => _apiHost.apiHost + '/api/advisory/v1/userApp/recordUserRssSource';

  /// 订阅资讯，取消订阅，重新订阅
  static String get newsTopicRss => _apiHost.apiHost + '/api/advisory/v1/userApp/topicRss';

  /// 资讯异常反馈
  static String get newsUserAdvisoryFeedback => _apiHost.apiHost + '/api/advisory/v1/userApp/userAdvisoryFeedback';

  /// ========================== Auth ======================================
  /// 用户登录
  static String get authUserLogin => _apiHost.apiHost + '/api/advisory/v1/user/login';

  /// 刷新Token
  static String get authRefreshToken => _apiHost.apiHost + '/api/advisory/v1/user/refresh';

  /// 上传图片
  static String get rssFileUpload => _apiHost.apiHost + '/api/advisory/v1/rss/file/upload';

  /// 照片/视频文件上传
  static String get rssFileUploadImg => _apiHost.apiHost + '/api/advisory/v1/rss/file/upload/img';

  /// 绑定用户人脸信息
  static String get userFaceAdd => _apiHost.apiHost + '/api/advisory/v1/userFace/face/add';

  /// 查找人脸是否存在
  static String get userFaceSearch => _apiHost.apiHost + '/api/advisory/v1/userFace/face/search';

  /// 提交实名认证
  static String get userAuthAddUserAuth => _apiHost.apiHost + '/api/advisory/v1/user/auth/addUserAuth';

  /// 网易滑动式校验码验证
  static String get userAuthInfoCheckNetEase => _apiHost.apiHost + '/api/advisory/v1/user/auth/info/checkNetEase';

  /// 我的授权列表
  static String get myAuthAppList => _apiHost.apiHost + '/advisory-oauth/oauth2/myAuthAppList';

  /// 检查最新版本
  static String get checkVersion => _apiHost.apiHost + '/api/advisory/v1/suggest/checkVersion/';

  /// 提交建议
  static String get suggestSubmit => _apiHost.apiHost + '/api/advisory/v1/suggest/submit';

  /// 用户人脸注册
  static String get userFaceRegister => _apiHost.apiHost + '/api/advisory/v1/user/face/register';

  /// 找回密码
  static String get userFindUserPwd => _apiHost.apiHost + '/api/advisory/v1/user/findUserPwd';

  /// 用户登出
  static String get userLoginOut => _apiHost.apiHost + '/api/advisory/v1/user/loginOut';

  /// 查询用户绑定信息
  static String get userQueryUserBand => _apiHost.apiHost + '/api/advisory/v1/user/queryUserBand';

  /// 用户邮箱注册
  static String get userRegister => _apiHost.apiHost + '/api/advisory/v1/user/register';

  /// 邮箱验证码
  static String get userRegisterCaptchaEmail => _apiHost.apiHost + '/api/advisory/v1/user/register/captchaEmail';

  /// 登录修改密码
  static String get userResetUserPwd => _apiHost.apiHost + '/api/advisory/v1/user/resetUserPwd';

  /// 绑定用户信息
  static String get userSaveUserBand => _apiHost.apiHost + '/api/advisory/v1/user/saveUserBand';

  /// 修改用户信息
  static String get userUpdateUserInfo => _apiHost.apiHost + '/api/advisory/v1/user/updateUserInfo';

  /// 获取应用信息（用于站内信）
  static String get getAppInfo => _apiHost.apiHost + '/advisory-oauth/getappinfo';

  /// 帮助中心URL
  static String get helpCenterUrl => _apiHost.helpHost + '/';
}
