import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_base_kit/widgets/load_image.dart';
import 'package:flutter_wallet/models/token_info_model.dart';
import 'package:flutter_wallet/models/transaction_info_model.dart';
import 'package:flutter_wallet/models/tx_type.dart';
import 'package:flutter_wallet/modules/property/base_record_controller.dart';
import 'package:flutter_wallet/modules/property/base_record_view.dart';
import 'package:flutter_wallet/modules/property/nft/record/controllers/nft_record_controller.dart';
import 'package:flutter_wallet/modules/property/record_detail_view.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/widgets/u_list_view.dart';
import 'package:flutter_wallet/widgets/u_sliver_sticky_widget.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

///
// ignore: use_key_in_widget_constructors
class NftRecordView extends BaseRecordView<NftRecordController, TokenInfoModel> {
  @override
  String getTitle(TokenInfoModel data) {
    return data.tokenId!;
  }

  @override
  int getDecimals(TokenInfoModel data) {
    return 1;
  }

  @override
  String getIconUrl(TokenInfoModel data) {
    return data.image??'';
  }

  @override
  String getBannerTitle() {
    return I18nKeys.collectionTransactionHistory;
  }

  @override
  Widget buildStickyTabBar(BuildContext context) {
    return USliverStickyWidget(
      minHeight: 49,
      maxHeight: 49,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [controller.gradient[1], Colors.white],
            stops: const [0.8, 1],
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
          ),
          child: TabBar(
            controller: controller.tabControllerNft,
            indicatorColor: const Color(0xFF161A27),
            isScrollable: true,
            // 是否可以滑动
            indicatorSize: TabBarIndicatorSize.label,
            tabs: controller.txTabsNft.map((e) => Tab(text: e)).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTabBarView(TokenInfoModel data) {
    return Container(
      color: Colors.white, // 底色
      child: TabBarView(
        controller: controller.tabControllerNft,
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              UniModals.showSingleActionPromptModal(
                                  icon: WalletLoadAssetImage(
                                    'property/icon_author',
                                    width: 112.w,
                                    height:  89.h,
                                  ),
                                  title: Text(I18nKeys.author),
                                  message: Text(
                                    I18nKeys
                                        .theDataComesFromHermesTheThirdpartyExchangePlatformAndTheSpecificContentIsSubjectToTheDataOnTheChain,
                                  ),
                                  action: Text(I18nKeys.iKnow),
                                  onAction: () {
                                    Get.back();
                                  });
                            },
                            child: Row(
                              children: [
                                Text(
                                  I18nKeys.author,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff333333),
                                  ),
                                ),
                                Gaps.hGap5,
                                const WalletLoadAssetImage('property/icon_question'),
                              ],
                            ),
                          ),
                          Gaps.vGap9,
                          SizedBox(
                            width: 200,
                            child: Text(
                              controller.coin.author ?? "-",
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xff333333),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    divider(),
                    _leftRightText(I18nKeys.platform, getAmount(data)),
                    divider(),
                    _leftRightText('${I18nKeys.no}/Token ID', getAmountCNY(data)),
                    divider(),
                    _leftRightText(I18nKeys.description, controller.coin.description ?? '-'),
                    divider(),
                  ],
                ),
              )
            ],
          ),
          GetBuilder<NftRecordController>(
              id: TxType.ALL,
              init: controller,
              builder: (controller) {
                return _NftTxTabList(
                  txType: TxType.ALL,
                  data: controller,
                  controller: controller.listViewControllers[TxType.ALL]!,
                  onRefresh: () => controller.onRefresh(TxType.ALL, false),
                  onLoading: () => controller.onLoading(TxType.ALL),
                );
              })
        ],
      ),
    );
  }

  @override
  Widget buildSliverHeader(TokenInfoModel data) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: controller.gradient,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 30.sp),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: SizedBox(
                    width: 90.r,
                    height: 90.r,
                    child: getIconWidget(data),
                  ),
                ),
              ),
              Gaps.vGap20,
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getAmount(data),
                      style: TextStyle(
                        color: const Color(0xFFFFFFFF),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Container(
                    //   height: 16.h,
                    //   padding: const EdgeInsets.only(left: 6, right: 6),
                    //   decoration: BoxDecoration(
                    //       color: const Color(0xFFFFFFFF).withOpacity(0.1), borderRadius: BorderRadius.circular(11)),
                    //   child: Center(
                    //     child: Text(
                    //       getAmountCNY(data),
                    //       style: TextStyle(
                    //           color: const Color(0xFFFFFFFF).withOpacity(0.5),
                    //           fontSize: 11,
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Gaps.vGap5,
              Container(
                height: 50.h,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0x12000000), borderRadius: BorderRadius.circular(15)),
                child: Opacity(
                  opacity: 0.72,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          icon: const WalletLoadAssetImage('property/icon_gift'),
                          label: Text(
                            I18nKeys.give,
                            style: const TextStyle(fontSize: 13, color: Colors.white),
                          ),
                          onPressed: () => onClick(data),
                        ),
                      ),
                      Gaps.vvLine(width: 1, color: Colors.white.withOpacity(0.1)),
                      Expanded(
                        child: TextButton.icon(
                          icon: const WalletLoadAssetImage('property/icon_dapp'),
                          label: const Text(
                            "DAPP",
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                          onPressed: () {
                            if (data.dappUrl != null) {
                              Get.toNamed(Routes.DAPPS_BROWSER, arguments: {'url': data.dappUrl});
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  String getAmount(TokenInfoModel data) {
    if (data.name != null) {
      if (data.name!.contains('#')) {
        return data.name!.substring(0, data.name!.indexOf('#'));
      }else{
        return data.name!;
      }
    }
    return I18nKeys.unknown;
  }

  @override
  String getAmountCNY(TokenInfoModel data) {
    return '#' + BigInt.parse(data.tokenId!, radix: 16).toString();
  }

  @override
  Widget getIconWidget(TokenInfoModel data) {
    return WalletLoadImage(data.image!);
  }

  @override
  onClick(TokenInfoModel data) {
    return Get.toNamed(Routes.NFT_TRANSACTION, arguments: data);
  }
}

Widget _leftRightText(
  String left,
  String right,
) {
  return Padding(
    padding: const EdgeInsets.only(top: 15, bottom: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff333333),
          ),
        ),
        Gaps.vGap9,
        SizedBox(
          width: 200,
          child: Text(
            right,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff333333),
            ),
          ),
        ),
      ],
    ),
  );
}

