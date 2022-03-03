import 'package:flutter_ucore/generated/json/base/json_convert_content.dart';

class ReadAndRssNumModel with JsonConvert<ReadAndRssNumModel> {
  /// 阅读数
	int? readHistoryNum;
	/// 订阅数
	int? rssNum;
}
