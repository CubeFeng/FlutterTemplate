import 'package:flutter_ucore/modules/login/controllers/reset_password_controller.dart';
import 'package:get/get.dart';

class RestPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPasswordController());
  }
}
