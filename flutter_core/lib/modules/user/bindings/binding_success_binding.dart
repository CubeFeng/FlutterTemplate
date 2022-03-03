import 'package:flutter_ucore/modules/user/controllers/binding_success_controller.dart';
import 'package:get/get.dart';

class BindingSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BindingSuccessController());
  }
}
