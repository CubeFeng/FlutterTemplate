import 'package:flutter_wallet/modules/settings/security/controller/setup_password_controller.dart';
import 'package:get/get.dart';

class SetupPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetupPasswordController());
  }
}
