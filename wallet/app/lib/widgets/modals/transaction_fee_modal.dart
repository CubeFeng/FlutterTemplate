import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/property/coin/transaction/custom_slider.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/theme/text_style.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

typedef ConfirmCallback = void Function(double fee);

/// 切换币种
class TransactionFeeModal extends StatelessWidget {
  final _controller = Get.put(_TransactionFeeController());
  final ConfirmCallback onConfirmCallback;
  final BigInt gasLimit;
  final String amount;

  TransactionFeeModal({
    Key? key,
    required this.onConfirmCallback,
    required this.gasLimit,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _controller.loadInitialData(gasLimit);
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: constraints.maxHeight * 0.5,
        child: GetBuilder<_TransactionFeeController>(
            init: _controller,
            builder: (controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    topRight: Radius.circular(15.r),
                  ),
                ),
                child: Column(
                  children: [
                    _buildTitle(),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Gaps.vGap18,
                              Gaps.vGap20,
                              Row(
                                children: [
                                  Text(
                                    '${controller.getCurrentGas()}',
                                    style: TextStyles.textSize14Bold,
                                  ),
                                  Text(
                                    '${controller.getCurrentGasCurrency()}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Color(0xFF999999)),
                                  ),
                                ],
                              ),
                              Gaps.vGap14,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      I18nKeys.slow,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF999999)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      controller.feePercent == 0.3
                                          ? I18nKeys.recommend
                                          : '',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF333333)),
                                    ),
                                  ),
                                  Text(
                                    I18nKeys.fast,
                                    style: const TextStyle(
                                        fontSize: 11, color: Color(0xFF999999)),
                                  ),
                                ],
                              ),
                              Gaps.vGap8,
                              CustomSlider(
                                controller.feePercent,
                                onChanged: (newValue) {
                                  controller.onProgressChange(newValue);
                                },
                              ),
                              Gaps.vGap50,
                              SizedBox(
                                width: 163,
                                height: 50,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color((0xFF2750EB))),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                  child: Text(
                                    I18nKeys.confirm,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    onConfirmCallback
                                        .call(controller.currentGas);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      );
    });
  }

  Widget _buildTitle() {
    return SizedBox(
      height: 51.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              I18nKeys.miningLaborFee,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: const Color(0xFF333333),
              ),
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.clear,
              color: Color(0xFF333333),
            ),
          )
        ],
      ),
    );
  }
}

class _TransactionFeeController extends GetxController {
  ///
  double feePercent = 0.3;

  //普通转账gasLimit
  BigInt gasLimit = BigInt.from(21000);
  BigInt gasPrice = BigInt.from(2000000000);
  double currentGas = 1;
  late Coin coinInfo;

  Future<void> loadInitialData(BigInt limit) async {
    feePercent = 0.3;
    coinInfo = WalletService.service.currentCoin!;
    gasPrice = await QiRpcService().getGasPrice();
    gasLimit = limit;
    update();
  }

  ///
  void onProgressChange(double val) {
    feePercent = val;
    update();
  }

  getCurrentGasCurrency() {
    double highGas = (gasPrice * BigInt.from(5)).toDouble();
    double lowGas = highGas / 100;
    currentGas = lowGas + (highGas - lowGas) * feePercent;
    if (currentGas < pow(10, coinInfo.coinDecimals! ~/ 2)) {
      currentGas = pow(10, coinInfo.coinDecimals! ~/ 2).toDouble();
    }
    double fee =
        currentGas * gasLimit.toDouble() / pow(10, coinInfo.coinDecimals!);

    double feeDollar =
        WalletService.service.getCurrencyBalance(fee, null, null);
    return "≈${LocalService.to.currencySymbol}" +
        feeDollar.toStringAsFixed(coinInfo.coinDecimals! ~/ 2) +
        "";
  }

  getCurrentGas() {
    double highGas = (gasPrice * BigInt.from(5)).toDouble();
    double lowGas = highGas / 100;
    currentGas = lowGas + (highGas - lowGas) * feePercent;
    if (currentGas < pow(10, coinInfo.coinDecimals! ~/ 2)) {
      currentGas = pow(10, coinInfo.coinDecimals! ~/ 2).toDouble();
    }

    double fee =
        currentGas * gasLimit.toDouble() / pow(10, coinInfo.coinDecimals!);

    return fee.toStringAsFixed(coinInfo.coinDecimals! ~/ 2) +
        "" +
        coinInfo.coinUnit!;
  }
}
