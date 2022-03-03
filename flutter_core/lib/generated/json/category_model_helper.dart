import 'package:flutter_ucore/models/news/category_model.dart';

categoryModelFromJson(CategoryModel data, Map<String, dynamic> json) {
  if (json['id'] != null) {
    data.id = json['id'] is String ? int.tryParse(json['id']) : json['id'].toInt();
  }
  if (json['categoryName'] != null) {
    data.categoryName = json['categoryName'].toString();
  }
  return data;
}

Map<String, dynamic> categoryModelToJson(CategoryModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['categoryName'] = entity.categoryName;
  return data;
}
