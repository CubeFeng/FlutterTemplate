import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/interceptor/interceptor.dart';
import 'package:flutter_ucore/apis/transformer/data_transformer.dart';

class HttpService extends GetxService {
  static HttpService get service => Get.find();

  static HttpService get to => Get.find();

  HttpClient _httpClient = HttpClient();

  HttpClient get http => _httpClient;

  @override
  void onInit() async {
    super.onInit();

    /// 此处设置代理
    /// ⚠️ 设置完代理会自动持久化
    if (kDebugMode) {
      // ApiProxy.setProxy('192.168.5.37', 8888);
      // ApiProxy.setProxy('192.168.1.39', 20028);
      // ApiProxy.resetProxy();
    }

    /// 自定义代理
    ApiProxy.fkHttpOverrides = _HttpOverrides();

    /// 加入自定义拦截器
    _httpClient.addInterceptors([
      RequestErrorInterceptor(),
      RequestHeaderInterceptor(),
      AuthInterceptor(),
      RequestSignInterceptor(),
      LoggyDioInterceptor(requestHeader: false, requestBody: false, responseBody: false),
    ]);

    /// 设置数据解析器
    _httpClient.setObjectTransformer(ApiDataTransformer());

    /// 设置cookie管理器
    Directory tempDir = await getTemporaryDirectory();
    final _cookieJar = PersistCookieJar(storage: FileStorage(tempDir.path));
    _httpClient.addInterceptors([CookieManager(_cookieJar)]);

    /// 处理代理
    ApiProxy.initApiProxy();
  }
}

class _HttpOverrides implements NeHttpOverrides {
  @override
  String? findProxy(Uri url) {
    if (url.toString().contains('amazonaws.com')) {
      return 'DIRECT';
    }
    return null;
  }
}
