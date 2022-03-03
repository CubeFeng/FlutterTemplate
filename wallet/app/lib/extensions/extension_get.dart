import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/vendor/in_app_navigator_observer.dart';
import 'package:get/get.dart';

enum TopBannerStyle { Default, Primary, Error }

extension GetExtensions on GetInterface {
  /// 安全底栏高度
  double get safetyBottomBarHeight => bottomBarHeight / pixelRatio;

  /// 显示顶部条幅
  /// [message] 文案
  /// [style] 样式
  /// [duration] 为null时，不会自动消失
  void showTopBanner(
    String message, {
    TopBannerStyle style = TopBannerStyle.Primary,
    Duration? duration = const Duration(seconds: 2),
  }) {
    final Color messageColor;
    final Color backgroundColor;
    final Color indicatorColor;
    switch (style) {
      case TopBannerStyle.Default:
        messageColor = const Color(0xFF2750EB);
        backgroundColor = const Color(0xFFFFFFFF);
        indicatorColor = const Color(0xFF000000).withOpacity(0.1);
        break;
      case TopBannerStyle.Primary:
        messageColor = const Color(0xFFFFFFFF);
        backgroundColor = const Color(0xFF2750EB);
        indicatorColor = const Color(0xFFFFFFFF).withOpacity(0.2);
        break;
      case TopBannerStyle.Error:
        messageColor = const Color(0xFFFFFFFF);
        backgroundColor = const Color(0xFFE14444);
        indicatorColor = const Color(0xFFFFFFFF).withOpacity(0.2);
        break;
    }
    if (isSnackbarOpen == true) {
      back();
    }
    showSnackbar(GetBar(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 4),
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      borderRadius: 0,
      animationDuration: const Duration(milliseconds: 600),
      snackStyle: SnackStyle.GROUNDED,
      duration: duration,
      messageText: _TopBannerContent(
        message: message,
        messageColor: messageColor,
        indicatorColor: indicatorColor,
      ),
    ));
  }
}

class _TopBannerContent extends StatefulWidget {
  final String message;
  final Color messageColor;
  final Color indicatorColor;

  const _TopBannerContent({
    Key? key,
    required this.message,
    required this.messageColor,
    required this.indicatorColor,
  }) : super(key: key);

  @override
  _TopBannerContentState createState() => _TopBannerContentState();
}

class _TopBannerContentState extends State<_TopBannerContent>
    with InAppRouteListener {
  @override
  void initState() {
    super.initState();
    InAppNavigatorObserver().addListener(this);
  }

  @override
  void dispose() {
    InAppNavigatorObserver().removeListener(this);
    super.dispose();
  }

  @override
  void didInAppRouteStartUserGesture(Route route, Route? previousRoute) {
    // 检测到用户开始操作路由手势时先关闭TopBanner
    if (Get.isSnackbarOpen == true) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.messageColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 9.h),
        Container(
          width: 30.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: widget.indicatorColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        )
      ],
    );
  }
}
