import 'package:flutter_ucore/apis/news_apis.dart';
import 'package:flutter_ucore/models/news/news_model.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_plus.dart';
import 'package:get/get.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReadHistoryController extends GetxController {
  static const NEWS_LIST_ID = 0x01;
  late UCoreListViewPlusController refreshController;

  /// 资讯列表
  final newsList = <NewsItemModel>[];
  int _page = 1;
  final int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    refreshController = UCoreListViewPlusController(
      initialRefresh: true,
      initialRefreshStatus: RefreshStatus.refreshing,
    );
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async {
    final response = await NewsApi.queryRecordUserReadHistory(
      page: 1,
      pageSize: _pageSize,
    );
    if (response.code == 0) {
      final records = response.data?.records ?? [];
      newsList.clear();
      newsList.addAll(records);
      _page = 2;
      refreshController.refreshCompleted(resetFooterState: true);
      if (records.length < _pageSize) {
        refreshController.loadNoData();
      }
    } else {
      refreshController.refreshFailed();
    }
    update([NEWS_LIST_ID]);
  }

  Future<void> onLoading() async {
    final response = await NewsApi.queryRecordUserReadHistory(
      page: _page,
      pageSize: _pageSize,
    );
    if (response.code == 0) {
      final records = response.data?.records ?? [];
      newsList.addAll(records);
      _page++;
      refreshController.loadComplete();
      if (records.length < _pageSize) {
        refreshController.loadNoData();
      }
    } else {
      refreshController.loadFailed();
    }
    update([NEWS_LIST_ID]);
  }
}
