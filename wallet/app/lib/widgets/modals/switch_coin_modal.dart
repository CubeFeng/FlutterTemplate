import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/property/base_record_view.dart';
import 'package:flutter_wallet/modules/property/views/widgets/property_item_view.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/widgets/u_list_view.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

typedef SelectedCoinCallback = void Function(Coin coin);
typedef SelectedTokenCallback = void Function(Token coin);

/// 切换币种
class SwitchCoinModal extends StatelessWidget {
  final _controller = Get.put(_SwitchCoinController());
  final SelectedCoinCallback onSelectedCoinCallback;
  final SelectedTokenCallback onSelectedTokenCallback;
  final Coin? coin;
  final Token? token;

  SwitchCoinModal({
    Key? key,
    required this.onSelectedCoinCallback,
    required this.onSelectedTokenCallback,
    this.coin,
    this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _controller.loadInitialData(coin, token);
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: constraints.maxHeight * 0.75,
        child: GetBuilder<_SwitchCoinController>(
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
                      child: UListView(
                        controller: controller.listController,
                        itemBuilder: (context, index) {
                          return index == 0
                              ? PropertyItemView(
                                  margin: 6,
                                  selected: controller.isSelectCoin(),
                                  onTap: () {
                                    Get.back();
                                    onSelectedCoinCallback
                                        .call(controller.coin!);
                                  },
                                  coinName: controller.currentCoin!.coinUnit!,
                                  icon: WalletLoadAssetImage(
                                    controller.currentCoin!.getIcon(),
                                    fit: BoxFit.fitHeight,
                                  ),
                                  coinAddress:
                                      controller.currentCoin!.coinType!,
                                  coinAmount: WalletService.service
                                      .getCoinBalance(controller.currentCoin!),
                                  coinAmountCurrency: WalletService.service
                                      .getCoinBalanceCurrency(
                                          controller.currentCoin!),
                                )
                              : PropertyItemView(
                                  selected: controller.isSelectToken(
                                      controller.tokenList[index - 1]),
                                  margin: 6,
                                  onTap: () {
                                    Get.back();
                                    onSelectedTokenCallback
                                        .call(controller.tokenList[index - 1]);
                                  },
                                  icon: ClipRRect(
                                      borderRadius: BorderRadius.circular(22),
                                      child: WalletLoadImage(
                                        controller
                                            .tokenList[index - 1].tokenIcon!,
                                        width: 44.w,
                                        height: 44.w,
                                      )),
                                  coinName: controller
                                      .tokenList[index - 1].tokenUnit!,
                                  coinAddress: controller
                                      .tokenList[index - 1].tokenName!,
                                  coinAmount: WalletService.service
                                      .getTokenBalance(
                                          controller.tokenList[index - 1]),
                                  coinAmountCurrency: WalletService.service
                                      .getTokenCurrencyBalance(
                                          controller.tokenList[index - 1]),
                                );
                        },
                        separatorBuilder: (context, index) =>
                            const Divider(indent: 59),
                        enableRefresh: false,
                        itemCount: controller.tokenList.length + 1,
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
              I18nKeys.changeCurrency,
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

class _SwitchCoinController extends GetxController {
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
