import 'package:flutter_ucore/modules/user/controllers/authentication_result_controller.dart';
import 'package:get/get.dart';

class AuthenticationResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthenticationResultController());
  }
}
