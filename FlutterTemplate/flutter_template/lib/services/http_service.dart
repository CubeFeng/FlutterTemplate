import 'dart:io';

import 'package:flutter_template/apis/transformer/data_transformer.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

import '../apis/interceptor/exception_interceptor.dart';
import '../apis/interceptor/request_header_interceptor.dart';

class HttpService extends GetxService {
  static HttpService get service => Get.find();
  HttpClient _httpClient = HttpClient();

  HttpClient get http => _httpClient;

  @override
  void onInit() async {
    super.onInit();

    /// 此处设置代理
    /// ⚠️ 设置完代理会自动持久化
    if (kDebugMode) {
      // ApiProxy.setProxy('192.168.5.37', 8888);
      // ApiProxy.setProxy('192.168.1.39', 20005);
      // ApiProxy.resetProxy();
    }

    /// 自定义代理
    ApiProxy.fkHttpOverrides = _HttpOverrides();

    /// 加入自定义拦截器
    _httpClient.addInterceptors([
      LoggyDioInterceptor(requestHeader: true, requestBody: true, responseBody: true),
      RequestErrorInterceptor(),
      RequestHeaderInterceptor()
    ]);

    /// 设置数据解析器
    _httpClient.setObjectTransformer(ApiDataTransformer());

    /// 设置cookie管理器
    Directory tempDir = await getTemporaryDirectory();
    final _cookieJar = PersistCookieJar(storage: FileStorage(tempDir.path));
    _httpClient.addInterceptors([CookieManager(_cookieJar)]);
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