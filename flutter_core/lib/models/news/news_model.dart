import 'package:flutter_ucore/generated/json/base/json_convert_content.dart';
import 'package:flutter_ucore/generated/json/base/json_field.dart';

class NewsItemModel with JsonConvert<NewsItemModel> {
  /// 资讯id
  int? id;

  /// 新闻从标题
  String? newsTitle;

  /// 新闻简要
  String? newsBriefly;

  /// 标题配图
  String? titleImg;

  /// 订阅源名称
  String? rssName;

  /// 时间
  DateTime? time;

  /// 资讯来源链接
  String? sourceUrl;

  /// 主题源id
  @JSONField(name: "soureId")
  int? sourceId;

  /// 是否订阅
  int? isSubscribe;
}

class PagedNewsItemModel with JsonConvert<PagedNewsItemModel> {
  /// 当前页
  int? current;

  /// 数据
  List<NewsItemModel>? records;

  /// 每页显示条数，默认 10
  int? size;

  /// 总数
  int? total;
}

class WithBgPagedNewsItemModel with JsonConvert<WithBgPagedNewsItemModel> {
  /// 背景图
  String? background;

  /// 分页数据
  PagedNewsItemModel? result;
}
