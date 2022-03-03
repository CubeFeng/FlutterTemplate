import 'package:flutter_ucore/modules/rss/subscription/controllers/rss_subscription_controller.dart';
import 'package:get/get.dart';

class RssSubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RssSubscriptionController());
  }
}
