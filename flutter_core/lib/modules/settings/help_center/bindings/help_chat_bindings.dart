import 'package:flutter_ucore/modules/settings/help_center/controllers/help_chat_controller.dart';
import 'package:get/get.dart';

class HelpChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpChatController());
  }
}
