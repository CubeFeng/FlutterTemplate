import 'package:flutter/material.dart';
import 'package:flutter_wallet_dapp_browser/flutter_wallet_dapp_browser.dart';
import 'package:get/get.dart';

class BrowserAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BrowserAppBar({
    Key? key,
    // required this.progress,
    // required this.title,
    this.closeBtnVisible = true,
    required this.backButtonPress,
    required this.closeButtonPress,
    this.actionBtnVisible = true,
    required this.actionButtonPress,
    required this.controller,
  }) : super(key: key);

  // final double progress;
  // final String title;
  final bool closeBtnVisible;
  final bool actionBtnVisible;
  final GestureTapCallback backButtonPress;
  final GestureTapCallback closeButtonPress;
  final GestureTapCallback actionButtonPress;
  final DappsBrowserController controller;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        child: Obx(() {
          return AnimatedOpacity(
            opacity: controller.loadProgress.value < 1 ? 1 : 0,
            duration: const Duration(milliseconds: 100),
            child: LinearProgressIndicator(
              value: controller.loadProgress.value,
              valueColor: const AlwaysStoppedAnimation(Colors.blueAccent),
              minHeight: 2,
              backgroundColor: Colors.white,
            ),
          );
        }),
        preferredSize: Size(Get.width, 0),
      ),
      // brightness: Brightness.light,
      backgroundColor: Colors.white,
      // shadowColor: Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Obx(() => Text(controller.webTitle.value,
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.black87, fontSize: 18))),
      leadingWidth: 120,
      leading: Row(
        children: [
          IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black87,
              ),
              onPressed: backButtonPress),
          if (closeBtnVisible) ...{
            InkWell(
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                  child: Icon(
                    Icons.close_sharp,
                    color: Colors.black87,
                    size: 24,
                  ),
                ),
                onTap: closeButtonPress)
          } else ...{
            const SizedBox()
          },
        ],
      ),
      actions: [
        if (actionBtnVisible) ...{
          IconButton(
              icon: const Icon(
                Icons.more_horiz_sharp,
                color: Colors.black87,
              ),
              onPressed: actionButtonPress)
        } else ...{
          const SizedBox()
        }
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
