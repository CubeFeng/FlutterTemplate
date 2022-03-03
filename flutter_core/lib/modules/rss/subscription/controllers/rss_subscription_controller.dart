import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/news_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/models/news/news_model.dart';
import 'package:flutter_ucore/models/news/rss_model.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_plus.dart';
// import 'package:get/get.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class RssSubscriptionController extends GetxController {
  late Rx<RssModel?> _rss;
  final newsList = <NewsItemModel>[];

  late UCoreListViewPlusController listViewController;
  late UCoreListViewScrollCallback onWatchListViewScroll;
  int _page = 1;
  final int _pageSize = 20;

  // 顶栏透明度
  final topTarAlpha = 0.obs;

  RssModel? get rss => _rss.value;

  @override
  void onInit() {
    super.onInit();
    _rss = Rx<RssModel?>(Get.arguments as RssModel?);
    listViewController = UCoreListViewPlusController(
      initialRefresh: true,
      initialRefreshStatus: RefreshStatus.refreshing,
    );
    onWatchListViewScroll = (notification, position) {
      if (notification is ScrollUpdateNotification) {
        final offset = position.pixels.toInt();
        if (offset < 0) {
          topTarAlpha.value = 0;
        } else {
          topTarAlpha.value = math.min(offset, 255);
        }
      }
    };
  }

  @override
  void onClose() {
    listViewController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async {
    final response = await NewsApi.queryRssAdvisoryList(
      page: 1,
      pageSize: _pageSize,
      rssId: rss?.rssId,
    );
    if (response.code == 0) {
      final records = response.data?.result?.records ?? [];
      newsList.clear();
      newsList.addAll(records);
      _page = 2;
      listViewController.refreshCompleted(resetFooterState: true);
      if (records.length < _pageSize) {
        listViewController.loadNoData();
      }
    } else {
      listViewController.refreshFailed();
    }
    update();
  }

  Future<void> onLoading() async {
    final response = await NewsApi.queryRssAdvisoryList(
      page: _page,
      pageSize: _pageSize,
      rssId: rss?.rssId,
    );
    if (response.code == 0) {
      final records = response.data?.result?.records ?? [];
      newsList.addAll(records);
      _page++;
      listViewController.loadComplete();
      if (records.length < _pageSize) {
        listViewController.loadNoData();
      }
    } else {
      listViewController.loadFailed();
    }
    update();
  }

  /// 移除指定ID的资讯
  void removeNewsById(int newsId) {
    newsList.removeWhere((it) => it.id == newsId);
    update();
  }

  /// 同步本地订阅状态
  void syncLocalSubscribeStatus() {
    final rssId = rss?.rssId ?? 0;
    _rss.update((val) => val?.isSubscribe =
        LocalService.to.subscribedRssIds.contains(rssId) ? 1 : 0);
  }

  /// 切换订阅状态
  Future<void> toggleSubscribeState() async {
    final rssId = rss?.rssId ?? 0;
    final isSubscribed = rss?.isSubscribe == 1;
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
    _rss.update((val) => val?.isSubscribe = isSubscribed ? 0 : 1);
  }
}
