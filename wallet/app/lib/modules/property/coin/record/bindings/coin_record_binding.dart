import 'package:flutter_wallet/modules/property/coin/record/controllers/coin_record_controller.dart';
import 'package:get/get.dart';

///
class CoinRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CoinRecordController());
  }
}
