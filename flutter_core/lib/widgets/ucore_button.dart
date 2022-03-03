import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

class UCoreButton extends StatelessWidget {
  const UCoreButton({
    Key? key,
    this.text = '',
    this.fontSize = Dimens.font_sp14,
    this.textColor,
    this.disabledTextColor,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.minHeight = 48.0,
    this.minWidth = double.infinity,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.radius = 8.0,
    this.side = BorderSide.none,
    required this.onPressed,
  }) : super(key: key);

  const UCoreButton.outline({
    Key? key,
    this.text = '',
    this.fontSize = Dimens.font_sp14,
    this.textColor = const Color(0xFFFF9544),
    this.disabledTextColor,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.minHeight = 48.0,
    this.minWidth = double.infinity,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.radius = 8.0,
    this.side = const BorderSide(color: Color(0xFFFF9544), width: 1),
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final double fontSize;
  final Color? textColor;
  final Color? disabledTextColor;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final double? minHeight;
  final double? minWidth;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final double radius;
  final BorderSide side;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        gradient: side == BorderSide.none
            ? LinearGradient(
                colors: <Color>[Color(0xFFFFBD4B), Color(0xFFFF9544)],
              )
            : null,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: SizedBox(
        height: 42.sp,
        child: TextButton(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
            onPressed: onPressed,
            style: ButtonStyle(
              // 文字颜色
              foregroundColor: MaterialStateProperty.resolveWith(
                (states) {
                  if (states.contains(MaterialState.disabled)) {
                    return disabledTextColor ?? (isDark ? Colours.dark_text_disabled : Colours.text_disabled);
                  }
                  return textColor ?? (isDark ? Colours.dark_button_text : Colors.white);
                },
              ),
              // 背景颜色
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled)) {
                  return disabledBackgroundColor ?? (isDark ? Colours.dark_button_disabled : Colours.button_disabled);
                }
                return side == BorderSide.none ? Colors.transparent : Color(0xFFFFF8F3);
                // return backgroundColor ?? (isDark ? Colours.dark_app_main : Colours.app_main);
              }),
              // 水波纹
              overlayColor: MaterialStateProperty.resolveWith((states) {
                return (textColor ?? (isDark ? Colours.dark_button_text : Colors.white)).withOpacity(0.12);
              }),
              // 按钮最小大小
              minimumSize: (minWidth == null || minHeight == null)
                  ? null
                  : MaterialStateProperty.all<Size>(Size(minWidth!, minHeight!)),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(padding),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
              side: MaterialStateProperty.all<BorderSide>(side),
            )),
      ),
    );
  }
}
