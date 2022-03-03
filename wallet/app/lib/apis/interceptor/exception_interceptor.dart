import 'package:dio/dio.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/routes/app_pages.dart';

class RequestErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    if (Get.currentRoute == Routes.HOME ||
        Get.currentRoute == Routes.TRANSACTION_LIST) {
      Get.showTopBanner(I18nKeys.unableconnectserver,
          style: TopBannerStyle.Default);
    } else {
      Get.showTopBanner(I18nKeys.unableconnectserver);
    }
  }
}
