import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/news_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/models/news/rss_model.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_plus.dart';
// import 'package:get/get.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class MySubscriptionsController extends GetxController {
  static const RSS_LIST_ID = 0x01;

  late UCoreListViewPlusController listViewController;

  /// 订阅源列表
  final rssList = <RssModel>[];
  int _page = 1;
  final int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    listViewController = UCoreListViewPlusController(
      initialRefresh: true,
      initialRefreshStatus: RefreshStatus.refreshing,
    );
  }

  @override
  void onClose() {
    listViewController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async {
    final response = await NewsApi.queryRssListCurrent(
      page: 1,
      pageSize: _pageSize,
      rssIds: LocalService.to.subscribedRssIds,
    );
    if (response.code == 0) {
      final records = response.data?.records ?? [];
      rssList.clear();
      rssList.addAll(records);
      _page = 2;
      listViewController.refreshCompleted(resetFooterState: true);
      if (records.length < _pageSize) {
        listViewController.loadNoData();
      }
    } else {
      listViewController.refreshFailed();
    }
    update([RSS_LIST_ID]);
  }

  Future<void> onLoading() async {
    final response = await NewsApi.queryRssListCurrent(
        page: _page,
        pageSize: _pageSize,
        rssIds: LocalService.to.subscribedRssIds);
    if (response.code == 0) {
      final records = response.data?.records ?? [];
      rssList.addAll(records);
      _page++;
      listViewController.loadComplete();
      if (records.length < _pageSize) {
        listViewController.loadNoData();
      }
    } else {
      listViewController.loadFailed();
    }
    update([RSS_LIST_ID]);
  }

  void requestUpdateList() {
    rssList.removeWhere((it) => it.isSubscribe != 1);
    update([RSS_LIST_ID]);
  }

  /// 切换订阅状态
  Future<void> toggleSubscribeState(RssModel rss) async {
    final rssId = rss.rssId ?? 0;
    final isSubscribed = rss.isSubscribe == 1;
    if (AuthService.to.isLoggedInValue) {
      Toast.showLoading();
      await NewsApi.topicRss(rssId: rssId, isSubscribe: isSubscribed ? 0 : 1);
      Toast.hideLoading();
    }
    if (isSubscribed) {
      // 退订
      LocalService.to.unsubscribeRss(id: rssId);
      rssList.removeWhere((it) => it.rssId == rssId);
      Toast.showSuccess(I18nKeys.unsubscribe_successfully);
    } else {
      // 订阅
      LocalService.to.subscribeRss(id: rssId);
      Toast.showSuccess(I18nKeys.subscribe_successfully);
    }
    rss.isSubscribe = isSubscribed ? 0 : 1;
    update([RSS_LIST_ID]);
  }
}
