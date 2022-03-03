import 'dart:convert';

import 'package:flutter_ucore/database/entity/message_entity.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/widgets/webview_progress.dart';
import 'package:flutter_ucore/widgets/widget_builder_plus.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MessageDetailPage extends StatelessWidget {
  MessageDetailPage({Key? key}) : super(key: key);

  String _renderHtml(html) {
    String _html = '''
          <html>
            <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
            </head>
            <body onload="SendHight()">
              ${html}
              <script type="text/javascript">window.extents.postMessage(document.body.offsetHeight);</script>
            </body>
        </html>
    ''';
    String _S = "data:text/html;charset=utf-8;base64,${base64Encode(const Utf8Encoder().convert(_html))}";
    return _S;
  }

  final webViewLoadFinish = false.obs;

  final loadProgress = 0.2.obs;

  @override
  Widget build(BuildContext context) {
    if (DeviceUtils.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    MessageContent messageContent = Get.arguments;
    return Scaffold(
      appBar: UCoreAppBar(
        action: IconButton(
            onPressed: () {
              Get.until((dynamic route) {
                return route.settings.name == Routes.HOME;
              });
            },
            icon: LoadAssetImage('drawer/icon_back_home')),
        title: Text(messageContent.title),
        bottom: WebViewProgress(loadProgress: loadProgress),
      ),
      body: SafeArea(
          child: WidgetBuilderPlus(
        builder: (_) {
          return WebView(
            initialUrl: _renderHtml(messageContent.content),
            javascriptMode: JavascriptMode.unrestricted,
            onProgress: (progress) => loadProgress.value = progress / 100,
            onWebViewCreated: (controller) async {},
            onPageStarted: (_) => webViewLoadFinish.value = true,
            javascriptChannels: <JavascriptChannel>[
              // _SetHtmlHeight(context)
            ].toSet(),
          );
        },
        canCreate: webViewLoadFinish,
      )),
    );
  }
}
