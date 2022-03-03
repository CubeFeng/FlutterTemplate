import 'package:flutter_wallet/modules/wallet/hardware/network/controllers/hd_wallet_network_controller.dart';
import 'package:get/get.dart';

///
class HDWalletNetworkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HDWalletNetworkController());
  }
}
