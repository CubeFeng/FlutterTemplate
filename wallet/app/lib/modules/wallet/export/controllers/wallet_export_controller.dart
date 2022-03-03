import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/wallet/create/controllers/wallet_create_controller.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

// ignore: constant_identifier_names
enum WalletExportMode { Keystore, PrivateKey, Mnemonic }

class WalletExportArgs {
  final WalletExportMode mode;
  final Coin coin;
  final String password;

  const WalletExportArgs({
    required this.mode,
    required this.coin,
    required this.password,
  });
}

class WalletExportController extends GetxController
    with SingleGetTickerProviderMixin {
  late final WalletExportArgs args = Get.arguments as WalletExportArgs;
  final _title = ''.obs;
  final _tabs = <String>[].obs;
  final _value = ''.obs;
  final _showOrHideQrCode = false.obs;

  String get title => _title.value;

  List<String> get tabs => _tabs;

  String get value => _value.value;

  bool get showOrHideQrCode => _showOrHideQrCode.value;

  late TabController tabController;

  void switchShowOrHideQrCode() {
    _showOrHideQrCode.value = !_showOrHideQrCode.value;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    final coin = args.coin;
    switch (args.mode) {
      case WalletExportMode.Keystore:
        _tabs.value = ['Keystore', I18nKeys.qrCode];
        _title.value = '${I18nKeys.export} ${coin.coinType ?? ' '} Keystore';
        break;
      case WalletExportMode.PrivateKey:
        _tabs.value = [I18nKeys.privateKey, I18nKeys.qrCode];
        _title.value =
            '${I18nKeys.export} ${coin.coinType ?? ''} ${I18nKeys.privateKey}';
        break;
      case WalletExportMode.Mnemonic:
        _tabs.value = [I18nKeys.auxiliaryWord, I18nKeys.qrCode];
        _title.value =
            '${I18nKeys.export} ${coin.coinType ?? ''} ${I18nKeys.auxiliaryWord}';
        break;
    }
    tabController = TabController(length: tabs.length, vsync: this);
    switch (args.mode) {
      case WalletExportMode.Keystore:
        _value.value = await qiGenerateKeystore(
          password: Get.parameters['password']!,
          privateKey: WalletCreateController.decrypt(
              coin.privateKey ?? '', args.password),
        );
        break;
      case WalletExportMode.PrivateKey:
        String key = WalletCreateController.decrypt(
            coin.privateKey ?? '', args.password);
        if(coin.coinUnit != 'SOL'){
          if (key.startsWith('00')) {
            key = key.replaceFirst('00', '0x');
          }
          if (!key.startsWith('0x')) {
            key = '0x' + key;
          }
        }
        _value.value = key;
        break;
      case WalletExportMode.Mnemonic:
        final wallet = await DBService.to.walletDao.findById(coin.walletId!);
        _value.value = WalletCreateController.decrypt(
            wallet?.mnemonic ?? '', args.password);
        break;
    }
  }
}
