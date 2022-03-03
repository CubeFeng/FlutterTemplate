import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/services/wallet_connect_service.dart';

class WalletConnectHistoryController extends GetxController {
  @override
  Future<void> onReady() async {
    super.onReady();
    await WalletConnectService.service.loadService();
    update();
  }

}
