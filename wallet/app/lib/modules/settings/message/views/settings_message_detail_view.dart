import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/models/app_message_model.dart';
import 'package:flutter_wallet/modules/settings/message/controller/settings_message_controller.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert' as convert;

class SettingsMessageDetailView extends StatelessWidget {
  SettingsMessageDetailView({Key? key}) : super(key: key);
  final SettingsMessageController _controller = Get.put(SettingsMessageController());
  String content = Get.parameters["content"] ?? "";
  String title = Get.parameters["title"] ?? "";
  String time = Get.parameters["time"] ?? "";

  // AppMessageModel model = AppMessageModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QiAppBar(title: Text(I18nKeys.mail_informationDetails)),
      body: Container(
        // color: Color(0xff5E6992).withOpacity(0.05),
        margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                title,
                maxLines: 2,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xff161A27)),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                time,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12, color: Color(0xff999999)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(child: AfterRouteAnimation(builder: (BuildContext context) {
              return SafeArea(child: _buildInWebView(content));
            }))
          ],
        ),
      ),
    );
  }

  Widget _buildInWebView(String content) {
    // print("详情  $content");
    return InAppWebView(
      // initialUrlRequest: URLRequest(
      //   url: Uri.parse(url),
      // ),
      initialData: InAppWebViewInitialData(
        data: '''
        <!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1">
    <title>Document</title>
    <style>
        img{
            max-width: 100%;
        }
        body{word-break: break-all;}
    </style>
</head>
<body>
    $content
</body>
</html>''',
        // mimeType: "",
      ),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          // clearCache: true,
          useShouldOverrideUrlLoading: true,
          javaScriptEnabled: true,
          supportZoom: false,
        ),
        // ios: IOSInAppWebViewOptions(disallowOverScroll: false),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
          mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
        ),
      ),
      // onTitleChanged: _controller.onTitleChanged,
      onLoadStop: _controller.onLoadStop,
      onLoadError: _controller.onLoadError,
    );
  }
}
