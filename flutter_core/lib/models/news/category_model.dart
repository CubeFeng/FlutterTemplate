import 'package:flutter_ucore/generated/json/base/json_convert_content.dart';

class CategoryModel with JsonConvert<CategoryModel> {
  /// 分类ID
  int? id;

  /// 分类名
  String? categoryName;
}
