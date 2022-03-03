import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/widgets/ucore_empty_view.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_footer.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef BoolCallback = bool Function();
typedef NotificationCallback<T extends Notification> = Function(T notification);

class UCoreListView extends StatelessWidget {
  final RefreshController controller;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final bool enableRefresh;
  final bool enableLoadMore;
  final bool? ifNoDataShowEmptyView;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final int itemCount;
  final NotificationCallback? onWatchNotification;
  final ScrollController? listController;

  const UCoreListView({
    Key? key,
    required this.controller,
    this.onRefresh,
    this.onLoading,
    this.enableRefresh = true,
    this.enableLoadMore = false,
    this.ifNoDataShowEmptyView,
    required this.itemBuilder,
    this.separatorBuilder,
    this.itemCount = 0,
    this.onWatchNotification,
    this.listController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NotificationListener(
        onNotification: (notification) {
          if (onWatchNotification != null && notification is Notification) {
            onWatchNotification!(notification);
          }
          return false;
        },
        child: SmartRefresher(
          controller: controller,
          onRefresh: onRefresh,
          onLoading: onLoading,
          header: const UCoreListHeader(),
          footer: const UCoreListFooter(),
          enablePullDown: enableRefresh,
          enablePullUp: enableLoadMore,
          physics: const BouncingScrollPhysics().applyTo(AlwaysScrollableScrollPhysics()),
          child: itemCount == 0 ? _buildEmptyView() : _buildListView(),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return separatorBuilder == null
        ? ListView.builder(
            controller: listController,
            itemBuilder: itemBuilder,
            itemCount: itemCount,
          )
        : ListView.separated(
            controller: listController,
            itemBuilder: itemBuilder,
            separatorBuilder: separatorBuilder!,
            itemCount: itemCount,
          );
  }

  Widget _buildEmptyView() {
    return ((ifNoDataShowEmptyView == null) ? controller.isRefresh : !ifNoDataShowEmptyView!)
        ? Container()
        : UCoreEmptyViewWidget(
            icon: const LoadAssetImage("load/icon_load_nodata"),
            text: Text(I18nKeys.no_data),
          );
  }
}
