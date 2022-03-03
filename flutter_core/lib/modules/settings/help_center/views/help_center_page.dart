import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/modules/settings/help_center/controllers/help_center_controller.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/utils/progress_toast.dart';
import 'package:flutter_ucore/widgets/widget_builder_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpCenterPage extends GetView<HelpCenterController> {
  const HelpCenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DeviceUtils.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    return Scaffold(
      body: Obx(() {
        final url = controller.url.value;
        if (url.isEmpty) {
          return Gaps.empty;
        }
        return WidgetBuilderPlus(
          canCreate: controller.webViewLoadFinish,
          builder: (_) {
            return WebView(
              initialUrl: controller.url.value,
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
    );
  }
}
