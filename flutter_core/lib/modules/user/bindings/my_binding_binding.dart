import 'package:flutter_ucore/modules/user/controllers/my_binding_controller.dart';
import 'package:get/get.dart';

class MyBindingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyBindingController());
  }
}
