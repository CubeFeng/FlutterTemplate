import 'package:flutter_wallet/modules/property/token/transaction/controllers/token_transaction_controller.dart';
import 'package:get/get.dart';

///
class TokenTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TokenTransactionController());
  }
}
