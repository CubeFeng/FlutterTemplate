import 'package:flutter_ucore/modules/user/controllers/set_nickname_controller.dart';
import 'package:get/get.dart';

class SetNicknameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetNicknameController());
  }
}
