import 'package:flutter_wallet/modules/property/token/record/controllers/token_record_controller.dart';
import 'package:get/get.dart';

///
class TokenRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TokenRecordController());
  }
}
