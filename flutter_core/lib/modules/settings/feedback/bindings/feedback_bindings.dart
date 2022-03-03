import 'package:flutter_ucore/modules/settings/feedback/controllers/feedback_controller.dart';
import 'package:get/get.dart';

class FeedbackBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FeedbackController());
  }
}
