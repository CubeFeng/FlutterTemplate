import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'dimens.dart';

/// 间隔
class Gaps {
  /// 水平间隔
  static const Widget hGap1 = SizedBox(width: Dimens.gap_dp1);
  static const Widget hGap3 = SizedBox(width: Dimens.gap_dp3);
  static const Widget hGap4 = SizedBox(width: Dimens.gap_dp4);
  static const Widget hGap5 = SizedBox(width: Dimens.gap_dp5);
  static const Widget hGap8 = SizedBox(width: Dimens.gap_dp8);
  static const Widget hGap10 = SizedBox(width: Dimens.gap_dp10);
  static const Widget hGap12 = SizedBox(width: Dimens.gap_dp12);
  static const Widget hGap15 = SizedBox(width: Dimens.gap_dp15);
  static const Widget hGap16 = SizedBox(width: Dimens.gap_dp16);
  static const Widget hGap20 = SizedBox(width: Dimens.gap_dp20);
  static const Widget hGap32 = SizedBox(width: Dimens.gap_dp32);
  static const Widget hGap34 = SizedBox(width: Dimens.gap_dp34);
  static const Widget hGap42 = SizedBox(width: Dimens.gap_dp42);
  static const Widget hGap47 = SizedBox(width: Dimens.gap_dp47);
  static const Widget hGap24 = SizedBox(width: Dimens.gap_dp24);

  /// 垂直间隔
  static const Widget vGap0 = SizedBox(height: Dimens.gap_dp0);
  static const Widget vGap4 = SizedBox(height: Dimens.gap_dp4);
  static const Widget vGap5 = SizedBox(height: Dimens.gap_dp5);
  static const Widget vGap8 = SizedBox(height: Dimens.gap_dp8);
  static const Widget vGap10 = SizedBox(height: Dimens.gap_dp10);
  static const Widget vGap12 = SizedBox(height: Dimens.gap_dp12);
  static const Widget vGap13 = SizedBox(height: Dimens.gap_dp13);
  static const Widget vGap14 = SizedBox(height: Dimens.gap_dp14);
  static const Widget vGap15 = SizedBox(height: Dimens.gap_dp15);
  static const Widget vGap16 = SizedBox(height: Dimens.gap_dp16);
  static const Widget vGap24 = SizedBox(height: Dimens.gap_dp24);
  static const Widget vGap32 = SizedBox(height: Dimens.gap_dp32);
  static const Widget vGap50 = SizedBox(height: Dimens.gap_dp50);
  static const Widget vGap34 = SizedBox(height: Dimens.gap_dp34);
  static const Widget vGap42 = SizedBox(height: Dimens.gap_dp42);
  static const Widget vGap47 = SizedBox(height: Dimens.gap_dp47);

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
