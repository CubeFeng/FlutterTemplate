import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/modules/dapps/connect/controllers/wallet_connect_history_controller.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/wallet_connect_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

class WalletConnectDetailController extends GetxController {
  final String connectUrl = Get.parameters["connectUrl"] ?? "";

  ConnectService connectService = ConnectService();
  Wallet? wallet;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    connectService = WalletConnectService.service.qrScanHandler(connectUrl);
    if(connectService.coin != null){
      await WalletService.service.refreshCoinBalance([connectService.coin!]);
      wallet = await DBService.service.walletDao
          .findById(connectService.coin!.walletId!);
    }

    connectService.setListener(() {
      update();
    });

    update();
  }

  @override
  void onClose() {
    super.onClose();
    connectService.setListener(() => null);
  }

}
