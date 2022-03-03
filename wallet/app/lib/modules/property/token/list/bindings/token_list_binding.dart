import 'package:flutter_wallet/modules/property/token/list/controllers/token_list_controller.dart';
import 'package:get/get.dart';

///
class TokenListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TokenListController());
  }
}
