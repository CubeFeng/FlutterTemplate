import 'package:flutter_ucore/modules/user/my_subscriptions/controllers/my_subscriptions_controller.dart';
import 'package:get/get.dart';

class MySubscriptionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MySubscriptionsController());
  }
}
