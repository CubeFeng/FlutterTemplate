import 'dart:async';
import 'dart:convert';

import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/api_urls.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/app_service.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/services/config_service.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpCenterController extends GetxController {
  final url = ''.obs;

  late Completer<WebViewController> webViewController;

  final webViewLoadFinish = false.obs;

  @override
  void onInit() {
    super.onInit();
    webViewController = Completer();
  }

  @override
  void onReady() async {
    super.onReady();

    final args = Get.arguments;

    if (args != null && args['url'] != null) {
      url.value = args['url'];
    } else {
      StringBuffer sb = StringBuffer(ApiUrls.helpCenterUrl);
      final userModel = AuthService.to.userModel;
      final appInfo = await AppService.service.info;
      final deviceInfo = DeviceInfoPlugin();
      var phonemodel;
      var deviceVersion;
      if (DeviceUtils.isAndroid) {
        final info = await deviceInfo.androidInfo;
        phonemodel = info.model;
        deviceVersion = info.version.sdkInt ?? "";
      } else {
        final info = await deviceInfo.iosInfo;
        phonemodel = info.model;
        deviceVersion = info.systemVersion;
      }

      sb.write('?name=${Uri.encodeComponent(userModel?.nickname ?? '')}');
      sb.write('&phone=${userModel?.mobile}');
      sb.write('&email=${userModel?.email}');
      sb.write('&belong=6');
      sb.write('&size=${Get.width.toStringAsFixed(2)}*${Get.height.toStringAsFixed(2)}');
      sb.write('&device=${DeviceUtils.isAndroid ? 1 : 2}');
      sb.write('&trueName=');
      sb.write('&userSn=${userModel?.userSn}');
      sb.write('&userId=${userModel?.userId}');
      sb.write('&isAuth=${userModel?.authState}');
      sb.write('&language=${LocalService.to.languageCode}');
      sb.write('&appid=${ConfigService.service.helpAppId}');
      sb.write('&appname=Ucore');
      sb.write('&deviceversion=$deviceVersion');
      sb.write('&phonemodel=$phonemodel');
      sb.write('&visitoricon=${userModel?.headImg}');
      sb.write('&appversion=${appInfo?.version}');
      logger.i('help center url: ${sb.toString()}');
      url.value = sb.toString();
    }
  }

  Set<JavascriptChannel> get javascriptChannels {
    return <JavascriptChannel>[
      JavascriptChannel(
          name: 'backToAPPHook',
          onMessageReceived: (JavascriptMessage message) {
            Get.back();
          }),
      JavascriptChannel(
          name: 'openWindowHook',
          onMessageReceived: (JavascriptMessage message) {
            final obj = json.decode(message.message);
            // fix: 因使用 arguments 传递参数遇到urlEncode中文后, 会自动解码, 导致传递给 webview 插件后无法正常打开.
            // 所以传递参数时, 使用baseEncode
            Get.toNamed(Routes.HELP_CENTER_CHAT,
                arguments: {'url': EncryptUtils.encodeBase64(obj['openWindow']), 'refresh': obj['refresh']},
                preventDuplicates: false);
          })
    ].toSet();
  }

  void injectHookJavaScript() async {
    final ctl = await webViewController.future;
    ctl.evaluateJavascript("""
          window.webkit = {
            messageHandlers: {
              backToAPP: {
                postMessage: function(event) {
                  backToAPPHook.postMessage(event)
                }
              },
              openWindow: {
                postMessage: function(event) {
                  openWindowHook.postMessage(event)
                }
              }
            }
          }
          window.backToAPP = {
            commonHandler: function(event) {
              backToAPPHook.postMessage(event)
            }
          }
          window.openWindow = {
            commonHandler: function(event) {
              openWindowHook.postMessage(event)
            }
          }
          """);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
