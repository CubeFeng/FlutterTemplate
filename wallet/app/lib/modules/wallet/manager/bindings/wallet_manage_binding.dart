import 'package:flutter_wallet/modules/wallet/manager/controllers/wallet_manage_controller.dart';
import 'package:get/get.dart';

///
class WalletManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WalletManageController());
  }
}
