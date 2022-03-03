import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/dapps/connect/controllers/wallet_connect_detail_controller.dart';
import 'package:flutter_wallet/modules/wallet/manager/controllers/wallet_manage_controller.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/theme/decorate_style.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

class WalletConnectDetailPage extends StatelessWidget {
  final WalletConnectDetailController _controller =
      Get.put(WalletConnectDetailController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: _controller,
        builder: (controller) {
          return Scaffold(
              appBar: QiAppBar(
                title: Text(I18nKeys.connectionDetails),
              ),
              body: listView());
        });
  }

  Widget listView() {
    return ListView(
      children: [
        const SizedBox(
          height: 14,
        ),
        WalletLoadImage(
          _controller.connectService.getIcon(),
          width: 90,
          height: 90,
          fit: BoxFit.fitHeight,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          _controller.connectService.getName(),
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
          _controller.connectService.getUrl(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
        ),
        Container(
          decoration: DecorateStyles.decoration15,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                I18nKeys.details,
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
                    I18nKeys.connectionStatus,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  _controller.connectService.isConnected()
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF42C53E), // 底色
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                        )
                      : Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFCCCCCC), // 底色
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      _controller.connectService.isConnected()
                          ? I18nKeys.online
                          : I18nKeys.offline,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(height: 1, color: Color(0xFFF5F5F5)),
              itemView(I18nKeys.recentConnection,
                  _controller.connectService.getTime()),
              const Divider(height: 1, color: Color(0xFFF5F5F5)),
              itemView(
                  I18nKeys.mainNetwork, _controller.connectService.getChain()),
              const Divider(height: 1, color: Color(0xFFF5F5F5)),
              itemView(I18nKeys.authorizedTransaction,
                  '${_controller.connectService.count}${I18nKeys.pen}'),
              const Divider(height: 1, color: Color(0xFFF5F5F5)),
              itemView(I18nKeys.authorizedConnection,
                  _controller.connectService.getUrl()),
            ],
          ),
        ),
        _controller.connectService.coin != null
            ? Container(
                decoration: DecorateStyles.decoration15,
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(15),
                child: Column(
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
                        WalletManageController.isHDWallet(_controller.wallet)
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.r),
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
                      _controller.connectService.getAddress(),
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
                                      _controller.connectService.coin!)
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
              )
            : Container(),
        _controller.connectService.isConnected()
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: 55,
                  child: UniButton(
                    style: UniButtonStyle.DangerLight,
                    onPressed: () async {
                      _controller.connectService.killSession();
                    },
                    child: Text(I18nKeys.disconnect,
                        style: TextStyle(fontSize: 15.sp)),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  itemView(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
          const Expanded(child: SizedBox.shrink()),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}
