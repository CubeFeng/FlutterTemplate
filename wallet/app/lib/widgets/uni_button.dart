import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum UniButtonStyle { Primary, PrimaryLight, Danger, DangerLight }

/// 应用内通用按钮
class UniButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final UniButtonStyle style;

  const UniButton({
    Key? key,
    this.style = UniButtonStyle.Primary,
    required this.onPressed,
    required this.child,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color contentColor;
    Color contentDisabledColor;
    Color buttonColor;
    Color buttonDisabledColor;
    switch (style) {
      case UniButtonStyle.Primary:
        contentColor = const Color(0xFFFFFFFF);
        contentDisabledColor = const Color(0xFFCCCCCC);
        buttonColor = const Color(0xFF2750EB);
        buttonDisabledColor = const Color(0xFFF8F8F8);
        break;
      case UniButtonStyle.PrimaryLight:
        contentColor = const Color(0xFF2750EB);
        contentDisabledColor = const Color(0xFFCCCCCC);
        buttonColor = const Color(0xFF2750EB).withOpacity(0.1);
        buttonDisabledColor = const Color(0xFFF8F8F8);
        break;
      case UniButtonStyle.Danger:
        contentColor = const Color(0xFFFFFFFF);
        contentDisabledColor = const Color(0xFFCCCCCC);
        buttonColor = const Color(0xFFEE4949);
        buttonDisabledColor = const Color(0xFFF8F8F8);
        break;
      case UniButtonStyle.DangerLight:
        contentColor = const Color(0xFFEE4949);
        contentDisabledColor = const Color(0xFFCCCCCC);
        buttonColor = const Color(0xFFEE4949).withOpacity(0.1);
        buttonDisabledColor = const Color(0xFFF8F8F8);
        break;
    }
    return ElevatedButton(
      onPressed: onPressed,
      child: DefaultTextStyle(
        style: TextStyle(
          color: onPressed == null ? contentDisabledColor : contentColor,
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
        ),
        child: IconTheme(
          data: IconThemeData(
            color: onPressed == null ? contentDisabledColor : contentColor,
            size: 24.0,
          ),
          child: child,
        ),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.only(left: 45,right: 45)),
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            return states.contains(MaterialState.disabled)
                ? buttonDisabledColor
                : buttonColor;
          },
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(15.r))),
      ),
    );
  }
}
