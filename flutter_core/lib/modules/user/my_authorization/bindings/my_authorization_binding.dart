import 'package:flutter_ucore/modules/user/my_authorization/controllers/my_authorization_controller.dart';
import 'package:get/get.dart';

class MyAuthorizationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyAuthorizationController());
  }
}
