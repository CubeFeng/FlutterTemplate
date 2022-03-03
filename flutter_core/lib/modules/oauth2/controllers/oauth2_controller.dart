import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/api_urls.dart';
import 'package:flutter_ucore/modules/oauth2/models/oauth2_model.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/services/config_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OAuth2Controller extends GetxController with WidgetsBindingObserver {
  late Completer<WebViewController> webViewController;

  late final OAuth2Model model;

  final loadProgress = 0.2.obs;

  final webViewLoadFinish = false.obs;

  String? get _accessToken => AuthService.to.accessToken;

  @override
  void onInit() {
    super.onInit();
    model = Get.arguments as OAuth2Model;
    webViewController = Completer();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused && Get.currentRoute.startsWith(Routes.OAUTH2)) {
      cancelAuthorization();
    }
  }

  @override
  void onReady() async {
    super.onReady();
    if (_accessToken == null) {
      await Get.toNamed(Routes.USER_LOGIN);
    }
    if (_accessToken == null) {
      goBack();
    } else {
      final controller = await webViewController.future;
      final _oauth2Url = ApiUrls.oauth2Url +
          "?client_id=${model.appId}" +
          "&response_type=code" +
          "&state=${model.state}" +
          "&x-auth-token=$_accessToken" +
          "&appName=(null)" +
          "&redirect_uri=${ApiUrls.oauth2RedirectUrl}" +
          "&language=${model.language}";
      logger.d("oauth2Url: $_oauth2Url");
      controller.loadUrl(_oauth2Url);
    }
  }

  Set<JavascriptChannel> get javascriptChannels => <JavascriptChannel>[
        JavascriptChannel(name: "authorizationHook", onMessageReceived: _handleAuthorizationResult),
        JavascriptChannel(name: "authorizationCancelHook", onMessageReceived: _handleAuthorizationCancelResult)
      ].toSet();

  void _handleAuthorizationResult(JavascriptMessage message) {
    final params = convert.jsonDecode(message.message);
    final result = {};
    if (params is Map<String, dynamic>) {
      final code = params["code"];
      if (code != null && model.state == params["state"]) {
        result["data"] = code;
        result["msgCode"] = "0";
        result["state"] = model.state;
      } else {
        result["data"] = "1";
        result["msgCode"] = "1";
      }
    } else {
      result["data"] = "1";
      result["msgCode"] = "1";
    }
    goBack();
    _backToThirdApp(result);
  }

  void _handleAuthorizationCancelResult(JavascriptMessage message) => cancelAuthorization();

  void goBack() {
    WidgetsBinding.instance?.removeObserver(this);
    Get.back();
  }

  void cancelAuthorization() {
    final result = {"data": "2", "msgCode": "2"};
    goBack();
    _backToThirdApp(result);
  }

  Future<void> _backToThirdApp(Map result) async {
    logger.d("_backToThirdApp.result=$result");
    final appBackJson = convert.jsonEncode(result);
    final appBack = EncryptUtils.aesEncrypt(appBackJson, ConfigService.to.oauth2Key);
    final url = model.urlSchemes.contains("://")
        ? "${model.urlSchemes}?Appback=$appBack"
        : "${model.urlSchemes}://?Appback=$appBack";
    logger.d("launch url=$url");
    final isCanLaunch = await canLaunch(url);
    logger.d("isCanLaunch=$isCanLaunch");
    launch(url).then((value) => logger.d("launch.result=$value")).catchError((err) => logger.d("launch.err=$err"));
  }

  void injectHookJavaScript() async {
    final ctl = await webViewController.future;
    ctl.evaluateJavascript("""
          window.webkit = {
            messageHandlers: {
              authorization: {
                postMessage: function(event) {
                  authorizationHook.postMessage(event)
                }
              },
              authorizationCancel: {
                postMessage: function(event) {
                  authorizationCancelHook.postMessage(event)
                }
              }
            }
          }
          window.authorization = {
            commonHandler: function(event) {
              authorizationHook.postMessage(event)
            }
          }
          window.authorizationCancel = {
            commonHandler: function(event) {
              authorizationCancelHook.postMessage(event)
            }
          }
          """);
  }
}
