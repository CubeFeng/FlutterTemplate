import 'package:flutter_wallet/modules/wallet/import/controllers/wallet_import_controller.dart';
import 'package:get/get.dart';

///
class WalletImportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WalletImportController());
  }
}
