import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';

class DappWebBannerController extends GetxController {
  /// 网页标题
  final webTitle = Get.parameters["webTitle"] ?? I18nKeys.browser;

  final actionBtn = Get.parameters["share"] ?? "";

  bool webViewCreated = false;

  /// 网页加载进度, 为了美观给 20 默认值
  final loadProgress = 0.2.obs;

  void onTitleChanged(InAppWebViewController controller, String? title) async {
    // webTitle.value = title ?? '';
    print("onTitleChanged =======");
  }

  void onProgressChanged(InAppWebViewController controller, int progress) {
    loadProgress.value = progress / 100;
  }

  void onLoadStart(InAppWebViewController controller, Uri? uri) async {}

  void onLoadStop(InAppWebViewController controller, Uri? uri) async {
    if (!webViewCreated) {
      webViewCreated = true;
      update();
    }
  }

  void onLoadError(InAppWebViewController controller, Uri? uri, int code, String message) {
    print("onLoadError =======");
  }
}
