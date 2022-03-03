import 'package:flutter_ucore/models/news/read_and_rss_num_model.dart';

readAndRssNumModelFromJson(ReadAndRssNumModel data, Map<String, dynamic> json) {
  if (json['readHistoryNum'] != null) {
    data.readHistoryNum =
        json['readHistoryNum'] is String ? int.tryParse(json['readHistoryNum']) : json['readHistoryNum'].toInt();
  }
  if (json['rssNum'] != null) {
    data.rssNum = json['rssNum'] is String ? int.tryParse(json['rssNum']) : json['rssNum'].toInt();
  }
  return data;
}

Map<String, dynamic> readAndRssNumModelToJson(ReadAndRssNumModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['readHistoryNum'] = entity.readHistoryNum;
  data['rssNum'] = entity.rssNum;
  return data;
}
