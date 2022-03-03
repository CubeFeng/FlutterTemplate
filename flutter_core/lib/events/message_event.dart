import 'package:flutter_ucore/database/entity/message_entity.dart';
import 'package:flutter/foundation.dart';

@immutable
class OnReciveMessageEvent {
  final MessageEntity message;

  const OnReciveMessageEvent(this.message);
}
