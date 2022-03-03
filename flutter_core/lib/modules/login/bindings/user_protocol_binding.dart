import 'package:flutter_ucore/modules/login/controllers/user_protocol_controller.dart';
import 'package:get/get.dart';

class UserProtocolBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserProtocolController());
  }
}
