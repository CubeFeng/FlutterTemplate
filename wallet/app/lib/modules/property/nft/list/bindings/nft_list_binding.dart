import 'package:flutter_wallet/modules/property/nft/list/controllers/nft_list_controller.dart';
import 'package:get/get.dart';

///
class NftListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NftListController());
  }
}
