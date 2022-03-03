import 'package:fk_photos/fk_photos.dart';
import 'package:flutter/services.dart';
import 'package:flutter_action_sheet/flutter_action_sheet.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/news_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/models/news/news_model.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/services/local_service.dart';
// import 'package:get/get.dart';
import 'package:r_scan/r_scan.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:dartx/dartx.dart';

class NewsController extends GetxController {
  WebViewController? webViewController;
  late Rx<NewsItemModel?> _news;

  NewsItemModel? get news => _news.value;

  final loadProgress = 0.2.obs;

  final webViewLoadFinish = false.obs;

  @override
  void onInit() async {
    super.onInit();
    _news = Rx(Get.arguments as NewsItemModel?);
    if (news?.id != null) {
      await recordReadHistory(advisoryId: news!.id!);
    }
  }

  /// 异常反馈
  Future<bool> feedback({required int advisoryId, required int type}) async {
    final response =
        await NewsApi.userAdvisoryFeedback(advisoryId: advisoryId, type: type);
    if (response.code == 0 && response.data == true) {
      return true;
    }
    return false;
  }

  /// 记录阅读历史
  Future<bool> recordReadHistory({required int advisoryId}) async {
    final response =
        await NewsApi.recordUserReadHistory(advisoryId: advisoryId);
    if (response.code == 0 && response.data == true) {
      return true;
    }
    return false;
  }

  /// 切换订阅状态
  Future<void> toggleSubscribeState() async {
    final rssId = news?.sourceId ?? 0;
    final isSubscribed = LocalService.to.subscribedRssIds.contains(rssId) ||
        news?.isSubscribe == 1;
    if (AuthService.to.isLoggedInValue) {
      Toast.showLoading();
      await NewsApi.topicRss(rssId: rssId, isSubscribe: isSubscribed ? 0 : 1);
      Toast.hideLoading();
    }
    if (isSubscribed) {
      // 退订
      LocalService.to.unsubscribeRss(id: rssId);
      Toast.showSuccess(I18nKeys.unsubscribe_successfully);
    } else {
      // 订阅
      LocalService.to.subscribeRss(id: rssId);
      Toast.showSuccess(I18nKeys.subscribe_successfully);
    }
    _news.update((val) => val?.isSubscribe = isSubscribed ? 0 : 1);
  }

  void onWebViewCreated(WebViewController controller) {
    webViewController = controller;
  }

  void onPageFinished(String js) {
    webViewController?.evaluateJavascript(
        "document.documentElement.style.webkitTouchCallout = 'none';");
  }

  Future<void> handleImage(double x, double y) async {
    String? url = await webViewController
        ?.evaluateJavascript('document.elementFromPoint($x, $y).src');
    url = url?.replaceAll('"', '').replaceAll('null', '');

    if (url.isNullOrEmpty) {
      return;
    }
    final result = await RScan.scanImageUrl(url!);
    if (result.message.isNotNullOrEmpty) {}
    showActionSheet(
      context: Get.context!,
      enableDrag: false,
      actionSheetBar: ActionSheetBar('', showAction: false),
      actions: [
        ActionSheetItem(I18nKeys.save_to_album, onPress: () async {
          Get.back();
          await FKPhotos.saveToAlbum(url: url);
        }),
        if (result.message.isNotNullOrEmpty) ...{
          ActionSheetItem(I18nKeys.recognition_qrcode, onPress: () async {
            Get.back();
            if (await canLaunch(result.message!)) {
              launch(result.message!, forceSafariVC: false);
            } else {
              await Clipboard.setData(ClipboardData(text: result.message));
              Toast.showSuccess(I18nKeys.copy_to_clipboard);
            }
          }),
        }
      ],
      bottomAction: BottomCancelActon(I18nKeys.cancel),
    );
  }
}
