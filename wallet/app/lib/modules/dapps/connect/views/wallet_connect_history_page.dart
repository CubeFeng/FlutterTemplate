import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/dapps/connect/controllers/wallet_connect_history_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/wallet_connect_service.dart';
import 'package:flutter_wallet/theme/decorate_style.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

class WalletConnectHistoryPage extends StatelessWidget {
  final WalletConnectHistoryController _controller =
      Get.put(WalletConnectHistoryController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: _controller,
        builder: (controller) {
          return Scaffold(
              appBar: QiAppBar(
                title: Text(I18nKeys.connectWallet),
                action: WalletConnectService
                        .service.connectServiceList.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          onNewScan();
                        },
                        child: WalletLoadAssetImage('wallet/icon_connect_add'))
                    : Container(),
              ),
              body: WalletConnectService.service.connectServiceList.isNotEmpty
                  ? listView()
                  : emptyView());
        });
  }

  onNewScan() async {
    if(false){
      String url =
          'wc:bb2f1b7c-3fdc-448c-956e-6fbeffa8520c@1?bridge=https%3A%2F%2Fbridge.walletconnect.org%2F&key=01829a942ee58ccf78cdbc8141e0e62039da67d0712acb23cd5249010ac13026';
      Get.toNamed(Routes.Dapp_Wallet_Connect,
          parameters: {"connectUrl": url});
      return;
    }
    final result = await Get.toNamed(
        Routes.Dapp_Wallet_Connect_SCAN);
    if (result != null) {
      Get.toNamed(Routes.Dapp_Wallet_Connect,
          parameters: {"connectUrl": result.toString()});
    }
  }

  Widget emptyView() {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          const WalletLoadAssetImage(
            'wallet/img_connect',
            width: 111,
            height: 89,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            I18nKeys
                .connectDAPPAuthorizationThroughWalletconnectProtocolToFacilitateFastTransaction,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFF333333)),
          ),
          const SizedBox(
            height: 172,
          ),
          UniButton(
            style: UniButtonStyle.Primary,
            onPressed: () {
              onNewScan();
            },
            child:
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(I18nKeys.addNetwork, style: TextStyle(fontSize: 15.sp)),
                ),
          ),
        ],
      ),
    );
  }

  Widget listView() {
    int index = 0;
    int length = WalletConnectService.service.connectServiceList.length;
    return ListView(
      children: [
        const SizedBox(
            height: 14,
        ),
        const WalletLoadAssetImage(
          'wallet/img_connect',
          width: 111,
          height: 89,
          fit: BoxFit.fitHeight,
        ),
        Container(
          decoration: DecorateStyles.decoration15,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                I18nKeys
                    .connectDAPPAuthorizationThroughWalletconnectProtocolToQuicklyTrade,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF333333)),
              ),
            ],
          ),
        ),
        Container(
          decoration: DecorateStyles.decoration15,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(15),
          child: Column(
            children: WalletConnectService.service.connectServiceList.map((e) {
              index++;
              return InkWell(
                onTap: () {
                  Get.toNamed(Routes.Dapp_Wallet_Connect_Detail,
                      parameters: {"connectUrl": e.connectUrl});
                },
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 54,
                          height: 54,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(27),
                                child: WalletLoadImage(
                                  e.getIcon(),
                                ),
                              ),
                              Positioned(
                                  right: 5,
                                  bottom: 2,
                                  child: e.isConnected()
                                      ? Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF42C53E), // 底色
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                          ),
                                        )
                                      : Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFCCCCCC), // 底色
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                          ),
                                        ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.getName(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              e.getUrl(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF999999)),
                            ),
                          ],
                        )),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Color(0xFFCCCCCC),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    index >= length
                        ? Container()
                        : const Divider(height: 1, color: Color(0xFFF5F5F5)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
