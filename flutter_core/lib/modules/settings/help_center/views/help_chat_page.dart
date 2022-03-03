import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/modules/settings/help_center/controllers/help_chat_controller.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/utils/progress_toast.dart';
import 'package:flutter_ucore/widgets/widget_builder_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpChatPage extends GetView<HelpChatController> {
  const HelpChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DeviceUtils.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    return WillPopScope(
        child: Scaffold(
          body: Obx(() {
            final url = controller.url.value.toString();
            if (url.isEmpty) {
              return Gaps.empty;
            }
            return WidgetBuilderPlus(
              canCreate: controller.webViewLoadFinish,
              builder: (_) {
                return WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  javascriptChannels: controller.javascriptChannels,
                  onWebViewCreated: (ctl) => controller.webViewController.complete(ctl),
                  onPageStarted: (_) => controller.webViewLoadFinish.value = true,
                  onPageFinished: (_) async => controller.injectHookJavaScript(),
                  onProgress: ProgressToastUtils.progress,
                );
              },
            );
          }),
        ),
        onWillPop: () => Future.value(false));
  }
}
