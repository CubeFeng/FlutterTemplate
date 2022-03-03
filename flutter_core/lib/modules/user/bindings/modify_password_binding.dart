import 'package:flutter_ucore/modules/user/controllers/modify_password_controller.dart';
import 'package:get/get.dart';

class ModifyPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ModifyPasswordController());
  }
}
