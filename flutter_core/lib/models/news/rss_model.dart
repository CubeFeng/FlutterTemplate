import 'package:flutter_ucore/generated/json/base/json_convert_content.dart';

class RssModel with JsonConvert<RssModel> {
  /// 背景图
  String? background;

  /// 订阅源图标
  String? icon;

  /// 是否被订阅
  int? isSubscribe;

  /// 订阅源简介
  String? rssBrief;

  /// 订阅源id
  int? rssId;

  /// 订阅源名称
  String? rssName;
}

class PagedRssModel with JsonConvert<PagedRssModel> {
  /// 当前页
  int? current;

  /// 数据
  List<RssModel>? records;

  /// 每页显示条数，默认 10
  int? size;

  /// 总数
  int? total;
}
