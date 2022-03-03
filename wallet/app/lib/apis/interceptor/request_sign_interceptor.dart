import 'package:flutter_base_kit/flutter_base_kit.dart';

class RequestSignInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final Map<String, dynamic> headers = options.headers;
    if (options.method != Method.get.value || true) {
      String sign = '';

      final postParams = options.data != null
          ? options.data as Map<String, dynamic>
          : <String, dynamic>{};

      /// 排序后的字符串
      final bodyStr = sortMapToParamStr(postParams);
      sign =
          EncryptUtils.encryptMD5('${bodyStr}508a802c34882c04f41ea1b1b49f02b3');

      /// 设置header
      headers['sign'] = sign;
    }
    super.onRequest(options, handler);
  }

  /// map 转排序后的 key=value 字符串
  String sortMapToParamStr(Map<String, dynamic> params) {
    final StringBuffer sb = StringBuffer('');
    final paramsKeys = params.keys.toList();
    paramsKeys.sort();
    for (var key in paramsKeys) {
      sb.write('$key=${params[key]}&');
    }
    return sb.toString();
  }
}
