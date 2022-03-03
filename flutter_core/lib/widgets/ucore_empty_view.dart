import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';

class UCoreEmptyViewWidget extends StatelessWidget {
  final Widget icon;
  final Widget? text;

  const UCoreEmptyViewWidget({
    Key? key,
    required this.icon,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 94),
        icon,
        Gaps.hGap8,
        text == null
            ? SizedBox.shrink()
            : DefaultTextStyle(
                style: TextStyle(
                  fontSize: 12,
                  color: Get.isDarkMode ? Colours.dark_tertiary_text : Colours.tertiary_text,
                ),
                child: text!,
              )
      ],
    );
  }
}
