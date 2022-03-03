import 'package:flutter_ucore/apis/api_urls.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/services/http_service.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

import 'interceptor.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authService = AuthService.to;
    final Map<String, dynamic> headers = checkNoAuthToken(options.headers);

    /// 只有登录状态, 才需要传入Token
    if (authService.isLoggedInValue) {
      /// 处理 token 过期
      final expireTime = authService.userModel?.expireTime;

      /// 如果过期时间小于60s, 则调用 refreshToken 续期接口
      if (expireTime == null || expireTime <= DateTime.now().millisecondsSinceEpoch ~/ 1000 + 60) {
        HttpService.service.http.dio.interceptors.requestLock.lock();
        final tokenDio = Dio();
        tokenDio.interceptors.addAll([
          RequestHeaderInterceptor(),
          RequestSignInterceptor(),
        ]);
        tokenDio
            .get('${ApiUrls.authRefreshToken}/${authService.refreshToken}',
                options: Options(headers: {'x-auth-token': authService.accessToken}))
            .then((response) async {
          final data = response.data;
          final code = data == null ? null : data['code'];
          if (code != 0) {
            await authService.logout();
          } else {
            final token = data['data']['token'];
            final refreshToken = data['data']['refreshToken'];
            final expireTime = data['data']['expireTime'];
            if (token != null && refreshToken != null && expireTime != null) {
              /// 写入 sp
              await authService.updateToken(token, refreshToken, expireTime);
              options.headers['x-auth-token'] = token;
            } else {
              await authService.logout();
            }
          }
          handler.next(options);
        }).catchError((error, stackTrace) {
          handler.reject(error, stackTrace);
        }).whenComplete(() => HttpService.service.http.dio.interceptors.requestLock.unlock());
      } else {
        /// 添加 accessToken 到 request header
        final accessToken = authService.accessToken;
        if (accessToken != null) {
          headers['x-auth-token'] = accessToken;
        }

        options.headers = headers;
      }
    }

    super.onRequest(options, handler);
  }

  Map<String, dynamic> checkNoAuthToken(Map<String, dynamic> headers) {
    if (headers['x-auth-token'] == 'noAuth') {
      headers.remove('x-auth-token');
    }
    return headers;
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    String content = '';
    int? dataCode = 0;
    if (response.data is Map) {
      dataCode = response.data['code'];
    } else {
      content = response.data.toString();
    }

    final authService = AuthService.to;

    if (response.statusCode == 401 || dataCode == 401 || content.contains('\"code\":401')) {
      /// 清除用户信息
      await authService.logout();

      /// 跳转到登录页面
      if (Get.currentRoute != Routes.USER_LOGIN) {
        Get.toNamed(Routes.USER_LOGIN);
      }

      /// 因为有些接口的401定义在body中, status code: 200
      /// 所以需要更改下状态401
      final Response resp = response;
      resp.statusCode = 401;

      final DioError error =
          DioError(requestOptions: response.requestOptions, response: resp, type: DioErrorType.response);
      handler.reject(error);
    }
    super.onResponse(response, handler);
  }
}
