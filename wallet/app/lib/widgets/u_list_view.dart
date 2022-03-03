import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/theme/colors.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

export 'package:pull_to_refresh/pull_to_refresh.dart';

class UListView extends StatefulWidget {
  final UListViewController controller;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final bool enableRefresh;
  final bool enableLoadMore;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final int itemCount;
  final UListViewScrollCallback? onWatchListViewScroll;
  final EdgeInsets? padding;
  final Widget? custumEmptyWidget;

  const UListView({
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
    this.padding,
    this.custumEmptyWidget,
  }) : super(key: key);

  @override
  _UListViewState createState() => _UListViewState();
}

class _UListViewState extends State<UListView> {
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
    return SafeArea(
      child: widget.onWatchListViewScroll == null
          ? _buildSmartRefresher()
          : NotificationListener(
              onNotification: (notification) {
                if (widget.onWatchListViewScroll != null &&
                    notification is Notification &&
                    _listViewController?.hasClients == true) {
                  widget.onWatchListViewScroll!(notification, _listViewController!.position);
                }
                return false;
              },
              child: _buildSmartRefresher(),
            ),
    );
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
      header: const UListViewHeader(),
      footer: const UListViewFooter(),
      enablePullDown: widget.enableRefresh,
      enablePullUp: widget.enableLoadMore,
      physics: const BouncingScrollPhysics().applyTo(const AlwaysScrollableScrollPhysics()),
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
            padding: widget.padding,
          )
        : ListView.separated(
            controller: _listViewController,
            itemBuilder: widget.itemBuilder,
            separatorBuilder: widget.separatorBuilder!,
            itemCount: widget.itemCount,
            padding: widget.padding,
          );
  }

  Widget _buildEmptyView() {
    if (widget.custumEmptyWidget != null){
      return widget.custumEmptyWidget ?? UEmptyView(icon: const WalletLoadAssetImage('load/icon_load_nodata'),text: Text(I18nKeys.no_data),);
    }else{
      return UEmptyView(icon: const WalletLoadAssetImage('load/icon_load_nodata'),text: Text(I18nKeys.no_data),);
    }
  }
}

typedef BoolCallback = bool Function();
typedef UListViewScrollCallback<N extends Notification, P extends ScrollPosition> = Function(
    N notification, P position);

class UListViewController {
  final bool initialRefresh;
  RefreshStatus? initialRefreshStatus;
  LoadStatus? initialLoadStatus;

  bool get isRefresh => _state._isRefresh;

  late _UListViewState _state;

  UListViewController.initialRefresh({
    this.initialRefresh = true,
    this.initialRefreshStatus = RefreshStatus.refreshing,
    this.initialLoadStatus,
  });

  UListViewController({
    this.initialRefresh = false,
    this.initialRefreshStatus,
    this.initialLoadStatus,
  });

  void _inject(_UListViewState state) {
    _state = state;
  }

  Future<void>? requestRefresh({
    bool needMove = true,
    bool needCallback = true,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.linear,
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
    bool needMove = true,
    bool needCallback = true,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) {
    return _state._refreshController.requestLoading(
      needMove: true,
      needCallback: true,
      duration: duration,
      curve: curve,
    );
  }

  void refreshCompleted({bool resetFooterState = false}) {
    _state._setRefresh(false);
    _state._refreshController.refreshCompleted(resetFooterState: resetFooterState);
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

class UListViewHeader extends StatelessWidget {
  const UListViewHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      builder: (BuildContext context, RefreshStatus? mode) {
        Widget body;
        if (mode == RefreshStatus.idle) {
          body = Text(I18nKeys.pull_down_to_refresh);
        } else if (mode == RefreshStatus.canRefresh) {
          body = Text(I18nKeys.release_to_refresh_immediately);
        } else if (mode == RefreshStatus.refreshing) {
          body = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CupertinoActivityIndicator(),
              const SizedBox(width: 8),
              Text(I18nKeys.data_is_being_refreshed),
            ],
          );
        } else if (mode == RefreshStatus.completed) {
          body = Text(I18nKeys.refresh_succeeded);
        } else if (mode == RefreshStatus.failed) {
          body = Text(I18nKeys.refresh_failed);
        } else {
          body = const Text("");
        }
        return SizedBox(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
  }
}

class UListViewFooter extends StatelessWidget {
  const UListViewFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text(I18nKeys.pull_load_more);
        } else if (mode == LoadStatus.canLoading) {
          body = Text(I18nKeys.release_load_more);
        } else if (mode == LoadStatus.loading) {
          body = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CupertinoActivityIndicator(),
              const SizedBox(width: 8),
              Text(I18nKeys.loading_more_data),
            ],
          );
        } else if (mode == LoadStatus.failed) {
          body = Text(I18nKeys.loading_failed_click_retry);
        } else if (mode == LoadStatus.noMore) {
          body = Text(I18nKeys.loading_has_completed);
        } else {
          body = const Text('');
        }
        return SizedBox(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
  }
}

class UEmptyView extends StatelessWidget {
  final Widget icon;
  final Widget? text;

  const UEmptyView({
    Key? key,
    required this.icon,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 94),
        icon,
        const SizedBox(height: 8),
        text == null
            ? const SizedBox.shrink()
            : DefaultTextStyle(
                style: TextStyle(
                  fontSize: 12,
                  color: Get.isDarkMode ? Colours.dark_tertiary_text : Colours.tertiary_text,
                ),
                child: text!,
              )
      ],
    );
  }
}
