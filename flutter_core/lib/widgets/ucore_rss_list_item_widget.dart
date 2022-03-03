import 'package:flutter_ucore/models/news/rss_model.dart';
import 'package:flutter_ucore/widgets/ucore_rss_subscribe_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

class UCoreRssListItemWidget extends StatelessWidget {
  final RssModel item;
  final VoidCallback onItemTap;
  final VoidCallback onButtonTap;

  const UCoreRssListItemWidget({
    Key? key,
    required this.item,
    required this.onItemTap,
    required this.onButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: LoadImage(item.icon ?? ""),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.rssName ?? "", style: Get.textTheme.headline6!.copyWith(fontSize: 16)),
                  SizedBox(height: 6),
                  Text(item.rssBrief ?? "", style: Get.textTheme.caption!.copyWith(fontSize: 12)),
                ],
              ),
            ),
            UCoreRssSubscribeButton(isSubscribe: item.isSubscribe == 0, onTap: onButtonTap)
          ],
        ),
      ),
    );
  }
}
