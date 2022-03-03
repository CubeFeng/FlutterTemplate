import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/services/local_service.dart';

class RequestHeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    /// 只处理移动端
    if (DeviceUtils.isMobile) {
      final Map<String, dynamic> headers = options.headers;

      // final AppInfoModel? appInfo = await AppService.service.info;

      headers['clientType'] = 'APP';

      /// platform 平台（ios,android)

      // headers['platform'] = DeviceUtils.isAndroid ? 'Android' : 'iOS';

      /// app_version app版本号
      // headers['a_v'] = appInfo?.version;

      /// build_num 编译版本号
      // headers['b_v'] = appInfo?.buildVersion;

      /// package_name 包名
      // headers['p_n'] = appInfo?.packageName;

      /// channel_type 渠道类型
      // headers['c_t'] = appInfo?.channelType;

      /// channel_name 渠道名称
      // headers['c_n'] = appInfo?.channelName;

      /// channel_version 渠道版本号
      // headers['c_v'] = appInfo?.channelVersion;

      /// device_no 设备号
      // headers['dn'] = appInfo?.deviceId ?? '';

      // headers['X-Request-Id'] = RandomUtils.uniqueString();

      /// 处理语言
      headers['language'] = LocalService.to.languageCode;
      //Get.locale.toString();

      options.headers = headers;
    }
    super.onRequest(options, handler);
  }
}
