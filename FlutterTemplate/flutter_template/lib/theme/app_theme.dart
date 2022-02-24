import 'package:flutter_template/theme/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    return ThemeData.light().copyWith(
      errorColor: Colors.redAccent,
      brightness: Brightness.light,
      primaryColor: Colours.app_main,
      accentColor: Colours.app_main,
      // Tab指示器颜色
      indicatorColor: Colours.app_main,
      // 页面背景色
      scaffoldBackgroundColor: Colors.white,
      // 主要用于Material背景色
      canvasColor: Colors.white,
      // 文字选择色（输入框选择文字等）
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colours.app_main.withAlpha(70),
        selectionHandleColor: Colours.app_main,
        cursorColor: Colours.app_main,
      ),
      textTheme: TextTheme(
        // TextField输入文字颜色
        subtitle1: TextStyles.text,
        // Text文字样式
        bodyText2: TextStyles.text,
        subtitle2: TextStyles.textGray12,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyles.textDarkGray14,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        color: Colors.white,
        brightness: Brightness.light,
      ),
      dividerTheme: DividerThemeData(color: Colours.line, space: 0.6, thickness: 0.6),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.light,
      ),
      visualDensity: VisualDensity.standard, // https://github.com/flutter/flutter/issues/77142
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      errorColor: Colors.redAccent,
      brightness: Brightness.dark,
      primaryColor: Colours.dark_app_main,
      accentColor: Colours.dark_app_main,
      // Tab指示器颜色
      indicatorColor: Colours.dark_app_main,
      // 页面背景色
      scaffoldBackgroundColor: Colours.dark_bg_color,
      // 主要用于Material背景色
      canvasColor: Colours.dark_material_bg,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colours.app_main.withAlpha(70),
        selectionHandleColor: Colours.app_main,
        cursorColor: Colours.app_main,
      ),
      textTheme: TextTheme(
        // TextField输入文字颜色
        subtitle1: TextStyles.textDark,
        // Text文字样式
        bodyText2: TextStyles.textDark,
        subtitle2: TextStyles.textDarkGray12,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyles.textHint14,
      ),
      appBarTheme: AppBarTheme(
        // elevation: 0.0,
        color: Colours.dark_bg_color,
        brightness: Brightness.dark,
      ),
      dividerTheme: DividerThemeData(color: Colours.dark_line, space: 0.6, thickness: 0.6),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      visualDensity: VisualDensity.standard, // https://github.com/flutter/flutter/issues/77142
    );
  }
}