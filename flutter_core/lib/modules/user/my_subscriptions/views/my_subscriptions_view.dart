import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/my_subscriptions/controllers/my_subscriptions_controller.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_plus.dart';
import 'package:flutter_ucore/widgets/ucore_rss_list_item_widget.dart';

class MySubscriptionsView extends StatelessWidget {
  const MySubscriptionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UCoreAppBar(
        title: Text(I18nKeys.subscribe_topic),
      ),
      body: Scrollbar(
        child: GetBuilder<MySubscriptionsController>(
          id: MySubscriptionsController.RSS_LIST_ID,
          autoRemove: false,
          builder: (controller) {
            return UCoreListViewPlus(
              controller: controller.listViewController,
              onRefresh: controller.onRefresh,
              onLoading: controller.onLoading,
              enableRefresh: true,
              enableLoadMore: !controller.rssList.isEmpty,
              itemBuilder: (context, index) {
                final rss = controller.rssList[index];
                rss.isSubscribe =
                    LocalService.to.subscribedRssIds.contains(rss.rssId)
                        ? 1
                        : 0;
                return UCoreRssListItemWidget(
                  item: rss,
                  onItemTap: () async {
                    await Get.toNamed(Routes.RSS_SUBSCRIPTION, arguments: rss);
                    controller.requestUpdateList();
                  },
                  onButtonTap: () async =>
                      await controller.toggleSubscribeState(rss),
                );
              },
              separatorBuilder: (context, index) =>
                  Divider(indent: 16, endIndent: 16),
              itemCount: controller.rssList.length,
            );
          },
        ),
      ),
    );
  }
}
