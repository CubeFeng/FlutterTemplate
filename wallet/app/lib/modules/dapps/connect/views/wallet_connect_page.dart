import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/dapps/connect/controllers/wallet_connect_controller.dart';
import 'package:flutter_wallet/modules/wallet/manager/controllers/wallet_manage_controller.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/theme/decorate_style.dart';
import 'package:flutter_wallet/widgets/modals/switch_wallet_modal.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';

class WalletConnectPage extends StatelessWidget {
  final WalletConnectController _controller =
      Get.put(WalletConnectController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: _controller,
        builder: (controller) {
          return _controller.connectService.status == "0"
              ? Scaffold(
                  appBar: const QiAppBar(
                    leading: Text(""),
                    title: Text(""),
                  ),
                  body: connectView(),
                )
              : Scaffold(
                  appBar: QiAppBar(
                    title: Text(I18nKeys.requestConnection),
                  ),
                  body: authView(),
                );
        });
  }

  authView() {
    return ListView(
      children: [
        const SizedBox(
          height: 14,
        ),
        WalletLoadImage(
          _controller.connectService.myPeerMeta.icons[0],
          width: 90,
          height: 90,
          fit: BoxFit.fitHeight,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          _controller.connectService.myPeerMeta.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          _controller.connectService.myPeerMeta.url,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
        ),
        const SizedBox(
          height: 18,
        ),
        Container(
          decoration: DecorateStyles.decoration15,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                I18nKeys.jurisdiction,
                style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisSize : MainAxisSize.min,
                children: [
                  const WalletLoadAssetImage(
                    'wallet/icon_circle_green',
                    width: 12,
                    height: 8,
                    fit: BoxFit.fitHeight,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        I18nKeys.allowsYouToViewAddressBalancesAndChainInformation,
                        style:
                            const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisSize : MainAxisSize.min,
                children: [
                  const WalletLoadAssetImage(
                    'wallet/icon_circle_green',
                    width: 12,
                    height: 8,
                    fit: BoxFit.fitHeight,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        I18nKeys
                            .permissionToRequestAuthorizationFromTheAddressWhenATransactionOccurs,
                        style:
                            const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisSize : MainAxisSize.min,
                children: [
                  const WalletLoadAssetImage(
                    'wallet/icon_circle_red',
                    width: 12,
                    height: 8,
                    fit: BoxFit.fitHeight,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        I18nKeys
                            .authorizationWillNotRevealYourMnemonicsAndPrivateKey,
                        style:
                            const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Get.bottomSheet(
              SwitchWalletModal(
                singleChain: true,
                coinType: qiFindChainById(
                    _controller.connectService.getWCClient().chainId),
                onSelectedWalletCallback: (coin) {
                  _controller.selectCoin(coin);
                  Get.back();
                },
              ),
              isScrollControlled: true,
            );
          },
          child: _controller.coin == null
              ? Container()
              : Container(
                  decoration: DecorateStyles.decoration15,
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            I18nKeys.connectionAddress,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(height: 1, color: Color(0xFFF5F5F5)),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                WalletManageController.getWalletName(
                                    _controller.wallet),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              WalletManageController.isHDWallet(
                                      _controller.wallet)
                                  ? Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(3.r),
                                        border: Border.all(
                                          style: BorderStyle.solid,
                                          color: const Color(0xFF333333),
                                          width: 0.8,
                                        ),
                                      ),
                                      child: const Text(
                                        'HD',
                                        style: TextStyle(fontSize: 10.5),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            _controller.coin!.coinAddress!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0x88333333),
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Row(
                            children: [
                              Text(
                                '${I18nKeys.balance}: ',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF333333),
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                LocalService.to.currencySymbol +
                                    '' +
                                    WalletService.service
                                        .getTotalBalanceCurrency(
                                        _controller.coin!)
                                        .toStringAsFixed(2),
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF333333),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Color(0xFFCCCCCC),
                        ),
                      )
                    ],
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: 55,
            child: UniButton(
              style: UniButtonStyle.PrimaryLight,
              onPressed: () async {
                _controller.approveSession();
              },
              child: Text(I18nKeys.authorizedConnection,
                  style: TextStyle(fontSize: 15.sp)),
            ),
          ),
        ),
      ],
    );
  }

  connectView() {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 88,
            ),
            const WalletLoadAssetImage(
              'wallet/icon_wc_top',
              width: 100,
              height: 100,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(
              width: 68,
              height: 88,
              child: WalletLoadAssetImage(
                "wallet/connect",
                format: ImageFormat.gif,
              ),
            ),
            const WalletLoadAssetImage(
              'wallet/icon_wc_bottom',
              width: 100,
              height: 100,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              I18nKeys.walletconnectIsConnectingYourWallet,
              style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
            )
          ],
        ),
      ),
    );
  }
}
