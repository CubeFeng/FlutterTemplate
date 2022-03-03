import 'package:fk_photos/fk_photos.dart';
import 'package:flutter/services.dart';
import 'package:flutter_action_sheet/flutter_action_sheet.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/models/ucore_newsitem_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsController extends GetxController {
  WebViewController? webViewController;
  late Rx<UCNewsItemModel?> _news;

  UCNewsItemModel? get news => _news.value;

  final loadProgress = 0.2.obs;

  final webViewLoadFinish = false.obs;

  @override
  void onInit() async {
    super.onInit();
    _news = Rx(Get.arguments as UCNewsItemModel?);
    if (news?.id != null) {
      await recordReadHistory(advisoryId: news!.id!);
    }
  }

  /// 记录阅读历史
  Future<bool> recordReadHistory({required int advisoryId}) async {
    return true;
  }

  void onWebViewCreated(WebViewController controller) {
    webViewController = controller;
  }

  void onPageFinished(String js) {
    webViewController?.evaluateJavascript(
        "document.documentElement.style.webkitTouchCallout = 'none';");
  }

  Future<void> handleImage(double x, double y) async {
    return;
  }
}
