import 'package:flutter_ucore/modules/login/controllers/face_login_controller.dart';
import 'package:get/get.dart';

class FaceLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FaceLoginController());
  }
}
