import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

// 小红点
class UCoreRedDot extends StatelessWidget {
  const UCoreRedDot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Get.isDarkMode ? Colours.dark_badge : Colours.badge,
      ),
    );
  }
}
