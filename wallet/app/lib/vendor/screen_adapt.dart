import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 屏幕适配
/// fork [package:flutter_screenutil/screenutil_init.dart]
///
class ScreenAdapt extends StatelessWidget {
  /// A helper widget that initializes [ScreenUtil]
  const ScreenAdapt({
    required this.builder,
    this.designSize = ScreenUtil.defaultSize,
    this.predictScreenSize,
    Key? key,
  }) : super(key: key);

  final Widget Function() builder;

  /// The [Size] of the device in the design draft, in dp
  final Size designSize;

  /// 预估屏幕尺寸
  final Size? predictScreenSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      return OrientationBuilder(
        builder: (_, Orientation orientation) {
          if (constraints.maxWidth == 0 && predictScreenSize != null) {
            constraints = BoxConstraints.tight(predictScreenSize!);
          }
          if (constraints.maxWidth != 0) {
            ScreenUtil.init(
              constraints,
              context: context,
              orientation: orientation,
              designSize: designSize,
            );
            return builder();
          }
          return Container(color: Colors.red);
        },
      );
    });
  }
}
