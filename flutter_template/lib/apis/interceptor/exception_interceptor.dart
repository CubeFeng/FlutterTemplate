import 'package:dio/dio.dart';
import 'package:flutter_base_kit/widgets/toast.dart';

class RequestErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    Toast.showError(err.message);
  }
}