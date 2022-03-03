import 'package:flutter/material.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:get/get.dart';

void showBrowserBottomSheet({
  required BuildContext context,
  required String title,
  required VoidCallback onSwitchAccount,
  required VoidCallback onCopyLink,
  required VoidCallback onRefresh,
  required VoidCallback onShare,
  required VoidCallback onOpenInBrowser,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
    // elevation: 0,
    enableDrag: false,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    builder: (context) {
      return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF333333),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 40,
                      bottom: 30,
                    ),
                    child: GestureDetector(
                      onTap: onSwitchAccount,
                      child: Stack(
                        children: [
                          const WalletLoadImage("dapp/dapp_switch_account",fit: BoxFit.fitWidth,),
                          // Image.asset(
                          //   'packages/flutter_wallet_dapp_browser/assets/images/switch_account.png',
                          // ),
                          Positioned(
                            left: 52,
                            top: 18,
                            child: Text(I18nKeys.switchAccount, style: TextStyle(fontSize: 12)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                      bottom: 83,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFuncItem(
                          title: I18nKeys.copyLink,
                          icon:
                              const WalletLoadImage("dapp/dapp_copy_link"),
                          onPress: onCopyLink,
                        ),
                        _buildFuncItem(
                          title: I18nKeys.share,
                          icon:const WalletLoadImage("dapp/dapp_share"),
                          onPress: onShare,
                        ),
                        _buildFuncItem(
                          title: I18nKeys.refresh,
                          icon:const WalletLoadImage("dapp/dapp_refresh"),
                          onPress: onRefresh,
                        ),
                        _buildFuncItem(
                          title: I18nKeys.openInBrowser,
                          icon:const WalletLoadImage("dapp/dapp_open_in_browser"),

                          onPress: onOpenInBrowser,
                        )
                      ],
                    ),
                  ),
                  const BottomAction(),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildFuncItem({
  required String title,
  required Widget icon,
  required VoidCallback onPress,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 17),
          child: icon,
        ),
        Text(title),
      ],
    ),
  );
}

void showBrowserActionSheet(
  BuildContext context,
  String title,
  List<Map<String, dynamic>> topActions,
  List<Map<String, dynamic>> bottomActions,
) {
  showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      // elevation: 0,
      enableDrag: false,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      )),
      builder: (context) {
        return SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(13),
              child: Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    // color: Colors.amberAccent,
                    // alignment: Alignment.center,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return TopActionItemWidget(
                          title: topActions[index]['title'] as String,
                          icon: topActions[index]['icon'] as Widget,
                          onPress: topActions[index]['onPress'] as VoidCallback,
                          // onLongPress: topActions[index]['onLongPress']
                          //     ? bottomActions[index]['onLongPress'] as VoidCallback
                          //     : null,
                        );
                      },
                      itemCount: topActions.length,
                    ),
                  ),
                  // const Divider(
                  //   height: 1,
                  // ),
                  SizedBox(
                    height: 100,
                    // alignment: Alignment.center,
                    // color: Colors.deepPurpleAccent,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return BottomActionItemWidget(
                          title: bottomActions[index]['title'] as String,
                          icon: bottomActions[index]['icon'] as Widget,
                          onPress:
                              bottomActions[index]['onPress'] as VoidCallback,
                          // onLongPress: bottomActions[index]['onLongPress']
                          //     ? bottomActions[index]['onLongPress'] as VoidCallback
                          //     : null,
                        );
                      },
                      itemCount: bottomActions.length,
                    ),
                  ),
                  const BottomAction(),
                ]),
          ],
        ));
      });
}

class TopActionItemWidget extends StatelessWidget {
  const TopActionItemWidget(
      {Key? key, required this.title, required this.icon, required this.onPress, this.onLongPress})
      : super(key: key);

  final String title;
  final Widget icon;
  final VoidCallback onPress;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white60,
      // splashFactory: NoSplash.splashFactory,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  color: Colors.grey[100],
                  child: IconTheme(data: const IconThemeData(size: 32, color: Colors.black87), child: icon)),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
              softWrap: true,
            ),
            const Expanded(child: SizedBox.shrink()),
            const Icon(
              Icons.arrow_forward_outlined,
              size: 17,
              color: Color(0x88CCCCCC),
            ),

            const SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
      onTap: () {
        Get.back();
        onPress();
      },
      onLongPress: () {
        Get.back();
        onLongPress != null ? onLongPress!() : null;
      },
    );
  }
}

class BottomActionItemWidget extends StatelessWidget {
  const BottomActionItemWidget(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onPress,
      this.onLongPress})
      : super(key: key);

  final String title;
  final Widget icon;
  final VoidCallback onPress;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white60,
      // splashFactory: NoSplash.splashFactory,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  color: Colors.grey[100],
                  child: IconTheme(
                      data:
                          const IconThemeData(size: 32, color: Colors.black87),
                      child: icon)),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
              softWrap: true,
            )
          ],
        ),
      ),
      onTap: () {
        Get.back();
        onPress();
      },
      onLongPress: () {
        Get.back();
        onLongPress != null ? onLongPress!() : null;
      },
    );
  }
}

class BottomAction extends StatelessWidget {
  const BottomAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 5,
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromRGBO(247, 248, 250, 1)
              : const Color.fromRGBO(247, 248, 250, 1),
        ),
        InkWell(
          highlightColor: Colors.white60,
          splashFactory: NoSplash.splashFactory,
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                I18nKeys.cancel,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        )
      ],
    );
  }
}
