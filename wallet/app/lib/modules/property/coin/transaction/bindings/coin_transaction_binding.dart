import 'package:flutter_wallet/modules/property/coin/transaction/controllers/coin_transaction_controller.dart';
import 'package:get/get.dart';

///
class CoinTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CoinTransactionController());
  }
}
