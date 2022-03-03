import 'package:flutter_ucore/modules/settings/help_center/controllers/help_center_controller.dart';
import 'package:get/get.dart';

class HelpCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpCenterController());
  }
}
