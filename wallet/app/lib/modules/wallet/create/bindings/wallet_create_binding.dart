import 'package:flutter_wallet/modules/wallet/create/controllers/wallet_create_controller.dart';
import 'package:get/get.dart';

///
class WalletCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WalletCreateController());
  }
}
