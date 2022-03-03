import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
// import 'package:get/get.dart';

class UCoreNewsListItemWidget extends StatelessWidget {
  final Widget title;
  final Widget? topping;
  final Widget sourceAndTime;
  final Widget? image;

  static UCoreNewsListItemWidget content({
    String? title,
    String? source,
    String? time,
    String? imageUrl,
    Widget? topping,
  }) {
    return UCoreNewsListItemWidget._(
      title: Text(title ?? ""),
      sourceAndTime: Text((source ?? "") + "    " + (time ?? "")),
      image: imageUrl != null ? LoadImage(imageUrl) : null,
      topping: topping,
    );
  }

  const UCoreNewsListItemWidget._({
    Key? key,
    required this.title,
    required this.sourceAndTime,
    this.topping,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image != null ? _buildWithImage(context) : _buildWithoutImage(context);
  }

  Widget _buildWithImage(BuildContext context) {
    return SizedBox(
      height: 116,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  _buildTitle(),
                  // 订阅源和时间
                  _buildSourceAndTime(),
                ],
              ),
            ),
            // 配图
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: SizedBox(width: 128.sp, height: 86.sp, child: image),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWithoutImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          _buildTitle(),
          SizedBox(height: 26),
          // 订阅源和时间
          _buildSourceAndTime(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return DefaultTextStyle(
      style: Get.theme.textTheme.bodyText1!.copyWith(fontSize: 14),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      child: title,
    );
  }

  Widget _buildSourceAndTime() {
    return DefaultTextStyle(
      style: Get.theme.textTheme.caption!.copyWith(fontSize: 11),
      maxLines: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          topping == null
              ? Container()
              : SizedBox(
                  width: 30,
                  height: 22,
                  child: SizedBox(width: 22, height: 22, child: topping),
                ),
          Expanded(child: sourceAndTime),
        ],
      ),
    );
  }
}
