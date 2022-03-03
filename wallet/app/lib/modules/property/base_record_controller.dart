import 'package:flutter/material.dart';
import 'package:flutter_base_kit/utils/storage_utils.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/models/transaction_info_model.dart';
import 'package:flutter_wallet/models/tx_type.dart';
import 'package:flutter_wallet/modules/property/controllers/property_controller.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/widgets/u_list_view.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:get/get.dart';

///
abstract class BaseRecordController<D> extends GetxController
    with SingleGetTickerProviderMixin {
  final txTabs = [I18nKeys.all, I18nKeys.transfer, I18nKeys.receive];
  final txTabsNft = [I18nKeys.info, I18nKeys.transferRecord];
  final txTypes = [TxType.ALL, TxType.OUT, TxType.IN];
  final listViewControllers = Map.fromEntries(
    TxType.values
        .map((it) => MapEntry(it, UListViewController.initialRefresh())),
  );

  late TabController tabController;
  late TabController tabControllerNft;
  late D coin;

  int year = 2021;
  var month = 10.obs;
  final Map<TxType, List<TransactionInfoModel>> listDataMap = {};

  Future<List<TransactionInfoModel>> getCurrentList(TxType txType) async {
    if (cache6monthFinished) {
      await refreshCurrentMonthRecord(txType);
    } else {
      List<TransactionInfoModel> list = [];
      await loadNetRecord(list, txType, 2);
      await save2Database(list);
    }
    return await queryLocalData(txType);
  }

  Future<List<TransactionInfoModel>> queryLocalData(TxType txType);

  save2Database(List<TransactionInfoModel> list);

  Future<void> loadData(List<TransactionInfoModel> list, int page, int type,
      TxType txType, bool inEnd, bool outEnd,
      {refresh = false});

  refreshCurrentMonthRecord(TxType txType) async {
    List<TransactionInfoModel> list = [];
    switch (txType) {
      case TxType.ALL:
        await loadData(list, 1, 1, txType, false, false,
            refresh: true); //获取转出记录
        await loadData(list, 1, 2, txType, false, false,
            refresh: true); //获取转入记录
        break;
      case TxType.OUT:
        await loadData(list, 1, 1, txType, false, false,
            refresh: true); //获取转出记录
        break;
      case TxType.IN:
        await loadData(list, 1, 2, txType, false, false,
            refresh: true); //获取转入记录
        break;
    }
    await save2Database(list);
  }

  loadNetRecord(
      List<TransactionInfoModel> list, TxType txType, int type) async {
    if (!cache6monthFinished) {
      if (list.length > 5) {
        if (preShow) {
          preShow = false;
          fillData(txType, list);
        }
      }
    }
    switch (txType) {
      case TxType.ALL:
        await loadData(
            list, 1, type == 1 ? 2 : 1, txType, false, false); //获取转出记录
        break;
      case TxType.OUT:
        await loadData(list, 1, 1, txType, false, false); //获取转出记录
        break;
      case TxType.IN:
        await loadData(list, 1, 2, txType, false, false); //获取转入记录
        break;
    }
  }

  bool preShow = true;

  /// 加载更多
  Future<void> onRefresh(TxType txType, bool timeChanged) async {
    List<TransactionInfoModel> list = await getCurrentList(txType);
    fillData(txType, list);
  }

  fillData(TxType txType, List<TransactionInfoModel> list) async {
    print('fillData');
    listDataMap[txType]!.clear();
    listDataMap[txType]!.addAll(list);
    listViewControllers[txType]!.refreshCompleted(resetFooterState: true);
    update([txType]);
    await WalletService.service
        .refreshCoinBalance([WalletService.service.currentCoin!]);
    Get.find<PropertyController>().update();
    update(['amount']);
  }

  /// 加载更多
  Future<void> onLoading(TxType txType) async {
    print('onLoading');
    listViewControllers[txType]!.loadNoData();
  }

  bool hasMore = false;

  @override
  void onReady() {
    print('onReady');
    super.onReady();
  }

  dateSelect(DateTime time) {
    year = time.year;
    month.value = time.month;
    for (var element in txTypes) {
      onRefresh(element, true);
    }
  }

  bool closeTag = false;

  @override
  onClose() {
    closeTag = true;
  }

  getCoinKey() {
    return '';
  }

  List<Color> gradient = const [Color(0xFF4681F6), Color(0xFF235FD5)];

  bool cache6monthFinished = false;

  int cacheMonthCount = 6; //缓存6个月数据

  @override
  Future<void> onInit() async {
    coin = Get.arguments;
    if (coin is Coin) {
      Coin data = coin as Coin;
      gradient = QiCoinCode44.parse(data.coinType!).coinGradientColor();
    }
    int recordTime = StorageUtils.sp.read<int>('recordTime', 0) ?? 0;
    int tracePoint = (StorageUtils.sp.read<int>(getCoinKey(), -1) ?? -1);
    cache6monthFinished = tracePoint > recordTime;
    if (cache6monthFinished == true) {
      DateTime traceTime = DateTime.fromMillisecondsSinceEpoch(tracePoint);
      DateTime nowTime = DateTime.now();
      if (traceTime.year < nowTime.year) {
        print('跨年描点，重新拉取');
        cache6monthFinished = false;
      } else {
        if (traceTime.month < nowTime.month) {
          print('跨月描点，重新拉取');
          cache6monthFinished = false;
          cacheMonthCount = nowTime.month - traceTime.month;
          cacheMonthCount = cacheMonthCount > 6 ? 6 : cacheMonthCount;
        }
      }
    }
    print('onInit $cache6monthFinished >> $cacheMonthCount');
    super.onInit();
    final now = DateTime.now();
    year = now.year;
    month.value = now.month;
    listDataMap[TxType.ALL] = [];
    listDataMap[TxType.OUT] = [];
    listDataMap[TxType.IN] = [];
    tabController = TabController(length: txTabs.length, vsync: this);
    tabControllerNft = TabController(length: txTabsNft.length, vsync: this);
  }
}
