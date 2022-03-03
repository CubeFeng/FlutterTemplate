import 'package:flutter_ucore/modules/home/controllers/home_controller.dart';
import 'package:flutter_ucore/modules/home/controllers/home_news_list_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => HomeNewsListController());
  }
}
