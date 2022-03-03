import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/modules/home/controllers/home_news_list_controller.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_plus.dart';
import 'package:flutter_ucore/widgets/ucore_news_list_item_widget.dart';

class HomeNewsListView extends GetView<HomeNewsListController> {
  const HomeNewsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: GetBuilder<HomeNewsListController>(
        id: HomeNewsListController.NEWS_LIST_ID,
        builder: (controller) {
          return UCoreListViewPlus(
              controller: controller.listViewController,
              onRefresh: controller.onRefresh,
              onLoading: controller.onLoading,
              enableRefresh: true,
              enableLoadMore: !controller.newsList.isEmpty,
              itemBuilder: (context, index) {
                final news = controller.newsList[index];
                return InkWell(
                  onTap: () => Get.toNamed(Routes.NEWS, arguments: news),
                  child: UCoreNewsListItemWidget.content(
                    title: news.newsTitle ?? "",
                    source: news.rssName ?? "",
                    time: DateUtil.formatDate(news.time, format: "yyyy.MM.dd"),
                    imageUrl: news.titleImg,
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(indent: 16, endIndent: 16),
              itemCount: controller.newsList.length);
        },
      ),
    );
  }
}