class _NftTxTabList extends StatelessWidget {
  final TxType txType;
  final UListViewController controller;
  final BaseRecordController data;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;

  const _NftTxTabList({
    Key? key,
    required this.txType,
    required this.controller,
    this.onRefresh,
    this.onLoading,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UListView(
      controller: controller,
      itemBuilder: (context, index) => _buildItem(context, index),
      separatorBuilder: (context, index) => const Divider(indent: 59),
      onRefresh: onRefresh,
      onLoading: onLoading,
      enableLoadMore: true,
      itemCount: data.listDataMap[txType]!.length,
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    TransactionInfoModel item = data.listDataMap[txType]![index];
    return InkWell(
      onTap: () {
        TokenInfoModel token = Get.find<NftRecordController>().coin;
        Get.toNamed(Routes.TRANSACTION_DETAIL, arguments: item, parameters: {'image': token.image!});
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white, // 底色
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 3), //x,y轴
                      color: const Color(0xFF000000).withOpacity(0.08), //阴影颜色
                      blurRadius: 5.w //投影距
                      ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(22.0)),
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(fontSize: 18, color: Color(0xFF333333), fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 11.w),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 88,
                      child: AddressText(
                        item.fromAddr!,
                        fontSize: 14.sp,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    Gaps.hGap5,
                    const WalletLoadAssetImage('property/icon_transfer'),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  item.getTime(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF999999),
                  ),
                )
              ],
            )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 88,
                  child: AddressText(
                    item.toAddr!,
                    fontSize: 14.sp,
                    color: const Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 9.h),
                Text(
                  item.status == 3
                      ? I18nKeys.completed
                      : (item.status == -1
                      ? I18nKeys.fail
                      : I18nKeys.confirmationInProgress),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF999999),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
