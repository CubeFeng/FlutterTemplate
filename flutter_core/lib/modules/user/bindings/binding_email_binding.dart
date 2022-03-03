import 'package:flutter_ucore/modules/user/controllers/binding_email_controller.dart';
import 'package:get/get.dart';

class BindingEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BindingEmailController());
  }
}
