import 'dart:async';
import 'dart:convert';

import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpChatController extends GetxController {
  final url = Uri().obs;

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
      url.value = Uri.parse(EncryptUtils.decodeBase64(args['url']));
    }
  }

  Set<JavascriptChannel> get javascriptChannels {
    return <JavascriptChannel>[
      JavascriptChannel(
          name: 'backToAPPHook',
          onMessageReceived: (JavascriptMessage message) async {
            // await webViewController?.evaluateJavascript('sendDisconnect();');
            Get.back();
          }),
      JavascriptChannel(
          name: 'openWindowHook',
          onMessageReceived: (JavascriptMessage message) {
            final obj = json.decode(message.message);
            Get.toNamed(Routes.HELP_CENTER_CHAT,
                arguments: {'url': obj['openWindow'], 'refresh': obj['refresh']}, preventDuplicates: false);
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
  void onClose() async {
    super.onClose();
  }
}
