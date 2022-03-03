import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

class WebViewProgress extends StatelessWidget implements PreferredSizeWidget {
  const WebViewProgress({Key? key, required this.loadProgress}) : super(key: key);

  final RxDouble loadProgress;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnimatedOpacity(
        opacity: loadProgress.value < 1 ? 1 : 0,
        duration: const Duration(milliseconds: 100),
        child: LinearProgressIndicator(
          value: loadProgress.value,
          valueColor: const AlwaysStoppedAnimation(Colors.orangeAccent),
          minHeight: 2,
          backgroundColor: Colors.white,
        ),
      );
    });
  }

  @override
  Size get preferredSize => Size(Get.width, 0);
}
