import 'package:flutter_ucore/modules/user/controllers/user_center_controller.dart';
import 'package:get/get.dart';

class UserCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserCenterController());
  }
}
