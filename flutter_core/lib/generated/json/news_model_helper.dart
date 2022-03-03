import 'package:flutter_ucore/models/news/news_model.dart';

newsItemModelFromJson(NewsItemModel data, Map<String, dynamic> json) {
  if (json['id'] != null) {
    data.id = json['id'] is String ? int.tryParse(json['id']) : json['id'].toInt();
  }
  if (json['newsTitle'] != null) {
    data.newsTitle = json['newsTitle'].toString();
  }
  if (json['newsBriefly'] != null) {
    data.newsBriefly = json['newsBriefly'].toString();
  }
  if (json['titleImg'] != null) {
    data.titleImg = json['titleImg'].toString();
  }
  if (json['rssName'] != null) {
    data.rssName = json['rssName'].toString();
  }
  if (json['time'] != null) {
    data.time = DateTime.parse(json['time']);
  }
  if (json['sourceUrl'] != null) {
    data.sourceUrl = json['sourceUrl'].toString();
  }
  if (json['soureId'] != null) {
    data.sourceId = json['soureId'] is String ? int.tryParse(json['soureId']) : json['soureId'].toInt();
  }
  if (json['isSubscribe'] != null) {
    data.isSubscribe = json['isSubscribe'] is String ? int.tryParse(json['isSubscribe']) : json['isSubscribe'].toInt();
  }
  return data;
}

Map<String, dynamic> newsItemModelToJson(NewsItemModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['newsTitle'] = entity.newsTitle;
  data['newsBriefly'] = entity.newsBriefly;
  data['titleImg'] = entity.titleImg;
  data['rssName'] = entity.rssName;
  data['time'] = entity.time;
  data['sourceUrl'] = entity.sourceUrl;
  data['soureId'] = entity.sourceId;
  data['isSubscribe'] = entity.isSubscribe;
  return data;
}

pagedNewsItemModelFromJson(PagedNewsItemModel data, Map<String, dynamic> json) {
  if (json['current'] != null) {
    data.current = json['current'] is String ? int.tryParse(json['current']) : json['current'].toInt();
  }
  if (json['records'] != null) {
    data.records = (json['records'] as List).map((v) => NewsItemModel().fromJson(v)).toList();
  }
  if (json['size'] != null) {
    data.size = json['size'] is String ? int.tryParse(json['size']) : json['size'].toInt();
  }
  if (json['total'] != null) {
    data.total = json['total'] is String ? int.tryParse(json['total']) : json['total'].toInt();
  }
  return data;
}

Map<String, dynamic> pagedNewsItemModelToJson(PagedNewsItemModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['current'] = entity.current;
  data['records'] = entity.records?.map((v) => v.toJson())?.toList();
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

withBgPagedNewsItemModelFromJson(WithBgPagedNewsItemModel data, Map<String, dynamic> json) {
  if (json['background'] != null) {
    data.background = json['background'].toString();
  }
  if (json['result'] != null) {
    data.result = PagedNewsItemModel().fromJson(json['result']);
  }
  return data;
}

Map<String, dynamic> withBgPagedNewsItemModelToJson(WithBgPagedNewsItemModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['background'] = entity.background;
  data['result'] = entity.result?.toJson();
  return data;
}
