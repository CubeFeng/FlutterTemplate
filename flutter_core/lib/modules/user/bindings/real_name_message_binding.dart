import 'package:flutter_ucore/modules/user/controllers/real_name_message_controlller.dart';
import 'package:get/get.dart';

class RealNameMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RealNameMessageController());
  }
}
