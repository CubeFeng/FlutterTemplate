import 'package:flutter_wallet/modules/property/nft/transaction/controllers/nft_transaction_controller.dart';
import 'package:get/get.dart';

///
class NftTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NftTransactionController());
  }
}
