import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

import '../controllers/nft_list_controller.dart';

///
class NftListView extends GetView<NftListController> {
  const NftListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NftListController>(
      builder: (controller) {
        return Scaffold(
          appBar: QiAppBar(
            title: Text("${controller.token.tokenName} NFT${I18nKeys.list}"),
          ),
          body: ListView(
            children: [
              Gaps.vGap12,
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: WalletLoadImage(
                    controller.token.tokenIcon!,
                    width: 50.w,
                    height: 50.w,
                  ),
                ),
              ),
              Gaps.vGap24,
              Center(
                child: Text(controller.token.description!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                    )),
              ),
              Gaps.vGap24,
              Column(
                children: controller.tokenList.map((item) {
                  return InkWell(
                    onTap: () {
                      controller.onTokenClick(item);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            child: SizedBox(width: 40, height: 40, child: WalletLoadImage(item.image!)),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name ?? ("#" + BigInt.parse(item.tokenId!, radix: 16).toString())),
                                Text(item.contractAddress!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
      init: controller,
    );
  }
}
