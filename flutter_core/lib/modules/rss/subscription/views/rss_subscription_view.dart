import 'package:common_utils/common_utils.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/modules/rss/subscription/controllers/rss_subscription_controller.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_plus.dart';
import 'package:flutter_ucore/widgets/ucore_news_list_item_widget.dart';
import 'package:flutter_ucore/widgets/ucore_rss_subscribe_button.dart';

class RssSubscriptionView extends GetView<RssSubscriptionController> {
  const RssSubscriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scrollbar(
            child: GetBuilder<RssSubscriptionController>(
              autoRemove: false,
              builder: (controller) {
                return UCoreListViewPlus(
                  requireSafeArea: false,
                  controller: controller.listViewController,
                  enableRefresh: true,
                  enableLoadMore: !controller.newsList.isEmpty,
                  onRefresh: controller.onRefresh,
                  onLoading: controller.onLoading,
                  onWatchListViewScroll: controller.onWatchListViewScroll,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildHeader();
                    }
                    final news = controller.newsList[index - 1];
                    return InkWell(
                      onTap: () async {
                        final result = await await Get.toNamed(
                          Routes.NEWS,
                          arguments: news,
                        );
                        if (result != null && result is int) {
                          controller.removeNewsById(result);
                        }
                        controller.syncLocalSubscribeStatus();
                      },
                      child: UCoreNewsListItemWidget.content(
                        title: news.newsTitle ?? "",
                        source: news.rssName ?? "",
                        time: DateUtil.formatDate(news.time,
                            format: "yyyy.MM.dd"),
                        imageUrl: news.titleImg,
                        topping: index < 4
                            ? LoadAssetImage("home/icon_home_top")
                            : null,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Divider(indent: 16, endIndent: 16),
                  itemCount: controller.newsList.length + 1,
                );
              },
            ),
          ),
          _buildTopBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 279,
          child: LoadImage(
            controller.rss?.background ?? "rss/rss_default_bg",
            holderImg: 'rss/rss_default_bg',
          ),
        ),
        Container(
          width: double.infinity,
          height: 279,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [const Color(0x00FFFFFF), const Color(0xFFFFFFFF)],
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 111),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(62),
                    color: Colors.white),
                child: Center(
                  child: ClipOval(
                    child: LoadImage(
                      controller.rss?.icon ?? "",
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                controller.rss?.rssName ?? "",
                style: Get.textTheme.headline6!.copyWith(fontSize: 16),
              ),
              SizedBox(height: 16),
              Obx(() {
                return UCoreRssSubscribeButton(
                  isSubscribe: controller.rss?.isSubscribe == 0,
                  onTap: () => controller.toggleSubscribeState(),
                );
              })
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTopBar() {
    return Obx(() {
      return Container(
        padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
        height: 54 + ScreenUtil().statusBarHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(controller.topTarAlpha.value, 255, 255, 255),
          border: controller.topTarAlpha.value >= 200
              ? Border(
                  bottom: BorderSide(
                    width: 1,
                    color:
                        Get.isDarkMode ? Colours.dark_divider : Colours.divider,
                  ),
                )
              : Border(bottom: BorderSide(width: 1, color: Colors.transparent)),
        ),
        child: Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: SizedBox(
                  width: 53,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: LoadAssetImage("common/icon_arrow_left"),
                  ),
                ),
              ),
              Expanded(
                child: DefaultTextStyle(
                  style: Get.theme.textTheme.headline6!.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: Text(
                    controller.topTarAlpha.value >= 220
                        ? (controller.rss?.rssName ?? "")
                        : "",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: SizedBox(width: 53),
              ),
            ],
          ),
        ),
      );
    });
  }
}
