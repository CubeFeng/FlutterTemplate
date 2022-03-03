import 'dart:math';

import 'package:flutter_wallet/modules/property/base_transaction_controller.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';

///
class CoinTransactionController extends BaseTransactionController {
  @override
  checkFeeError() {
    if (getCoinType() == QiCoinType.BTC) {
      gasLimitError.value = false;
      nonceError.value = false;

      if (gasPriceController.text.isEmpty) {
        gasPriceError.value = true;
      } else {
        double price = double.parse(gasPriceController.text);
        if (price < 0.0001 || price > 1) {
          gasPriceError.value = true;
        } else {
          gasPriceError.value = false;
        }
      }
      calculate();
      checkComplete(false);
    } else {
      super.checkFeeError();
    }
  }

  @override
  gasPriceErrorStr() {
    if (getCoinType() == QiCoinType.BTC) {
      if (gasPriceController.text.isEmpty) {
        return '只能输入≥0.0001的数字';
      }
      double? limit = double.tryParse(gasPriceController.text);
      if (limit != null && limit < 1) {
        return '只能输入≥0.0001的数字';
      } else {
        return '只能输入≤1的数字';
      }
    } else {
      return super.gasPriceErrorStr();
    }
  }

  @override
  Future<void> switchFeeMode() async {
    if (getCoinType() == QiCoinType.BTC) {
      gasLimitController.text = gasLimit.toString();
      nonceController.text = '1';
      feeModeCustom = !feeModeCustom;
      if (feeModeCustom) {
        gasPriceController.text = (currentGas / pow(10, 4)).toStringAsFixed(6);
      }
      checkComplete(true);
    } else {
      super.switchFeeMode();
    }
  }

  @override
  gasMath(double price, double limit, {custom = false}) {
    if (getCoinType() == QiCoinType.BTC) {
      return price * limit / pow(10, custom ? 0 : 4);
    } else {
      return super.gasMath(price, limit, custom: custom);
    }
  }

  @override
  gasMathCustom(double price, double limit, {custom = false}) {
    if (getCoinType() == QiCoinType.BTC) {
      return price * limit / pow(10, custom ? 0 : 4);
    } else {
      return super.gasMathCustom(price, limit, custom: custom);
    }
  }
}
