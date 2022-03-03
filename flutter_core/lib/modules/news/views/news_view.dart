import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/news/controllers/news_controller.dart';
import 'package:flutter_ucore/modules/news/views/widgets/feedback_modal.dart';
import 'package:flutter_ucore/modules/news/views/widgets/feedback_result_modal.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/webview_progress.dart';
import 'package:flutter_ucore/widgets/widget_builder_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DeviceUtils.isAndroid) {
      WebView.platform = null; //SurfaceAndroidWebView();
    }
    return Scaffold(
      appBar: UCoreAppBar(
        title: Text(controller.news?.rssName ?? ""),
        action: Obx(() => _buildSubscribeButton()),
        bottom: WebViewProgress(loadProgress: controller.loadProgress),
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
    final isSubscribed =
        controller.news?.isSubscribe == 1 || LocalService.to.subscribedRssIds.contains(controller.news?.sourceId ?? 0);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: TextButton(
        style: ButtonStyle(splashFactory: NoSplash.splashFactory),
        onPressed: () => controller.toggleSubscribeState(),
        child: isSubscribed
            ? Text(
                I18nKeys.unsubscribe_theme,
                style: TextStyle(
                  fontSize: 13,
                  color: Get.isDarkMode ? Colours.dark_tertiary_text : Colours.tertiary_text,
                ),
              )
            : Text(
                I18nKeys.subscribe_theme,
                style: TextStyle(
                  fontSize: 13,
                  color: Get.isDarkMode ? Colours.dark_brand : Colours.brand,
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
              onTap: () => _doShowFeedbackModal(context),
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
      children: [
        LoadAssetImage("news/icon_news_like"),
        SizedBox(width: 5),
        Text(
          "520",
          style: TextStyle(fontSize: 13, color: Colours.secondary_text),
        ),
      ],
    );
  }

  Future<void> _doShowFeedbackModal(BuildContext context) async {
    final type = await showModalBottomSheet(
      context: context,
      builder: (context) => FeedbackModal(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    );
    if (type is int) {
      Toast.showLoading();
      final newsId = controller.news?.id ?? 0;
      final result = await controller.feedback(advisoryId: newsId, type: type);
      Toast.hideLoading();
      if (result) {
        _doShowFeedbackResultModal(context, newsId);
      }
    }
  }

  Future<void> _doShowFeedbackResultModal(BuildContext context, int newsId) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (context) => FeedbackResultModal(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    );
    if (result == true) {
      Get.back(result: newsId);
    }
  }
}
