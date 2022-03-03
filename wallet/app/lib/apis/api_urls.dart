import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter_base_kit/common/app_env.dart';
import 'package:flutter_base_kit/common/constant.dart';
import 'package:flutter_wallet/generated/json_partner/json_partner.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

import 'api_host_model.dart';

class ApiUrls {
  /// 是否是生产环境
  /// [isProduction] 只针对于API Host
  static const bool isProduction = false;

  /// apiHost
  static late ApiHostModel _apiHost;

  static ApiHostModel get apiHost => _apiHost;

  static set(host) {
    _apiHost.apiHost = host;
  }

  static Future<void> initApiUrls() async {
    /// 获取当前的apiHost环境
    final AppEnvironments env = AppEnv.currentEnv();

    /// 加载资源文件
    final String jsonString =
        await WalletAssets.loadString('assets/config/api.config.json');
    final dynamic jsonObj = json.decode(jsonString);
    switch (env) {
      case AppEnvironments.dev:
        _apiHost = JsonPartner.fromJsonAsT<ApiHostModel>(
            jsonObj['dev'] as Map<String, dynamic>);
        break;
      case AppEnvironments.test:
        _apiHost = JsonPartner.fromJsonAsT<ApiHostModel>(
            jsonObj['test'] as Map<String, dynamic>);
        break;
      case AppEnvironments.pre:
        _apiHost = JsonPartner.fromJsonAsT<ApiHostModel>(
            jsonObj['pre'] as Map<String, dynamic>);
        break;
      case AppEnvironments.prod:
        _apiHost = JsonPartner.fromJsonAsT<ApiHostModel>(
            jsonObj['prod'] as Map<String, dynamic>);
        break;
      case AppEnvironments.custom:

        /// 如果是自定义环境, 那么先判断是否有在app内进行设置
        final customApiUrlConfigObj =
            SpUtil.getObject(Constant.customApiUrlConfigCacheKey);
        if (customApiUrlConfigObj != null) {
          _apiHost = JsonPartner.fromJsonAsT<ApiHostModel>(
              customApiUrlConfigObj as Map<String, dynamic>);
        } else {
          _apiHost = JsonPartner.fromJsonAsT<ApiHostModel>(
              jsonObj['custom'] as Map<String, dynamic>);
        }
        break;
    }
  }

  static String get getVersion =>
      _apiHost.apiHost + '/api/wallet/v1/settings/v2/get/version';

  static String get getCoinRate =>
      _apiHost.apiHost + '/api/wallet/v1/third/v2/get/coinRate';

  static String get getRecord =>
      _apiHost.apiHost + '/api/wallet/v1/third/v4/get/record';

  static String get getNodes =>
      _apiHost.apiHost + '/api/wallet/v1/node/config/list';

  static String get getNftRecord =>
      _apiHost.apiHost + '/api/wallet/v1/third/get/nft/record';

  static String get getSwapBanner =>
      _apiHost.apiHost + '/api/wallet/v1/settings/v2/get/base/dapp';

  static String get getNftCollections =>
      _apiHost.apiHost + '/api/wallet/v1/third/get/nft/list';

  static String getSwapList(int id) =>
      _apiHost.apiHost + '/api/wallet/v1/settings/v2/get/base/dapp/$id';

  static String getTokenList(String chainName) =>
      _apiHost.apiHost + '/api/wallet/v1/settings/get/tokens/$chainName';

  static String get getMessageList =>
      _apiHost.apiHost + '/api/wallet/v1/wallet/mail/list';

  static String get submitAddress =>
      _apiHost.apiHost + '/api/wallet/v1/address/add';
}
