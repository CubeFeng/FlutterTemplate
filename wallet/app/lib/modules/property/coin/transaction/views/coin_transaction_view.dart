import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_base_kit/theme/gaps.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/property/base_transaction_view.dart';
import 'package:flutter_wallet/modules/property/coin/transaction/controllers/coin_transaction_controller.dart';
import 'package:flutter_wallet/theme/text_style.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';

import '../input_format.dart';

///
class CoinTransactionView
    extends BaseTransactionView<CoinTransactionController> {
  const CoinTransactionView({Key? key}) : super(key: key);

  @override
  Widget feeSimple() {
    if (controller.getCoinType() == QiCoinType.SOL) {
      return Padding(
        padding: EdgeInsets.all(15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  I18nKeys.miningLaborFee,
                  style: TextStyles.textSize14Bold,
                ),
              ],
            ),
            Gaps.vGap20,
            Obx(() => Row(
                  children: [
                    Text(
                      controller.gasValue.value,
                      style: TextStyles.textSize14Bold,
                    ),
                    Text(
                      controller.gasValueCurrency.value,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ],
                )),
            Gaps.vGap20,
          ],
        ),
      );
    }
    return super.feeSimple();
  }

  @override
  Widget feeCustom() {
    if (controller.getCoinType() == QiCoinType.BTC) {
      return Padding(
        padding: EdgeInsets.all(15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  I18nKeys.miningLaborFee,
                  style: TextStyles.textSize14Bold,
                ),
                InkWell(
                  onTap: () {
                    controller.switchFeeMode();
                  },
                  child: Text(
                    controller.feeModeCustom
                        ? I18nKeys.easyMode
                        : I18nKeys.expertMode,
                    style:
                        const TextStyle(fontSize: 11, color: Color(0xFF384a8b)),
                  ),
                ),
              ],
            ),
            Gaps.vGap20,
            Obx(() => Row(
                  children: [
                    Text(
                      controller.gasValue.value,
                      style: TextStyles.textSize14Bold,
                    ),
                    Text(
                      controller.gasValueCurrency.value,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ],
                )),
            Gaps.vGap20,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'FeeRate字节价格',
                    style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: 160,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp("[0-9.]"),
                                allow: true),
                            NumberTextInputFormatter(digit: 6),
                          ],
                          textAlign: TextAlign.center,
                          controller: controller.gasPriceController,
                          focusNode: controller.focusNodeGasPrice,
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF333333)),
                          obscureText: false,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => controller.gasPriceError.isFalse
                          ? const SizedBox(
                              height: 14,
                            )
                          : Text(
                              controller.gasPriceErrorStr(),
                              style: const TextStyle(
                                  fontSize: 10, color: Color(0xFFEE4949)),
                            ),
                    )
                  ],
                ),
              ],
            ),
            Gaps.vGap34,
            Text(
              '字节长度=148 * 输入数量 + 34 * 输出数量 + 10 \n若长度小于10000字节，那么这笔交易最终被确认为免费，反之需收费\n费用默认为0.0001BTC/千字节（不足1k的按1k计算）',
              style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
            ),
          ],
        ),
      );
    }
    return super.feeCustom();
  }
}
