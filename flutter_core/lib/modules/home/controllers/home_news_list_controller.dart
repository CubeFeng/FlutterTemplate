import 'dart:async';

import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/news_apis.dart';
import 'package:flutter_ucore/models/news/news_model.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_plus.dart';
import 'package:get/get.dart';

class HomeNewsListController extends GetxController {
  static const NEWS_LIST_ID = 0x01;
  late UCoreListViewPlusController listViewController;

  /// 资讯列表
  final newsList = <NewsItemModel>[];
  int _page = 1;
  final int _pageSize = 20;

  StreamSubscription? _languageSub;
  StreamSubscription? _loginSub;

  @override
  void onInit() {
    super.onInit();
    listViewController = UCoreListViewPlusController(
      initialRefresh: true,
      initialRefreshStatus: RefreshStatus.refreshing,
    );
    _languageSub = LocalService.to.languageObservable.listen((_) async {
      // 语言变化刷新列表
      newsList.clear();
      update([NEWS_LIST_ID]);
      await listViewController.requestRefresh();
    });
    _loginSub = AuthService.to.isLogin.stream.listen((event) async {
      // 登录信息变化
      await listViewController.requestRefresh();
    });
  }

  @override
  void onClose() {
    _languageSub?.cancel();
    _loginSub?.cancel();
    listViewController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async {
    final response = await NewsApi.queryAdvisoryList(
      page: 1,
      pageSize: _pageSize,
      rssIds: LocalService.to.subscribedRssIds,
    );
    if (response.code == 0) {
      final records = response.data?.records ?? [];
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
    update([NEWS_LIST_ID]);
  }

  Future<void> onLoading() async {
    final response = await NewsApi.queryAdvisoryList(
      page: _page,
      pageSize: _pageSize,
      rssIds: LocalService.to.subscribedRssIds,
    );
    if (response.code == 0) {
      final records = response.data?.records ?? [];
      newsList.addAll(records);
      _page++;
      listViewController.loadComplete();
      if (records.length < _pageSize) {
        listViewController.loadNoData();
      }
    } else {
      listViewController.loadFailed();
    }
    update([NEWS_LIST_ID]);
  }
}
