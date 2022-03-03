import 'package:flutter_ucore/modules/login/controllers/face_input_controller.dart';
import 'package:get/get.dart';

class FaceInputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FaceInputController());
  }
}
