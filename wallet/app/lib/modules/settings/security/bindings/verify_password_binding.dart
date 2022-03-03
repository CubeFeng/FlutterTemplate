import 'package:flutter_wallet/modules/settings/security/controller/verify_password_controller.dart';
import 'package:get/get.dart';

class VerifyPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerifyPasswordController());
  }
}
