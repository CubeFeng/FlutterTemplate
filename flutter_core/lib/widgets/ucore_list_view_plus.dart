import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/widgets/ucore_empty_view.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_footer.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

export 'package:pull_to_refresh/pull_to_refresh.dart';

typedef BoolCallback = bool Function();
typedef UCoreListViewScrollCallback<N extends Notification,
        P extends ScrollPosition>
    = Function(
  N notification,
  P position,
);

class UCoreListViewPlusController {
  final bool initialRefresh;
  RefreshStatus? initialRefreshStatus;
  LoadStatus? initialLoadStatus;

  bool get isRefresh => _state._isRefresh;

  late _UCoreListViewPlusState _state;

  UCoreListViewPlusController({
    this.initialRefresh = false,
    this.initialRefreshStatus,
    this.initialLoadStatus,
  });

  void _inject(_UCoreListViewPlusState state) {
    _state = state;
  }

  Future<void>? requestRefresh({
    bool needMove: true,
    bool needCallback: true,
    Duration duration: const Duration(milliseconds: 500),
    Curve curve: Curves.linear,
  }) {
    _state._setRefresh(true);
    return _state._refreshController.requestRefresh(
      needMove: true,
      needCallback: true,
      duration: duration,
      curve: curve,
    );
  }

  Future<void>? requestLoading({
    bool needMove: true,
    bool needCallback: true,
    Duration duration: const Duration(milliseconds: 300),
    Curve curve: Curves.linear,
  }) {
    return _state._refreshController.requestLoading(
      needMove: true,
      needCallback: true,
      duration: duration,
      curve: curve,
    );
  }

  void refreshCompleted({bool resetFooterState: false}) {
    _state._setRefresh(false);
    _state._refreshController
        .refreshCompleted(resetFooterState: resetFooterState);
  }

  void refreshFailed() {
    _state._setRefresh(false);
    _state._refreshController.refreshFailed();
  }

  void loadNoData() => _state._refreshController.loadNoData();

  void loadFailed() => _state._refreshController.loadFailed();

  void loadComplete() => _state._refreshController.loadComplete();

  void dispose() => _state._refreshController.dispose();
}

class UCoreListViewPlus extends StatefulWidget {
  final UCoreListViewPlusController controller;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final bool enableRefresh;
  final bool enableLoadMore;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final int itemCount;
  final UCoreListViewScrollCallback? onWatchListViewScroll;
  final bool requireSafeArea;

  const UCoreListViewPlus({
    Key? key,
    required this.controller,
    this.onRefresh,
    this.onLoading,
    this.enableRefresh = true,
    this.enableLoadMore = false,
    required this.itemBuilder,
    this.separatorBuilder,
    required this.itemCount,
    this.onWatchListViewScroll,
    this.requireSafeArea = true,
  }) : super(key: key);

  @override
  _UCoreListViewPlusState createState() => _UCoreListViewPlusState();
}

class _UCoreListViewPlusState extends State<UCoreListViewPlus> {
  late RefreshController _refreshController;
  ScrollController? _listViewController;
  late bool _isRefresh;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(
      initialRefresh: widget.controller.initialRefresh,
      initialRefreshStatus: widget.controller.initialRefreshStatus,
      initialLoadStatus: widget.controller.initialLoadStatus,
    );
    _isRefresh = _refreshController.initialRefresh;
    if (widget.onWatchListViewScroll != null) {
      _listViewController = ScrollController();
    }
    widget.controller._inject(this);
  }

  void _setRefresh(bool isRefresh) {
    setState(() => _isRefresh = isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.onWatchListViewScroll == null
        ? _buildSmartRefresher()
        : NotificationListener(
            onNotification: (notification) {
              if (widget.onWatchListViewScroll != null &&
                  notification is Notification &&
                  _listViewController?.hasClients == true) {
                widget.onWatchListViewScroll!(
                    notification, _listViewController!.position);
              }
              return false;
            },
            child: _buildSmartRefresher(),
          );
    return widget.requireSafeArea
        ? SafeArea(child: child)
        : Container(child: child);
  }

  Widget _buildSmartRefresher() {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: widget.onRefresh == null
          ? null
          : () {
              _setRefresh(true);
              widget.onRefresh!();
            },
      onLoading: widget.onLoading,
      header: const UCoreListHeader(),
      footer: const UCoreListFooter(),
      enablePullDown: widget.enableRefresh,
      enablePullUp: widget.enableLoadMore,
      physics: const BouncingScrollPhysics()
          .applyTo(AlwaysScrollableScrollPhysics()),
      child: _isRefresh
          ? (widget.itemCount == 0 ? Container() : _buildListView())
          : (widget.itemCount == 0 ? _buildEmptyView() : _buildListView()),
    );
  }

  Widget _buildListView() {
    return widget.separatorBuilder == null
        ? ListView.builder(
            controller: _listViewController,
            itemBuilder: widget.itemBuilder,
            itemCount: widget.itemCount,
          )
        : ListView.separated(
            controller: _listViewController,
            itemBuilder: widget.itemBuilder,
            separatorBuilder: widget.separatorBuilder!,
            itemCount: widget.itemCount,
          );
  }

  Widget _buildEmptyView() => UCoreEmptyViewWidget(
        icon: const LoadAssetImage("load/icon_load_nodata"),
        text: Text(I18nKeys.no_data),
      );
}
