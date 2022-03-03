import 'package:flutter_wallet/modules/wallet/export/controllers/wallet_export_controller.dart';
import 'package:get/get.dart';

///
class WalletExportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WalletExportController());
  }
}
