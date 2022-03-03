import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()
class UCNewsItemModel {
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
  int? sourceId;

  /// 是否订阅
  int? isSubscribe;
}
