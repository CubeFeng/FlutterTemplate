import 'dart:convert';

import 'package:flutter_ucore/services/config_service.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

class RequestSignInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final configService = ConfigService.service;

    final currentTimeStamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    String sign = '';

    final Map<String, dynamic> headers = options.headers;

    final signHeaderMap = {
      'appId': configService.appId,
      'appSecret': configService.appSecret,
      'timestamp': currentTimeStamp,
      'clientType': 'APP',
    };

    /// signHeader 排序后的字符串
    final headerStr = sortMapToParamStr(signHeaderMap);
    if (options.method == Method.get.value) {
      /// queryParams 排序后的字符串
      final queryStr = sortMapToValueStr(options.queryParameters);
      sign = EncryptUtils.encryptMD5('$headerStr$queryStr');
    } else {
      if (options.data is FormData) {
      } else {
        final postParams = options.data != null ? options.data as Map<String, dynamic> : <String, dynamic>{};
        sign = EncryptUtils.encryptMD5('${headerStr}${json.encode(postParams)}');
      }
    }

    /// 设置header
    headers['sign'] = sign;
    signHeaderMap.remove('appSecret');
    headers.addAll(signHeaderMap);
    super.onRequest(options, handler);
  }

  /// map 转排序后的 value&value 字符串
  String sortMapToValueStr(Map<String, dynamic> params) {
    final StringBuffer sb = StringBuffer('');
    final paramsKeys = params.keys.toList();
    paramsKeys.sort();
    paramsKeys.forEach((key) {
      sb.write('${params[key]}&');
    });
    return sb.toString().removeSuffix('&');
  }

  /// map 转排序后的 key=value 字符串
  String sortMapToParamStr(Map<String, dynamic> params) {
    final StringBuffer sb = StringBuffer('');
    final paramsKeys = params.keys.toList();
    paramsKeys.sort();
    paramsKeys.forEach((key) {
      sb.write('$key=${params[key]}&');
    });
    return sb.toString().removeSuffix('&');
  }
}
