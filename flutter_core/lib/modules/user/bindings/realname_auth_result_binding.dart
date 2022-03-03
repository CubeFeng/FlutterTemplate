import 'package:flutter_ucore/modules/user/controllers/realname_auth_result_controller.dart';
import 'package:get/get.dart';

class RealNameAuthResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RealnameAuthResultController());
  }
}
