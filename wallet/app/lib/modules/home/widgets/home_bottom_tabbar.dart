import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/icon_font.g.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/vendor/in_app_navigator_observer.dart';

class HomeBottomTabBar extends StatefulWidget {
  final TabController controller;
  final List<Widget> tabs;

  const HomeBottomTabBar({
    Key? key,
    required this.controller,
    required this.tabs,
  }) : super(key: key);

  @override
  _HomeBottomTabBarState createState() => _HomeBottomTabBarState();
}

class _HomeBottomTabBarState extends State<HomeBottomTabBar>
    with WidgetsBindingObserver, InAppRouteListener {
  var blurSigmaValue = 5.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    InAppNavigatorObserver().addListener(this);
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    InAppNavigatorObserver().removeListener(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void didInAppRoutePush(Route route, Route? previousRoute) {
    super.didInAppRoutePush(route, previousRoute);
    final routeName = route.settings.name;
    if (routeName != null) {
      if (routeName.startsWith(Routes.DAPPS_Web_BANNER) ||
          routeName.startsWith(Routes.DAPPS_BROWSER)) {
        if (blurSigmaValue != 0.0) {
          setState(() => blurSigmaValue = 0.0);
        }
      }
    }
  }

  @override
  void didInAppRoutePop(Route route, Route? previousRoute) {
    super.didInAppRoutePop(route, previousRoute);
    if (blurSigmaValue != 5.0) {
      // 延迟1000毫秒，确保上一个界面已经完全关闭
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() => blurSigmaValue = 5.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSigmaValue,
          sigmaY: blurSigmaValue,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.94549),
          ),
          padding: EdgeInsets.only(bottom: Get.safetyBottomBarHeight),
          child: TabBar(
            padding: EdgeInsets.only(
              top: Get.safetyBottomBarHeight == 0 ? 16.h : 8.h,
              bottom: Get.safetyBottomBarHeight == 0 ? 16.h : 8.h,
            ),
            controller: widget.controller,
            indicatorColor: Colors.transparent,
            tabs: widget.tabs,
          ),
        ),
      ),
    );
  }
}

class HomeTabItem extends StatelessWidget {
  const HomeTabItem({
    Key? key,
    required this.selectedIcon,
    required this.unSelectedIcon,
    this.selected = false,
  }) : super(key: key);

  final String selectedIcon;
  final String unSelectedIcon;
  final bool selected;
  final selectedKey = const ValueKey("selected");
  final unselectedKey = const ValueKey("unselected");

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: selected
              ? IconFont(selectedIcon,  key: selectedKey, size: 36)
              : IconFont(unSelectedIcon, key: unselectedKey, size: 26),
        ),
      ],
    );
  }
}

// class HomeTabItem extends StatelessWidget {
//   final Widget icon;
//   final bool selected;
//   final Color indicatorColor;
//   final Color selectedColor;
//   final Color unselectedColor;

//   const HomeTabItem({
//     Key? key,
//     required this.icon,
//     required this.selected,
//     this.indicatorColor = const Color(0xFF2750EB),
//     this.selectedColor = const Color(0xFFFFFFFF),
//     this.unselectedColor = const Color(0xFF555555),
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned(
//           top: 8,
//           left: 0,
//           right: 0,
//           child: selected
//               ? CustomPaint(
//                   size: const Size(48, 48),
//                   painter: _HomeTabItemIndicatorPainter(color: indicatorColor),
//                 )
//               : const SizedBox.shrink(),
//         ),
//         Positioned(
//           top: 18,
//           left: 0,
//           right: 0,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             child: IconTheme(
//               data: IconThemeData(
//                 size: 26,
//                 color: (selected ? selectedColor : unselectedColor),
//               ),
//               child: SizedBox(width: 26, height: 26, child: icon),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _HomeTabItemIndicatorPainter extends CustomPainter {
//   final Color color;

//   _HomeTabItemIndicatorPainter({required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = color;
//     final centerX = size.width / 2;
//     final centerY = size.height / 2;
//     final radius = min(centerX, centerY);
//     final path = Path()..addArc(Rect.fromCircle(center: Offset(centerX, centerY), radius: radius), pi * 0.75, pi * 1.5);
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
