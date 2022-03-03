import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/modules/ucore/home/ucore_home_list_controller.dart';

class UCHomePageController extends GetxController{


  void onInit() {
    super.onInit();

    Get.put(UCHomeNewsListController());
  }

}
