import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/widgets/u_list_view.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

typedef ConfirmCallback = void Function();

/// 切换币种
class TransactionConfirmModal extends StatelessWidget {
  final _controller = Get.put(_TransactionConfirmController());
  final ConfirmCallback onConfirmCallback;
  final String address;
  final String amount;
  final String amountCurrency;

  TransactionConfirmModal({
    Key? key,
    required this.onConfirmCallback,
    required this.address,
    required this.amount,
    required this.amountCurrency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: constraints.maxHeight * 0.5,
        child: GetBuilder<_TransactionConfirmController>(
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
                    Center(
                      child: Column(
                        children: [
                          Gaps.vGap18,
                          Text(
                            I18nKeys.transferTo,
                            style: TextStyle(
                              color: const Color(0xFF666666),
                              fontSize: 13.sp,
                            ),
                          ),
                          Gaps.vGap5,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 68),
                            child: Text(
                              address,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: const Color(0xFF666666),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Gaps.vGap20,
                          Text(
                            amount,
                            style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Gaps.vGap5,
                          Text(
                            amountCurrency,
                            style: TextStyle(
                                color: const Color(0xFF999999),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold),
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
                                onConfirmCallback.call();
                              },
                            ),
                          ),
                        ],
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
              I18nKeys.confirmTransfer,
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

class _TransactionConfirmController extends GetxController {
  final listController = UListViewController.initialRefresh();

  Coin? currentCoin;
  late List<Token> tokenList;

  late Coin? coin;
  late Token? token;

  Future<void> loadInitialData(Coin? coin, Token? token) async {
    currentCoin = WalletService.service.currentCoin;
    tokenList = WalletService.service.tokenList;
    this.coin = coin;
    this.token = token;
  }

  onRefresh() {
    print('onRefresh');
    listController.refreshCompleted(resetFooterState: true);
  }

  isSelectToken(Token token) {
    if (this.token == null) {
      return false;
    }
    return this.token!.id == token.id;
  }

  isSelectCoin() {
    if (token != null) {
      return false;
    }
    return true;
  }
}
