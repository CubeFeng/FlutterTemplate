import 'package:flutter_wallet/modules/wallet/hardware/manage/controllers/hd_wallet_manage_controller.dart';
import 'package:get/get.dart';

///
class HDWalletManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HDWalletManageController());
  }
}
