import 'dart:async';

import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/database/entity/message_entity.dart';
import 'package:flutter_ucore/events/event.dart';
import 'package:flutter_ucore/events/message_event.dart';
import 'package:flutter_ucore/services/message_service.dart';

class MessageController extends GetxController {
  final messages = <MessageEntity>[].obs;

  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    messages.addAll(await MessageService.service.getMessageList());
    eventBus.on<OnReciveMessageEvent>().listen((event) {
      messages.insert(0, event.message);
    });
  }

  Future<void> setMessageIsRead(MessageEntity msg) async {
    int index = messages.indexOf(msg);
    msg.isRead = true;
    messages[index] = msg;
    await MessageService.service.updateMessag(msg);
  }

  Future<void> setAllMessageIsRead() async {
    if (messages.length == 0) {
      return;
    }
    final _messages = messages.toList();
    final allReadMessages = _messages.map((e) {
      e.isRead = true;
      return e;
    }).toList();
    messages.clear();
    messages.addAll(allReadMessages);

    /// TODO:: 可以优化一下
    for (var i = 0; i < allReadMessages.length; i++) {
      await MessageService.service.updateMessag(allReadMessages[i]);
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
