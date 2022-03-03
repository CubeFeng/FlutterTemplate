import 'package:flutter_ucore/modules/rss/center/controllers/rss_center_controller.dart';
import 'package:get/get.dart';

class RssCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RssCenterController());
  }
}
