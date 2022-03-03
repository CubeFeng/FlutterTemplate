import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/modules/oauth2/controllers/oauth2_controller.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/webview_progress.dart';
import 'package:flutter_ucore/widgets/widget_builder_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OAuth2View extends GetView<OAuth2Controller> {
  const OAuth2View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DeviceUtils.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: UCoreAppBar(
          leading: IconButton(
            onPressed: () => controller.cancelAuthorization(),
            icon: LoadAssetImage(
              "common/icon_close",
              color: Get.isDarkMode ? Colors.white : null,
            ),
          ),
          bottom: WebViewProgress(loadProgress: controller.loadProgress),
        ),
        body: WidgetBuilderPlus(
            canCreate: controller.webViewLoadFinish,
            builder: (_) {
              return WebView(
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: controller.javascriptChannels,
                onWebViewCreated: (webViewController) => controller.webViewController.complete(webViewController),
                onPageStarted: (_) => controller.webViewLoadFinish.value = true,
                onPageFinished: (url) => controller.injectHookJavaScript(),
                onProgress: (progress) => controller.loadProgress.value = progress / 100,
              );
            }),
      ),
    );
  }
}
