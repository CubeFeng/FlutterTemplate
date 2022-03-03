import 'dart:math';

import 'package:flutter/material.dart';

class USliverStickyWidget extends StatelessWidget {
  final bool pinned;
  final bool floating;
  final double minHeight;
  final double maxHeight;
  final Widget child;

  const USliverStickyWidget({
    Key? key,
    this.pinned = true,
    this.floating = true,
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: _USliverStickyWidgetDelegate(
        minHeight: minHeight,
        maxHeight: maxHeight,
        child: child,
      ),
    );
  }
}

class _USliverStickyWidgetDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  const _USliverStickyWidgetDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_USliverStickyWidgetDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
