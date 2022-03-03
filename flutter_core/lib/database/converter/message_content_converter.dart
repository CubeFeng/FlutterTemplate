import 'package:floor/floor.dart';
import 'package:flutter_ucore/database/entity/entity.dart';

class MessageContentConverter extends TypeConverter<MessageContent, String> {
  @override
  MessageContent decode(String databaseValue) {
    return MessageContent.fromStr(databaseValue.replaceAll("\n", "\\n"));
  }

  @override
  String encode(MessageContent value) {
    return value.toJsonString();
  }
}
