import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/modules/property/base_record_view.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

import '../controllers/coin_record_controller.dart';

///
// ignore: use_key_in_widget_constructors
class CoinRecordView extends BaseRecordView<CoinRecordController, Coin> {
  @override
  String getTitle(data) {
    return data.coinUnit!;
  }

  @override
  int getDecimals(Coin data) {
    return data.coinDecimals!;
  }

  @override
  String getAmount(Coin data) {
    return WalletService.service.getCoinBalance(data) + " " + data.coinUnit;
  }

  @override
  String getAmountCNY(Coin data) {
    return "≈" +
        LocalService.to.currencySymbol +
        "" +
        WalletService.service.getCoinBalanceCurrency(data).toStringAsFixed(2);
  }

  @override
  Widget getIconWidget(Coin data) {
    return WalletLoadAssetImage(data.getIcon());
  }

  @override
  onClick(Coin data) {
    return Get.toNamed(Routes.TRANSACTION, arguments: data);
  }
}
