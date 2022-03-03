import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'dimens.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

/// 间隔
class Gaps {
  /// 水平间隔
  static Widget hGap1 = SizedBox(width: Dimens.gap_dp1.sp);
  static Widget hGap3 = SizedBox(width: Dimens.gap_dp3.sp);
  static Widget hGap4 = SizedBox(width: Dimens.gap_dp4.sp);
  static Widget hGap5 = SizedBox(width: Dimens.gap_dp5.sp);
  static Widget hGap8 = SizedBox(width: Dimens.gap_dp8.sp);
  static Widget hGap10 = SizedBox(width: Dimens.gap_dp10.sp);
  static Widget hGap12 = SizedBox(width: Dimens.gap_dp12.sp);
  static Widget hGap14 = SizedBox(width: Dimens.gap_dp14.sp);
  static Widget hGap15 = SizedBox(width: Dimens.gap_dp15.sp);
  static Widget hGap16 = SizedBox(width: Dimens.gap_dp16.sp);
  static Widget hGap20 = SizedBox(width: Dimens.gap_dp20.sp);
  static Widget hGap32 = SizedBox(width: Dimens.gap_dp32.sp);
  static Widget hGap34 = SizedBox(width: Dimens.gap_dp34.sp);
  static Widget hGap42 = SizedBox(width: Dimens.gap_dp42.sp);
  static Widget hGap47 = SizedBox(width: Dimens.gap_dp47.sp);
  static Widget hGap24 = SizedBox(width: Dimens.gap_dp24.sp);

  /// 垂直间隔
  static Widget vGap0 = SizedBox(height: Dimens.gap_dp0.sp);
  static Widget vGap4 = SizedBox(height: Dimens.gap_dp4.sp);
  static Widget vGap5 = SizedBox(height: Dimens.gap_dp5.sp);
  static Widget vGap8 = SizedBox(height: Dimens.gap_dp8.sp);
  static Widget vGap9 = SizedBox(height: Dimens.gap_dp9.sp);
  static Widget vGap10 = SizedBox(height: Dimens.gap_dp10.sp);
  static Widget vGap12 = SizedBox(height: Dimens.gap_dp12.sp);
  static Widget vGap13 = SizedBox(height: Dimens.gap_dp13.sp);
  static Widget vGap14 = SizedBox(height: Dimens.gap_dp14.sp);
  static Widget vGap15 = SizedBox(height: Dimens.gap_dp15.sp);
  static Widget vGap16 = SizedBox(height: Dimens.gap_dp16.sp);
  static Widget vGap18 = SizedBox(height: Dimens.gap_dp18.sp);
  static Widget vGap20 = SizedBox(height: Dimens.gap_dp20.sp);
  static Widget vGap24 = SizedBox(height: Dimens.gap_dp24.sp);
  static Widget vGap30 = SizedBox(height: Dimens.gap_dp30.sp);
  static Widget vGap32 = SizedBox(height: Dimens.gap_dp32.sp);
  static Widget vGap50 = SizedBox(height: Dimens.gap_dp50.sp);
  static Widget vGap34 = SizedBox(height: Dimens.gap_dp34.sp);
  static Widget vGap42 = SizedBox(height: Dimens.gap_dp42.sp);
  static Widget vGap47 = SizedBox(height: Dimens.gap_dp47.sp);

  static const Widget line = Divider();

  static const Widget vLine = SizedBox(
    width: 0.6,
    height: 24.0,
    child: VerticalDivider(),
  );

  /// 垂直线
  static Widget vvLine({double? width, double? height, Color? color}) {
    if (color != null) {
      return SizedBox(
        width: width ?? 0.6,
        height: height ?? 24.0,
        child: VerticalDivider(color: color),
      );
    } else {
      return SizedBox(
        width: width ?? 0.6,
        height: height ?? 24.0,
        child: const VerticalDivider(),
      );
    }
  }

  static Widget hhLine({double? width, double? height, Color? color}) {
    if (color != null) {
      return SizedBox(
        width: width,
        height: height,
        child: Divider(color: color),
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: const Divider(),
      );
    }
  }

  static const Widget empty = SizedBox.shrink();
}
