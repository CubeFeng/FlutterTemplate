import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:rxdart/rxdart.dart';

import 'colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colours.brand,
      backgroundColor: Colours.primary_bg,
      scaffoldBackgroundColor: Colours.primary_bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colours.primary_bg,
        centerTitle: true,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        space: 0,
        color: Colours.divider,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colours.dark_brand,
      backgroundColor: Colours.dark_primary_bg,
      scaffoldBackgroundColor: Colours.dark_primary_bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colours.dark_primary_bg,
        centerTitle: true,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        space: 0,
        color: Colours.dark_divider,
      ),
    );
  }

  static StreamSubscription? _subscription;

  /// 设置NavigationBar样式，使得导航栏颜色与深色模式的设置相符。
  static void setSystemNavigationBar(ThemeMode mode) {
    /// 主题切换动画（AnimatedTheme）时间为200毫秒，延时设置导航栏颜色，这样过渡相对自然。
    _subscription?.cancel();
    _subscription = Stream.value(1).delay(const Duration(milliseconds: 200)).listen((_) {
      bool _isDark = false;
      if (mode == ThemeMode.dark || (mode == ThemeMode.system && window.platformBrightness == Brightness.dark)) {
        _isDark = true;
      }
      setSystemBarStyle(isDark: _isDark);
    });
  }

  /// 设置StatusBar、NavigationBar样式。(仅针对安卓)
  /// 本项目在android MainActivity中已设置，不需要覆盖设置。
  static void setSystemBarStyle({bool? isDark}) {
    if (DeviceUtils.isAndroid) {
      final bool _isDark = isDark ?? window.platformBrightness == Brightness.dark;
      final SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        /// 透明状态栏
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _isDark ? Colours.dark_primary_bg : Colors.white,
        systemNavigationBarIconBrightness: _isDark ? Brightness.light : Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}
