import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/read_history/controllers/read_history_controller.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_plus.dart';
import 'package:flutter_ucore/widgets/ucore_news_list_item_widget.dart';

class ReadHistoryView extends StatelessWidget {
  const ReadHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UCoreAppBar(
        title: Text(I18nKeys.check_history),
      ),
      body: Scrollbar(
        child: GetBuilder<ReadHistoryController>(
          id: ReadHistoryController.NEWS_LIST_ID,
          autoRemove: false,
          builder: (controller) {
            return UCoreListViewPlus(
              controller: controller.refreshController,
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
              itemCount: controller.newsList.length,
            );
          },
        ),
      ),
    );
  }
}
