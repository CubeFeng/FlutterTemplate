import 'package:flutter_ucore/models/news/rss_model.dart';

rssModelFromJson(RssModel data, Map<String, dynamic> json) {
  if (json['background'] != null) {
    data.background = json['background'].toString();
  }
  if (json['icon'] != null) {
    data.icon = json['icon'].toString();
  }
  if (json['isSubscribe'] != null) {
    data.isSubscribe = json['isSubscribe'] is String ? int.tryParse(json['isSubscribe']) : json['isSubscribe'].toInt();
  }
  if (json['rssBrief'] != null) {
    data.rssBrief = json['rssBrief'].toString();
  }
  if (json['rssId'] != null) {
    data.rssId = json['rssId'] is String ? int.tryParse(json['rssId']) : json['rssId'].toInt();
  }
  if (json['rssName'] != null) {
    data.rssName = json['rssName'].toString();
  }
  return data;
}

Map<String, dynamic> rssModelToJson(RssModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['background'] = entity.background;
  data['icon'] = entity.icon;
  data['isSubscribe'] = entity.isSubscribe;
  data['rssBrief'] = entity.rssBrief;
  data['rssId'] = entity.rssId;
  data['rssName'] = entity.rssName;
  return data;
}

pagedRssModelFromJson(PagedRssModel data, Map<String, dynamic> json) {
  if (json['current'] != null) {
    data.current = json['current'] is String ? int.tryParse(json['current']) : json['current'].toInt();
  }
  if (json['records'] != null) {
    data.records = (json['records'] as List).map((v) => RssModel().fromJson(v)).toList();
  }
  if (json['size'] != null) {
    data.size = json['size'] is String ? int.tryParse(json['size']) : json['size'].toInt();
  }
  if (json['total'] != null) {
    data.total = json['total'] is String ? int.tryParse(json['total']) : json['total'].toInt();
  }
  return data;
}

Map<String, dynamic> pagedRssModelToJson(PagedRssModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['current'] = entity.current;
  data['records'] = entity.records?.map((v) => v.toJson())?.toList();
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}
