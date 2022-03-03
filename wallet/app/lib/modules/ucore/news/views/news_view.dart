import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_base_kit/widgets/widget_builder_plus.dart';
import 'package:flutter_wallet/modules/ucore/news/controllers/news_controller.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';

import 'package:webview_flutter/webview_flutter.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DeviceUtils.isAndroid) {
      WebView.platform = null; //SurfaceAndroidWebView();
    }
    return Scaffold(
      appBar: QiAppBar(
        title: Text(controller.news?.rssName ?? ""),
        action: Obx(() => _buildSubscribeButton()),
        // bottom: WebViewProgress(loadProgress: controller.loadProgress),
      ),
      body: Column(
        children: [
          Expanded(
            child: WidgetBuilderPlus(
              canCreate: controller.webViewLoadFinish,
              builder: (_) {
                return GestureDetector(
                  child: WebView(
                      onPageFinished: controller.onPageFinished,
                      onWebViewCreated: controller.onWebViewCreated,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: controller.news?.sourceUrl ?? "",
                      onProgress: (progress) => controller.loadProgress.value = progress / 100,
                      onPageStarted: (_) => controller.webViewLoadFinish.value = true,
                      gestureRecognizers: Set()
                        ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()))
                        ..add(Factory(() => LongPressGestureRecognizer()
                          ..onLongPressStart = (LongPressStartDetails details) async {
                            final x = details.localPosition.dx;
                            final y = details.localPosition.dy;
                            await controller.handleImage(x, y);
                          }))),
                  onLongPressEnd: (LongPressEndDetails details) {},
                );
              },
            ),
          ),
          Divider(),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton() {
    const isSubscribed = true;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: TextButton(
        style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
        onPressed: () {

        },
        child: isSubscribed
            ? const Text(
                "退订主题",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF999999),
                ),
              )
            : const Text(
                "订阅主题",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFFF9544),
                ),
              ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SizedBox(
      height: 66,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 34),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              // onTap: () => _doShowFeedbackModal(context),
              child: LoadAssetImage("news/icon_news_report"),
            ),
            // 暂时屏蔽点赞功能
            Visibility(visible: false, child: _buildLikeButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildLikeButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        LoadAssetImage("news/icon_news_like"),
        SizedBox(width: 5),
        Text(
          "520",
          style: TextStyle(fontSize: 13, color: Color(0xFF474544)),
        ),
      ],
    );
  }

}
