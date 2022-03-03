import 'package:flutter_wallet/modules/property/nft/record/controllers/nft_record_controller.dart';
import 'package:get/get.dart';

///
class NftRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NftRecordController());
  }
}
