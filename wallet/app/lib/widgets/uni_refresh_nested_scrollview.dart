import 'package:flutter/material.dart';
import 'package:flutter_wallet/widgets/uni_scroll_behavior.dart';

typedef UniRefreshCallback = Future<void> Function();

typedef UniRefreshIndicatorBuilder = Widget Function(
    BuildContext context, UniRefreshState state);

enum UniRefreshState { normal, refreshing }

class UniRefreshNestedScrollView extends StatefulWidget {
  final NestedScrollViewHeaderSliversBuilder headerSliverBuilder;
  final Widget body;
  final UniRefreshIndicatorBuilder refreshIndicatorBuilder;
  final UniRefreshCallback onRefresh;

  const UniRefreshNestedScrollView({
    Key? key,
    required this.headerSliverBuilder,
    required this.body,
    required this.refreshIndicatorBuilder,
    required this.onRefresh,
  }) : super(key: key);

  @override
  _UniRefreshNestedScrollViewState createState() =>
      _UniRefreshNestedScrollViewState();
}

class _UniRefreshNestedScrollViewState
    extends State<UniRefreshNestedScrollView> {
  late final scrollController = ScrollController(initialScrollOffset: 60.0);
  var state = UniRefreshState.normal;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollEndNotification && notification.depth == 0) {
          if (scrollController.offset < 5.0) {
            // 触发刷新
            setState(() {
              state = UniRefreshState.refreshing;
              widget.onRefresh().then((value) {
                setState(() => state = UniRefreshState.normal);
                scrollController.animateTo(
                  scrollController.initialScrollOffset,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                );
              });
            });
            return true;
          }
          if (scrollController.offset > 5.0 &&
              scrollController.offset < scrollController.initialScrollOffset) {
            Future.delayed(const Duration(seconds: 0), () {
              scrollController.animateTo(
                scrollController.initialScrollOffset,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear,
              );
            });
            return true;
          }
          return false;
        }
        return false;
      },
      child: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                height: scrollController.initialScrollOffset,
                child: widget.refreshIndicatorBuilder(context, state),
              ),
            ),
            ...widget.headerSliverBuilder(context, innerBoxIsScrolled)
          ];
        },
        body: ScrollConfiguration(
          behavior: NoSplashScrollBehavior(),
          child: widget.body,
        ),
      ),
    );
  }
}
