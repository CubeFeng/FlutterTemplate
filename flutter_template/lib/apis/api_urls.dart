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
}

