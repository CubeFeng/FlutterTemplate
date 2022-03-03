import 'package:flutter/cupertino.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/modules/property/base_record_view.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

import '../controllers/token_record_controller.dart';

///
// ignore: use_key_in_widget_constructors
class TokenRecordView extends BaseRecordView<TokenRecordController, Token> {
  @override
  String getTitle(Token data) {
    return data.tokenUnit!;
  }

  @override
  String getIconUrl(Token data) {
    return data.tokenIcon??'';
  }

  @override
  String getAmount(Token data) {
    return WalletService.service.getTokenBalance(data) + " " + data.tokenUnit;
  }

  @override
  String getAmountCNY(Token data) {
    return "≈" +
        LocalService.to.currencySymbol +
        "" +
        WalletService.service.getTokenCurrencyBalance(data).toStringAsFixed(2);
  }

  @override
  Widget getIconWidget(Token data) {
    return WalletLoadImage(data.tokenIcon!);
  }

  @override
  onClick(Token data) {
    return Get.toNamed(Routes.TOKEN_TRANSACTION, arguments: data);
    //return Get.toNamed(Routes.TOKEN_TRANSACTION, arguments: data);
  }

  @override
  int getDecimals(Token data) {
    return data.tokenDecimals!;
  }
}
