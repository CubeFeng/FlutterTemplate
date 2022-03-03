import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/generated/icon_font.g.dart';
import 'package:flutter_wallet/models/transaction_info_model.dart';
import 'package:flutter_wallet/models/tx_type.dart';
import 'package:flutter_wallet/modules/property/record_detail_view.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/u_list_view.dart';
import 'package:flutter_wallet/widgets/u_sliver_sticky_widget.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:intl/intl.dart';

import 'base_record_controller.dart';
import 'math_util.dart';

extension CoinIcon on Coin {
  String getIcon() {
    return 'property/icon_coin_${coinUnit!.toLowerCase()}';
  }
}

extension TransInfo on TransactionInfoModel {
  String getTime() {
    return DateFormat("yyyy-MM-dd HH:mm").format(
        DateTime.fromMillisecondsSinceEpoch(
            blocktime! * 1000 + 0 * 60 * 60 * 1000));
  }
}

///
// ignore: use_key_in_widget_constructors
abstract class BaseRecordView<T extends BaseRecordController<D>, D>
    extends GetView<T> {
  String getTitle(D data);

  int getDecimals(D data);

  Widget getIconWidget(D data);

  String getIconUrl(D data) {
    return '';
  }

  String getAmount(D data);

  String getAmountCNY(D data);

  onClick(D data);

  String getBannerTitle() {
    return I18nKeys.assetDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.gradient[0],
      appBar: QiAppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const IconFont(
            IconFont.iconFanhui,
            size: 16,
            color: '#FFFFFF',
          ),
        ),
        backgroundColor: controller.gradient[0],
        title: Text(
          getBannerTitle(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            buildSliverHeader(controller.coin),
            buildStickyTabBar(context),
          ];
        },
        body: buildTabBarView(controller.coin),
      ),
    );
  }

  Widget buildTabBarView(D data) {
    return Container(
      color: Colors.white,
      child: TabBarView(
        controller: controller.tabController,
        children: controller.txTypes
            .map(
              (e) => GetBuilder<T>(
                  id: e,
                  init: controller,
                  builder: (controller) {
                    return KeepAliveWrapper(
                      child: _CoinTxTabList(
                        unit: getTitle(data),
                        decimals: getDecimals(data),
                        txType: e,
                        data: controller,
                        controller: controller.listViewControllers[e]!,
                        onRefresh: () => controller.onRefresh(e, false),
                        onLoading: () => controller.onLoading(e),
                      ),
                    );
                  }),
            )
            .toList(),
      ),
    );
  }

  Widget buildSliverHeader(D data) {
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
              SizedBox(height: 12.sp),
              Container(
                height: 26.h,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.only(left: 12, right: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0x11FFFFFF), width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 20, height: 20, child: getIconWidget(data)),
                    Gaps.hGap3,
                    Text(
                      getTitle(data),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.vGap5,
              GetBuilder<T>(
                  id: 'amount',
                  init: controller,
                  builder: (controller) {
                    return Column(
                      children: [
                        Center(
                          child: Text(
                            getAmount(data),
                            style: TextStyle(
                              color: const Color(0xFFFFFFFF),
                              fontSize: 29.sp,
                              fontFamily: 'DIN',
                            ),
                          ),
                        ),
                        Gaps.vGap5,
                        Center(
                          child: Text(
                            getAmountCNY(data),
                            style: TextStyle(
                              color: const Color(0xFFFFFFFF).withOpacity(0.6),
                              fontSize: 12.sp,
                              fontFamily: 'DIN',
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
              Gaps.vGap24,
              Container(
                margin: const EdgeInsets.all(12),
                height: 50.h,
                decoration: BoxDecoration(
                    color: const Color(0x12000000),
                    borderRadius: BorderRadius.circular(15)),
                child: Opacity(
                  opacity: 0.72,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          icon:
                              const WalletLoadAssetImage('property/icon_send'),
                          label: Text(
                            I18nKeys.transfer,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.white),
                          ),
                          onPressed: () {
                            onClick(data);
                          },
                        ),
                      ),
                      Gaps.vvLine(
                          width: 1, color: Colors.white.withOpacity(0.1)),
                      Expanded(
                        child: TextButton.icon(
                          icon: const WalletLoadAssetImage(
                              'property/icon_receive'),
                          label: Text(
                            I18nKeys.receive,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.white),
                          ),
                          onPressed: () {
                            Get.toNamed(Routes.PROPERTY_RECEIVE_QR_CODE,
                                parameters: {'image': getIconUrl(data)});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.vGap12,
            ],
          ),
        ),
      ]),
    );
  }

  Widget buildStickyTabBar(BuildContext context) {
    return USliverStickyWidget(
      minHeight: 49,
      maxHeight: 49,
      child: LayoutBuilder(builder: (context, c) {
        return Container(
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
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                TabBar(
                  controller: controller.tabController,
                  indicatorColor: const Color(0xFF161A27),
                  isScrollable: true,
                  // 是否可以滑动
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: controller.txTabs
                      .map((e) => Tab(text: e, height: double.infinity))
                      .toList(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({Key? key, required this.child}) : super(key: key);

  @override
  __KeepAliveWrapperState createState() => __KeepAliveWrapperState();
}

class __KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

class _CoinTxTabList extends StatelessWidget {
  final TxType txType;
  final String unit;
  final int decimals;
  final UListViewController controller;
  final BaseRecordController data;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;

  const _CoinTxTabList({
    Key? key,
    required this.txType,
    required this.controller,
    this.onRefresh,
    this.onLoading,
    required this.data,
    required this.unit,
    required this.decimals,
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
    bool isTransactionOut =
        item.fromAddr == WalletService.service.currentCoin!.coinAddress;
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.TRANSACTION_DETAIL,
            arguments: item, parameters: {'unit': unit, '': ''});
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
        child: Row(
          children: [
            SizedBox(
              width: 49,
              height: 49,
              child: WalletLoadAssetImage(isTransactionOut
                  ? 'property/icon_transaction_out'
                  : 'property/icon_transaction_in'),
            ),
            SizedBox(width: 11.w),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddressText(
                  isTransactionOut ? item.toAddr! : item.fromAddr!,
                  fontSize: 14.sp,
                  color: const Color(0xFF333333),
                ),
                SizedBox(height: 3.h),
                Text(
                  item.getTime(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF999999),
                  ),
                )
              ],
            )),
            SizedBox(
              width: 124.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    (isTransactionOut ? '-' : '+') +
                        item.getAmount(decimals) +
                        " " +
                        unit,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: isTransactionOut
                          ? const Color(0xFF333333)
                          : const Color(0xFF41B449),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    item.getStatus(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension TransactionStatus on TransactionInfoModel {
  String getStatus() {
    switch (status) {
      case 3:
        return I18nKeys.success;
      case -1:
        return I18nKeys.fail;
    }
    return I18nKeys.confirmationInProgress;
  }

  String getAmount(int decimals) {
    if (amount == null) {
      return "1";
    }
    return MathToll.stringKeepDown(amount!, 6);
  }
}
