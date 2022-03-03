import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/news_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/models/news/category_model.dart';
import 'package:flutter_ucore/models/news/rss_model.dart';
import 'package:flutter_ucore/modules/rss/center/controllers/rss_center_controller.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_plus.dart';
import 'package:flutter_ucore/widgets/ucore_rss_list_item_widget.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class RssCenterTabPageView extends StatefulWidget {
  final int index;
  final CategoryModel category;

  const RssCenterTabPageView(
      {Key? key, required this.index, required this.category})
      : super(key: key);

  @override
  _RssCenterTabPageViewState createState() => _RssCenterTabPageViewState();
}

class _RssCenterTabPageViewState extends State<RssCenterTabPageView>
    with AutomaticKeepAliveClientMixin<RssCenterTabPageView> {
  RssCenterController get controller => Get.find();

  StreamSubscription? _sub;
  int _page = 1;
  final int _pageSize = 20;
  final List<RssModel> _records = [];
  final _listController = UCoreListViewPlusController(
    initialRefresh: true,
    initialRefreshStatus: RefreshStatus.refreshing,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _sub = Get.find<RssCenterController>()
        .tabIndexObservable
        .listen((event) async {
      if (event == widget.index) {
        setState(() {});
      }
      // 已订阅,每次打开都需要检查订阅数据是否有变化,如果有变化则需要刷新数据
      _checkNeedRefresh();
    });
  }

  void _checkNeedRefresh() {
    if (widget.index == 1) {
      final memory_ids = _records.map((e) => e.rssId).filterNotNull().sorted();
      final local_ids = LocalService.to.subscribedRssIds.sorted();
      if (!memory_ids.containsAll(local_ids) ||
          local_ids.length != memory_ids.length) {
        _listController.requestRefresh();
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scrollbar(
      child: UCoreListViewPlus(
        controller: _listController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        enableRefresh: true,
        enableLoadMore: !_records.isEmpty,
        itemBuilder: (context, index) {
          final rss = _records[index];
          rss.isSubscribe =
              LocalService.to.subscribedRssIds.contains(rss.rssId) ? 1 : 0;
          return UCoreRssListItemWidget(
            item: rss,
            onItemTap: () async {
              await Get.toNamed(Routes.RSS_SUBSCRIPTION, arguments: rss);
              _checkNeedRefresh();
            },
            onButtonTap: () async => await _toggleSubscribeState(rss),
          );
        },
        separatorBuilder: (context, index) =>
            Divider(indent: 16, endIndent: 16),
        itemCount: _records.length,
      ),
    );
  }

  Future<void> _onRefresh() async {
    final response = await controller.getRssList(
      category: widget.category,
      page: 1,
      pageSize: _pageSize,
    );
    setState(() {
      if (response.code == 0) {
        final records = response.data?.records ?? [];
        this._records.clear();
        this._records.addAll(records);
        _page = 2;
        _listController.refreshCompleted(resetFooterState: true);
        if (records.length < _pageSize) {
          _listController.loadNoData();
        }
      } else {
        _listController.refreshFailed();
      }
    });
  }

  Future<void> _onLoading() async {
    final response = await controller.getRssList(
      category: widget.category,
      page: _page,
      pageSize: _pageSize,
    );
    setState(() {
      if (response.code == 0) {
        final records = response.data?.records ?? [];
        this._records.addAll(records);
        _page++;
        _listController.loadComplete();
        if (records.length < _pageSize) {
          _listController.loadNoData();
        }
      } else {
        _listController.loadFailed();
      }
    });
  }

  /// 切换订阅状态
  Future<void> _toggleSubscribeState(RssModel rss) async {
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
      Toast.showSuccess(I18nKeys.unsubscribe_successfully);
      // 已订阅Tab,取消订阅需要在列表中移除
      if (widget.index == 1) {
        _records.remove(rss);
      }
    } else {
      // 订阅
      LocalService.to.subscribeRss(id: rssId);
      Toast.showSuccess(I18nKeys.subscribe_successfully);
    }
    setState(() => rss.isSubscribe = isSubscribed ? 0 : 1);
  }
}
