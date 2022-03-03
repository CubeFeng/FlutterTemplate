import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/property/edit_text_field.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/security_service.dart';
import 'package:flutter_wallet/theme/decorate_style.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/theme/text_style.dart';
import 'package:flutter_wallet/utils/app_utils.dart';
import 'package:flutter_wallet/widgets/modals/switch_coin_modal.dart';
import 'package:flutter_wallet/widgets/modals/transaction_confirm_modal.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

import 'base_transaction_controller.dart';
import 'coin/transaction/custom_slider.dart';
import 'coin/transaction/input_format.dart';

///
class BaseTransactionView<C extends BaseTransactionController>
    extends GetView<C> {
  const BaseTransactionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<C>(
      builder: (controller) {
        return Scaffold(
          appBar: QiAppBar(
            title: Text(controller.getTitle()),
            action: GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(
                    right: 18.sp, top: 10.sp, bottom: 10.sp, left: 18.sp),
                child: const WalletLoadAssetImage('common/scan_qrcode', width: 22, height: 22,),
              ),
              onTap: () async {
                AppUtils.hideKeyboard();
                // 扫码
                final result = await Get.toNamed(Routes.SCAN_CODE);
                controller.scanAddress(result);
              },
            ),
          ),
          body: Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // 触摸收起键盘
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView(
                    children: [
                      Gaps.vGap16,
                      Stack(
                        children: [
                          Container(
                            height: 98.h,
                            decoration: controller.focusNodeAddress.hasFocus
                                ? DecorateStyles.decoration15_line
                                : DecorateStyles.decoration15,
                          ),
                          SizedBox(
                            height: 98.h,
                            child: Padding(
                              padding: EdgeInsets.all(15.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    I18nKeys.transferTo,
                                    style: TextStyles.textBold14,
                                  ),
                                  EditTextField(
                                    labelText:
                                        I18nKeys.pleaseEnterTheTransferAddress,
                                    line: 2,
                                    controller: controller.addressController,
                                    focusNode: controller.focusNodeAddress,
                                    style: const TextStyle(
                                        fontSize: 14, color: Color(0xFF333333)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gaps.vGap16,
                      buildAmountWidget(),
                      Gaps.vGap16,
                      Stack(
                        children: [
                          Container(
                            height: controller.feeModeCustom ? 320 : 150,
                            decoration: controller.focusFee
                                ? DecorateStyles.decoration15_line
                                : DecorateStyles.decoration15,
                          ),
                          controller.feeModeCustom
                              ? feeCustom()
                              : feeSimple(),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 130,
                          height: 50,
                          child: UniButton(
                            child: Text(I18nKeys.transfer),
                            onPressed: controller.inputNotComplete
                                ? null
                                : () {
                                    if (controller.checkRight()) {
                                      Get.bottomSheet(
                                        TransactionConfirmModal(
                                          onConfirmCallback: () async {
                                            Get.back();
                                            final isOpenBiometryPay =
                                                await SecurityService
                                                    .to.isOpenBiometryPay;
                                            UniModals
                                                .showVerifySecurityPasswordModal(
                                              onSuccess: () {},
                                              onPasswordGet: (password) {
                                                controller.executeTransaction(
                                                    password);
                                              },
                                              passwordAuthOnly: !isOpenBiometryPay,
                                              switchPasswordAuto: !isOpenBiometryPay,
                                            );
                                          },
                                          amount: controller.getAmountConfirm(),
                                          amountCurrency: controller
                                              .getAmountCurrencyConfirm(),
                                          address:
                                              controller.getAddressConfirm(),
                                        ),
                                        isScrollControlled: true,
                                      );
                                    }
                                  },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              controller.showClipboardPopWindow
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 110, left: 15, right: 15),
                      child: InkWell(
                        onTap: () {
                          controller.selectClipboard();
                        },
                        child: Container(
                          decoration: DecorateStyles.decoration15,
                          padding: const EdgeInsets.all(15),
                          height: 99,
                          child: Row(
                            crossAxisAlignment : CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      I18nKeys.clipboard,
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: const Color(0xFF999999)),
                                    ),
                                    Gaps.vGap5,
                                    Text(
                                      controller.clipboardAddress,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: const Color(0xFF333333)),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.closeAddressTip();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 18, right: 15, top: 8, bottom: 38),
                                  child: WalletLoadAssetImage(
                                    'property/icon_arrow_up',
                                    width: 18,
                                    height: 18,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : controller.showAddressPopWindow
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 110, left: 15, right: 15),
                          child: ListView(
                            children: [
                              Container(
                                decoration: DecorateStyles.decoration15,
                                padding: const EdgeInsets.all(15),
                                child: Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          controller.addressUsedList.isNotEmpty
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(I18nKeys.recentlyUsed,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xFF999999))),
                                                    Gaps.vGap5,
                                                    Column(
                                                      children: controller
                                                          .addressUsedList
                                                          .map((e) {
                                                        return InkWell(
                                                          onTap: () {
                                                            controller
                                                                .selectAddress(e
                                                                    .toAddress!);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 15),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                    width: 268,
                                                                    child: Text(
                                                                      e.toAddress!,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Color(0xFF333333)),
                                                                    )),
                                                                Text(
                                                                  '${e.txTime!.month} - ${e.txTime!.day} ',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Color(
                                                                          0xFF999999)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                    Gaps.line,
                                                  ],
                                                )
                                              : Container(),
                                          controller.addressList.isNotEmpty
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: controller
                                                      .addressList
                                                      .map((e) {
                                                    return InkWell(
                                                      onTap: () {
                                                        controller
                                                            .selectAddress(
                                                                e.coinAddress!);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 268,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          15,
                                                                      top: 15),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    e.name!,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Color(
                                                                            0xFF999999)),
                                                                  ),
                                                                  Gaps.vGap5,
                                                                  Text(
                                                                    e.coinAddress!,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Color(
                                                                            0xFF333333)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          WalletLoadAssetImage(
                                                            'property/icon_address',
                                                            width: 14.w,
                                                            height: 14.h,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.closeAddressTip();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(left: 18, right: 15, top: 8, bottom: 38),
                                          child: WalletLoadAssetImage(
                                            'property/icon_arrow_up',
                                            width: 18,
                                            height: 18,
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        )
                      : Container()
            ],
          ),
        );
      },
      init: controller,
    );
  }

  Widget feeSimple() {
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
          Row(
            children: [
              Text(
                '${controller.getCurrentGas()}',
                style: TextStyles.textSize14Bold,
              ),
              Text(
                '${controller.getCurrentGasCurrency()}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
            ],
          ),
          Gaps.vGap14,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  I18nKeys.slow,
                  style:
                      const TextStyle(fontSize: 11, color: Color(0xFF999999)),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  controller.feePercent == 0.3 ? I18nKeys.recommend : '',
                  style:
                      const TextStyle(fontSize: 11, color: Color(0xFF333333)),
                ),
              ),
              Text(
                I18nKeys.fast,
                style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
              ),
            ],
          ),
          Gaps.vGap8,
          CustomSlider(
            controller.feePercent,
            onChangeStart: () {
              controller.onProgressStart();
            },
            onChangeEnd: () {
              controller.onProgressEnd();
            },
            onChanged: (newValue) {
              controller.onProgressChange(newValue);
            },
          ),
        ],
      ),
    );
  }

  Widget feeCustom() {
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
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                ],
              )),
          Gaps.vGap20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${I18nKeys.gasPrice}(Gwei)',
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF333333)),
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
                          NumberTextInputFormatter(digit: 2),
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
          Gaps.vGap5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  I18nKeys.gasLimit,
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF333333)),
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
                        ],
                        textAlign: TextAlign.center,
                        controller: controller.gasLimitController,
                        focusNode: controller.focusNodeGasLimit,
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
                    () => controller.gasLimitError.isFalse
                        ? const SizedBox(
                            height: 14,
                          )
                        : Text(
                            controller.gasLimitErrorStr(),
                            style: const TextStyle(
                                fontSize: 10, color: Color(0xFFEE4949)),
                          ),
                  )
                ],
              ),
            ],
          ),
          Gaps.vGap5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Nonce',
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
                          FilteringTextInputFormatter(RegExp("[0-9]"),
                              allow: true),
                        ],
                        textAlign: TextAlign.center,
                        controller: controller.nonceController,
                        focusNode: controller.focusNodeNonce,
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
                    () => controller.nonceError.isFalse
                        ? const SizedBox(
                            height: 14,
                          )
                        : Text(
                            I18nRawKeys.onlyNumbersOfCanBeEntered.trPlaceholder(
                                ['≥${controller.transactionCount}']),
                            style: const TextStyle(
                                fontSize: 10, color: Color(0xFFEE4949)),
                          ),
                  )
                ],
              ),
            ],
          ),
          Gaps.vGap8,
          Text(
            '${I18nKeys.gasPriceAndGasLimitNote} \n        1${controller.coinInfo.coinUnit} = 10^${controller.coinInfo.coinDecimals! ~/ 2} Gwei',
            style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  buildAmountWidget() {
    return Stack(
      children: [
        Container(
          height: 120,
          decoration: controller.focusNodeAmount.hasFocus
              ? DecorateStyles.decoration15_line
              : DecorateStyles.decoration15,
        ),
        SizedBox(
          height: 120,
          child: Padding(
            padding: EdgeInsets.all(15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      I18nKeys.transferAmount,
                      style: TextStyles.textBold14,
                    ),
                    InkWell(
                      onTap: () => Get.bottomSheet(
                        SwitchCoinModal(
                          coin: controller.coinInfo,
                          token: controller.tokenInfo,
                          onSelectedCoinCallback: (Coin coin) {
                            controller.switch2Coin(coin);
                          },
                          onSelectedTokenCallback: (Token coin) {
                            controller.switch2Token(coin);
                          },
                        ),
                        isScrollControlled: true,
                      ),
                      child: Row(
                        children: [
                          controller.getCoinIcon(),
                          Gaps.hGap3,
                          Text(
                            controller.getCoinUnit(),
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF333333)),
                          ),
                          const WalletLoadAssetImage(
                            'common/icon_arrow_right',
                            width: 14,
                            height: 14,
                            color: Color(0xFF333333),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gaps.vGap4,
                EditTextField(
                  labelText: I18nKeys.pleaseEnterTheTransferAmount,
                  controller: controller.amountController,
                  focusNode: controller.focusNodeAmount,
                  inputFormatter: PrecisionLimitFormatter(6),
                  style: const TextStyle(fontSize: 21, color: Colors.black),
                ),
                Gaps.vGap12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${I18nKeys.balance}: ${controller.getCoinBalance()}',
                      style: const TextStyle(
                          color: Color(0xFF666666), fontSize: 11),
                    ),
                    InkWell(
                      onTap: () {
                        controller.transactionAll();
                      },
                      child: Text(
                        I18nKeys.turnOut,
                        style: const TextStyle(
                            color: Color(0xFF384A8B), fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
