import 'package:flutter_ucore/modules/oauth2/controllers/oauth2_controller.dart';
import 'package:get/get.dart';

class OAuth2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OAuth2Controller(), fenix: true);
  }
}
