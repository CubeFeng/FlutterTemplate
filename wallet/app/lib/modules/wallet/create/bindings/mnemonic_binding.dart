import 'package:flutter_wallet/modules/wallet/create/controllers/mnemonic_controller.dart';
import 'package:get/get.dart';

///
class MnemonicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MnemonicController());
  }
}
