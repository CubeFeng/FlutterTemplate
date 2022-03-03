import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/settings/node/controller/node_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:get/get.dart';

class NodeCoinView extends StatelessWidget {
  final controller = Get.put(NodeCoinController());

  NodeCoinView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (_) {
          return Scaffold(
            appBar: QiAppBar(
              title: Text(I18nKeys.nodeSettings),
            ),
            body: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: QiRpcService()
                    .supportCoins
                    .map((e) => Column(
                          children: [_buildOption(e), _buildDivider()],
                        ))
                    .toList()),
          );
        });
  }

  Widget _buildOption(QiCoinType coinType) {
    String node = NodeController.getNode(coinType);
    Uri? uri = Uri.tryParse(node);
    return InkWell(
      onTap: () async {
        Get.toNamed(Routes.SETTINGS_NODE_LIST,
            parameters: {'coin': coinType.coinUnit()});
      },
      child: Container(
        height: 73.w,
        padding: EdgeInsets.only(left: 15.w, right: 15.w),
        child: Row(
          children: [
            WalletLoadAssetImage(
              'property/icon_coin_${coinType.coinUnit().toLowerCase()}',
              width: 43.w,
              height: 43.w,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10.w),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 22.w,
                ),
                Text(coinType.coinUnit(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.bold,
                    )),
                Text(uri != null ? (uri.scheme + "://" + uri.host) : '-',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xff999999),
                    )),
              ],
            )),
            SizedBox(width: 5.w),
            Icon(
              Icons.arrow_forward_ios,
              size: 12.sp,
              color: const Color(0xFFCCCCCC),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.only(left: 15.w, right: 15.w),
      child: Divider(
        height: 1.h,
        color: const Color(0xff5E6992).withOpacity(0.1),
      ),
    );
  }
}
