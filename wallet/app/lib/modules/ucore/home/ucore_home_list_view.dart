import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/models/ucore_newsitem_model.dart';
import 'package:flutter_wallet/modules/ucore/home/ucore_home_list_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/widgets/u_list_view.dart';
import 'package:common_utils/common_utils.dart';

class UCHomeListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child:GetBuilder<UCHomeNewsListController>(builder: (controller) {
          return UListView(
            controller: controller.reController,
            onLoading: controller.onLoading,
            onRefresh: controller.onRefresh,
            itemBuilder: (context,index){
              final UCNewsItemModel itemModel = controller.newsList[index];
              return InkWell(
                onTap: (){
                  Get.toNamed(Routes.DAPPS_Web_BANNER, parameters: {'url': itemModel.sourceUrl!});

                  // Get.toNamed(Routes.UCORE_RSS_NEWS, arguments: itemModel);
                },
                child: NewsListItemWidget(
                  title: itemModel.newsTitle ?? "",
                  source: itemModel.rssName ?? "",
                  time: DateUtil.formatDate(itemModel.time, format: "yyyy-MM-dd"),
                  image: itemModel.titleImg ?? "",
                ),
              );
            },
            itemCount: controller.newsList.length,
          );
        }),
    );
  }
}

class NewsListItemWidget extends StatelessWidget {
  final String title;
  final String source;
  final String time;
  final String image;

  const NewsListItemWidget(
      {Key? key,
      required this.title,
      required this.source,
      required this.time,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child:
          image.length > 0 ? _NewsImageItem(context) : _NewsNormalItem(context),
    );
  }

  Widget _NewsImageItem(BuildContext contenxt) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //left view
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //标题
              Text(
                title,
                style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(
                height: 26,
              ),

              //rss 源、发布时间
              Row(
                children: [
                  Baseline(
                      baseline: 11,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(source)),
                  SizedBox(width: 16),
                  Baseline(
                      baseline: 11,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(time))
                ],
              ),
            ],
          ),
        ),

        Container(
          height: 85,
          width: 120,
          margin: EdgeInsets.only(left: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LoadImage(image),
          ),
        )
      ],
    );
  }

  Widget _NewsNormalItem(BuildContext contenxt) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //left view
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //标题
              Text(
                title,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(
                height: 26,
              ),

              //rss 源、发布时间
              Row(
                children: [
                  Baseline(
                      baseline: 11,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(source)),
                  SizedBox(width: 16),
                  Baseline(
                      baseline: 11,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(time))
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
