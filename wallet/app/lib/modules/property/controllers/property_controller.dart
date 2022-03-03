import 'package:flutter/material.dart';
import 'package:flutter_base_kit/net/http/http.dart';
import 'package:flutter_base_kit/utils/storage_utils.dart';
import 'package:flutter_wallet/apis/api_urls.dart';
import 'package:flutter_wallet/extensions/extension_key.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/models/token_info_model.dart';
import 'package:flutter_wallet/modules/settings/node/controller/node_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/http_service.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/widgets/u_grid_view.dart';
import 'package:flutter_wallet/widgets/u_list_view.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:get/get.dart';

///
class PropertyController extends GetxController
    with SingleGetTickerProviderMixin {
  List<String> get tabs => [I18nKeys.assets, I18nKeys.collection];
  late final tabController = TabController(length: tabs.length, vsync: this);

  final scrollController = ScrollController();

  final _padding = 12.0.obs;

  double get padding => _padding.value;

  final _barOpacity = 1.0.obs;

  double get barOpacity => _barOpacity.value;

  final headerGlobalKey = GlobalKey();
  final tabBarGlobalKey = GlobalKey();
  final _tabViewChildTopPadding = 0.0.obs;

  // 修复StickyTabBar导致的ListView列表项遮挡问题
  double get tabViewChildTopPadding => _tabViewChildTopPadding.value;

  List<Color> gradient = const [Color(0xFF2750EB), Color(0xFF2750EB)];

  @override
  Future<void> onInit() async {
    super.onInit();
    LocalService.to.currencyObservable.stream.listen((_) => update());
    LocalService.to.languageObservable.stream.listen((_) => update());

    await NodeController.requestNodes();

    scrollController.addListener(() {
      _padding.value = 12.0 - (12.0 * scrollController.offset / 208.0);
      _padding.value = padding < 0.0 ? 0.0 : padding;
      _barOpacity.value = 1 - scrollController.offset / 208.0;
      _barOpacity.value = barOpacity < 0 ? 0 : barOpacity;
      final headerSize = headerGlobalKey.boxSize;
      if (headerSize == null) return;
      final tabBarSize = tabBarGlobalKey.boxSize;
      if (tabBarSize == null) return;
      if (scrollController.offset > headerSize.height) {
        final padding = tabBarSize.height -
            (headerSize.height + tabBarSize.height - scrollController.offset);
        if (_tabViewChildTopPadding.value != padding) {
          _tabViewChildTopPadding.value = padding;
        }
      } else if (scrollController.offset < tabBarSize.height) {
        const padding = 0.0;
        if (_tabViewChildTopPadding.value != padding) {
          _tabViewChildTopPadding.value = padding;
        }
      }
    });

    DBService.service.dbChanged.listen((_) {
      print('dbChanged');
      getTokenList();
    });
    LocalService.to.currencyObservable.listen((_) async {
      print('currencyConfigure');
      await WalletService.service.refreshBalance();
      update();
    });
  }

  ///
  Future<void> onAddressSelect(Coin coin) async {
    WalletService.service.resetCoin(coin);

    final selectCoinType = QiCoinCode44.parse(coin.coinType ?? '');
    if (selectCoinType != QiRpcService().coinType) {
      QiRpcService().switchChain(selectCoinType,
          StorageUtils.sp.read<String>('currentNode-' + (coin.coinType ?? '')));
    }
    getTokenList();
    refreshNftCollections();
  }

  List<TokenInfoModel> collections = [];

  Future<void> refreshNftCollections() async {
    try{
      ResponseModel<List<TokenInfoModel>> result = await HttpService.service.http
          .post<List<TokenInfoModel>>(ApiUrls.getNftCollections,
          data: {'address': WalletService.service.currentCoin!.coinAddress!});
      collections = result.data!;
      update(['collections']);
      collectionsController.refreshCompleted(resetFooterState: true);
    }catch(e){
      print(e);
    }
  }

  /// 加载更多
  Future<void> loadData(int page, int type) async {
    print('$page>>加载>>$type');
  }

  /// 重新选择地址
  Future<void> reselectAddress() async {
    _padding.value = 12.0;
    _barOpacity.value = 1;
    await WalletService.service.reselectAddress();
    update();
    onCoinChange();
  }

  /// 当前地址的所有资产
  var amountTotal = '0';

  /// 获取地址下的所有代币
  Future<void> getTokenList() async {
    await WalletService.service.checkEmpty();
    onCoinChange();
  }

  ///
  Future<void> onCoinChange() async {
    if (WalletService.service.currentCoin == null) {
      return;
    }
    await WalletService.service.getTokenList();
    update();
    await WalletService.service.refreshBalance();
    update();
  }

  ///
  Future<void> onTokenClick(Token token) async {
    if (token.tokenType!.endsWith('721')) {
      await Get.toNamed(Routes.NFT_LIST, arguments: token);
    } else {
      await Get.toNamed(Routes.TOKEN_TRANSACTION_LIST, arguments: token);
    }
  }

  ///
  Future<void> onCoinClick(Coin coinInfo) async {
    await Get.toNamed(Routes.TRANSACTION_LIST, arguments: coinInfo);
  }

  final listController = UListViewController.initialRefresh();
  final collectionsController = UGridViewController.initialRefresh();

  onRefresh() {
    WalletService.service.refreshCoinRate();
    getTokenList();
    listController.refreshCompleted(resetFooterState: true);
  }

  bool eyeOpen = true;

  void switchEysStatus() {
    eyeOpen = !eyeOpen;
    update();
  }
}
