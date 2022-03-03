import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

class UCoreRssSubscribeButton extends StatelessWidget {
  final bool isSubscribe;
  final VoidCallback? onTap;

  const UCoreRssSubscribeButton({Key? key, this.isSubscribe = false, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: SizedBox(
          width: 56,
          height: 30,
          child: LoadAssetImage(isSubscribe ? "rss/icon_rss_subscribe" : "rss/icon_rss_subscribed"),
        ),
      ),
    );
  }
}
