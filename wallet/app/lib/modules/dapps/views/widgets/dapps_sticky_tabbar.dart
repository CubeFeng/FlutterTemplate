import 'package:flutter/material.dart';
import 'package:flutter_wallet/widgets/u_sliver_sticky_widget.dart';

import 'dapps_tabbar_indicator.dart';

class DappsStickyTabBarWidget extends StatelessWidget {
  final GlobalKey? tabBarGlobalKey;
  final EdgeInsetsGeometry? mPadding;
  final TabController tabController;
  final List<Tab> tabs;

  /// 点击
  final void Function(int index)? onTap;

  const DappsStickyTabBarWidget({
    Key? key,
    this.tabBarGlobalKey,
    required this.tabController,
    required this.tabs,
    this.onTap,
    this.mPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return USliverStickyWidget(
        minHeight: 40,
        maxHeight: 40,
        child: Container(
          padding: mPadding,
          color: Colors.white.withOpacity(0.2),
          child: Container(
            // margin: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(-10, -12),
                  blurRadius: 15, //阴影范围
                  spreadRadius: -5, //阴影浓度
                  color:
                  const Color(0xFF000000).withOpacity(0.08), ),
                BoxShadow(
                  offset: const Offset(10, -12),
                  blurRadius: 15, //阴影范围
                  spreadRadius: -5, //阴影浓度
                  color:
                  const Color(0xFF000000).withOpacity(0.08), ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
              child: TabBar(
                key: tabBarGlobalKey,
                labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                isScrollable: true,
                labelColor: const Color(0xFF2750EB),
                indicator: const DapplineTabIndicator(
                  borderSide: BorderSide(
                    width: 2,
                    color: Color(0xFF2750EB),
                  ),
                ),
                unselectedLabelColor: const Color(0xFF666666),
                labelStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                controller: tabController,
                tabs: tabs,
                onTap: onTap,
              ),
            ),
          ),
        ));
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  StickyTabBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(left: 5),
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
