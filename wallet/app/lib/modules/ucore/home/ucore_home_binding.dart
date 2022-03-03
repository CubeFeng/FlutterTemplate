import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/modules/ucore/home/ucore_home_controller.dart';

class UCHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UCHomePageController>(() => UCHomePageController());
  }
}
