import 'package:flutter_ucore/modules/user/read_history/controllers/read_history_controller.dart';
import 'package:get/get.dart';

class ReadHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReadHistoryController());
  }
}
