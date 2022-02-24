import 'package:flutter_template/models/app_info_model.dart';
import 'package:flutter_template/services/app_service.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

class RequestHeaderInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    /// 只处理移动端
    if (DeviceUtils.isMobile) {
      final Map<String, dynamic> headers = options.headers;

      final AppService appService = Get.find<AppService>();
      final AppInfoModel? appInfo = await appService.info;

      /// platform 平台（ios,android)

      headers['platform'] = DeviceUtils.isAndroid ? 'Android' : 'iOS';

      /// app_version app版本号
      headers['a_v'] = appInfo?.version;

      /// build_num 编译版本号
      headers['b_v'] = appInfo?.buildVersion;

      /// package_name 包名
      headers['p_n'] = appInfo?.packageName;

      /// channel_type 渠道类型
      headers['c_t'] = appInfo?.channelType;

      /// channel_name 渠道名称
      headers['c_n'] = appInfo?.channelName;

      /// channel_version 渠道版本号
      headers['c_v'] = appInfo?.channelVersion;

      /// device_no 设备号
      headers['dn'] = appInfo?.deviceId ?? '';

      headers['X-Request-Id'] = RandomUtils.uniqueString();

      /// 处理语言 & sourceType
      // final String localsValue = SpUtil.getString('locale') ?? 'zh_TW';

      // headers['langCode'] = AppLanguage.getInterceptLanguage(localsValue);

      options.headers = headers;
    }
    super.onRequest(options, handler);
  }
}
