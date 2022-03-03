import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/apis/api_urls.dart';
import 'package:flutter_wallet/extensions/extension_key.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/generated/json_partner/json_partner.dart';
import 'package:flutter_wallet/models/swap_item_model.dart';
import 'package:flutter_wallet/models/wallet_banner_model.dart';
import 'package:flutter_wallet/models/wallet_kind_model.dart';
import 'package:flutter_wallet/models/wallet_swap_model.dart';
import 'package:flutter_wallet/modules/dapps/views/widgets/browser_action_sheet.dart';
import 'package:flutter_wallet/modules/property/controllers/property_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/http_service.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/widgets/modals/switch_wallet_modal.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/widgets/u_grid_view.dart';
import 'package:flutter_wallet/widgets/u_list_view.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:flutter_wallet_dapp_browser/flutter_wallet_dapp_browser.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DappBrowserController extends GetxController
    with SingleGetTickerProviderMixin {
  late TabController tabController;
  late List<WalletKindModel> tabs;
  final Map<String, List<SwapItemModel>> swapItemMap = {};
  late List<WalletBannerModel> bannerList;

  final contentPadding = 12.0;

  late int tabbarIndex = 0;
  late RefreshController refreshController = RefreshController(
    initialRefresh: true,
    initialRefreshStatus: RefreshStatus.refreshing,
    initialLoadStatus: LoadStatus.loading,
  );

  final scrollController = ScrollController();
  final headerGlobalKey = GlobalKey();
  final tabBarGlobalKey = GlobalKey();
  final _tabViewChildTopPadding = 0.0.obs;

  // 修复StickyTabBar导致的ListView列表项遮挡问题
  double get tabViewChildTopPadding => _tabViewChildTopPadding.value;

  @override
  void onInit() {
    super.onInit();
    tabs = [];
    bannerList = [];
    tabController = TabController(
      initialIndex: tabbarIndex,
      length: tabs.length,
      vsync: this,
    );

    LocalService.to.currencyObservable.stream.listen((_) => update());
    LocalService.to.languageObservable.stream.listen((_) => _pageUpdate());

    scrollController.addListener(() {
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
  }

  void _pageUpdate() {
    getBannerList();
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    _getDappDataFromCache();

    await getBannerList();
  }

  ///请求banner 和 wallet list
  Future<void> getBannerList() async {
    ResponseModel<WalletSwapModel> result = await HttpService.service.http
        .get<WalletSwapModel>(ApiUrls.getSwapBanner);

    if (result.code == 200) {
      tabs = result.data!.walletKind!;
      if (tabbarIndex > tabs.length - 1) {
        tabbarIndex = tabs.length - 1;
      }
      tabController = TabController(
          initialIndex: tabbarIndex, length: tabs.length, vsync: this);
      bannerList = result.data!.walletBanner!;

      print('浏览器接口返回 banner ${bannerList.length} walletkind：${tabs.length}');

      for (WalletKindModel model in tabs) {
        await getDappList(model.id!);
      }

      update();
      _cacheDappData(result.data!);
    }else {
      _getDappDataFromCache();
    }
  }

  ///请求dapp列表
  Future<void> getDappList(int id) async {
    ResponseModel<List<SwapItemModel>> resultList = await HttpService
        .service.http
        .get<List<SwapItemModel>>(ApiUrls.getSwapList(id));
    List<SwapItemModel> tempList = resultList.data!;

    swapItemMap[id.toString()] = [];

    if(false){//关闭内测借贷功能
      SwapItemModel cjItem = SwapItemModel();
      cjItem.coin = 'ETH';
      cjItem.name = 'AITD Decentralized Bank';
      cjItem.desc = 'AITD Decentralized Bank，让你玩转DeFi借贷';
      cjItem.iconUrl = 'https://defi-test-1304418020.cos.ap-guangzhou.myqcloud.com//tmp/wallet/1637549743958.png';
      cjItem.kind = 1;
      cjItem.whiteLink = '';
      cjItem.downloadUrl = 'http://bridge-pre.aitd.io';
      tempList.add(cjItem);
    }
    if (tempList.isNotEmpty) {
      swapItemMap[id.toString()]!.addAll(tempList);
    }

    refreshController.refreshCompleted();
  }

  ///搜索dapp
  void searchDappWithTextFlied(String text) {

    if(!text.startsWith('http')){
      text = 'https://' + text;
    }

    Get.toNamed(Routes.DAPPS_BROWSER, parameters: {
      'url': text
    });
  }

  ///dapp 列表点击事件
  void browserListClickAction(SwapItemModel item) {
    // print("白名单列表 downloadUrl ${item.downloadUrl}");

    if (!_checkCoinChain(item)) {
      return;
    }
    _openDappSwap(item);
  }

  ///打开swap
  void _openDappSwap(SwapItemModel item) {

    //kind 	1 DAPP 2 WEB 3 ACROSS_CHAIN
    if (item.kind == 1) {

      Map<String, dynamic>? dappListMap = StorageUtils.sp.read<Map<String,dynamic>>('readSwapList');

      if(dappListMap == null){
        dappListMap = {};

        dappListMap[item.id.toString()] = "1";

        _showFirstOpenDappModal(item,dappListMap);
      }else{
        if (dappListMap[item.id.toString()] == null){
          dappListMap[item.id.toString()] = "1";
          _showFirstOpenDappModal(item,dappListMap);
        }
        else{
          if (item.downloadUrl!.isNotEmpty) {
            String path = "/?lng=${LocalService.to.languageCode}";
            Get.toNamed(Routes.DAPPS_BROWSER, parameters: {'url': "${item.downloadUrl!}$path","whiteLinkUrl":item.whiteLink!,"path":path});
          }
        }
      }

    } else if (item.kind == 2) {
      String path =
          "?lng=${LocalService.to.languageCode}&address=${WalletService.service.currentCoin!.coinAddress}";
      path = Uri.encodeComponent(path); //实现url编码
      var url = "${item.downloadUrl}/?path=$path";
      Get.toNamed(Routes.DAPPS_Web_BANNER, parameters: {'url': url});
    } else {
      Get.toNamed(Routes.DAPPS_BROWSER, parameters: {
        'url': item.downloadUrl! +
            '/?lng=${LocalService.to.languageCode}&network=aitd'
      });
    }
  }

  _showFirstOpenDappModal(SwapItemModel item,Map<String, dynamic>? dappListMap){

    UniModals.showSingleActionPromptModal(
        icon: const WalletLoadAssetImage("dapp/icon_dapp_tip1"),
        title: Text(I18nKeys.statementOfResponsibility),
        showCloseIcon: true,
        width: 324.w,
        message: Text(I18nRawKeys.dappStatementOfResponsibilityInfo.trPlaceholder([item.name??"",item.name??""])),
        action: InkWell(
            child: Text(I18nKeys.iAlreadyKnow)),
        onAction:() async {
          Get.back();

          StorageUtils.sp.write('readSwapList', dappListMap);
          if (item.downloadUrl!.isNotEmpty) {
            String path = "/?lng=${LocalService.to.languageCode}";
            Get.toNamed(Routes.DAPPS_BROWSER, parameters: {'url': "${item.downloadUrl!}$path","whiteLinkUrl":item.whiteLink??'null',"path":path});
          }
        },
        actionStyle: UniButtonStyle.PrimaryLight);
  }

  ///检查钱包和链
  bool _checkCoinChain(SwapItemModel item) {
    //检查是否创建钱包
    if (WalletService.service.currentCoin == null) {
      //还没添加过钱包，弹窗提示
      UniModals.showGeneralSingleActionPromptModal(
          message: Text(
              I18nRawKeys.dapp_addWallet_tip
                  .trPlaceholder([item.coin ?? "AITD"]),
              textAlign: TextAlign.center),
          actionTitle: I18nKeys.addWallet,
          image: const WalletLoadAssetImage("user/icon_dapp_tip"),
          onConfirm: () {
            Get.back();
            Get.toNamed(Routes.WALLET_MANAGE);
          });
      return false;
    }

    //检查当前链
    if (QiRpcService().coinType.chainName() != item.coin) {
      //切换链
      UniModals.showGeneralSingleActionPromptModal(
          message: Text(
            I18nRawKeys.dapp_switchWallet_tip
                .trPlaceholder([item.coin ?? "AITD"]),
            textAlign: TextAlign.center,
          ),
          actionTitle: I18nKeys.switchWallet,
          image: const WalletLoadAssetImage("user/icon_dapp_tip"),
          onConfirm: () {
            Get.back();
            _showSwitchWalletModal();
          });
      return false;
    }

    return true;
  }

  ///切换链
  void _showSwitchWalletModal() {
    Get.bottomSheet(
      SwitchWalletModal(
        onSelectedWalletCallback: (coin) {
          final _controller = Get.find<PropertyController>();
          _controller.onAddressSelect(coin);
          Get.back();
        },
      ),
      isScrollControlled: true,
    );
  }

  _cacheDappData(WalletSwapModel swapModel){
    StorageUtils.sp.write("walletKindBannerList", jsonEncode(swapModel.toDeepJson()));

    Map<String,List> tempMap = {};
    swapItemMap.forEach((key, value) {
      tempMap[key] = [];
      tempMap[key]!.addAll(value.map((e) => e.toJson()).toList());
    });

    StorageUtils.sp.write("walletDappList", jsonEncode(tempMap));
  }

  _getDappDataFromCache() {
    String? jsonString = StorageUtils.sp.read<String>('walletKindBannerList');

    String? swapString = StorageUtils.sp.read<String>('walletDappList');

    if(jsonString != null && swapString != null){
      final dynamic jsonObj = json.decode(jsonString);

      final walletBanner = JsonPartner.fromJsonAsT<List<WalletBannerModel>>(
          jsonObj["walletBanner"]);
      final walletKind = JsonPartner.fromJsonAsT<List<WalletKindModel>>(
          jsonObj["walletKind"]);

      final dynamic swapObj = json.decode(swapString);

      for (WalletKindModel model in walletKind){
        final swapItem = JsonPartner.fromJsonAsT<List<SwapItemModel>>(
            swapObj[model.id!.toString()]);
        swapItemMap[model.id!.toString()] = [];
        swapItemMap[model.id!.toString()]!.addAll(swapItem);
      }

      // print('浏览器获取缓存 banner ${walletBanner.length} walletkind：${walletKind.length} swapItemMap:${swapItemMap.length}');

      tabs = walletKind;
      bannerList = walletBanner;
    }else{

      tabs = [];
      bannerList = [];
    }

    tabController = TabController(
        initialIndex: tabbarIndex, length: tabs.length, vsync: this);
    update();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
    logger.d('DappBrowserController close');
  }
}

class NavigationActionHandler extends DappsNavigationActionHandlerInterceptor {
  @override
  Future<void> handler(NavigationActionName name, arguments) async {

    final propertyController = Get.find<PropertyController>();
    // if (name == NavigationActionName.changeAccount) {

    // }

      final uri = await DappsBrowserService.service.getURL();

      print("object $uri");
      showBrowserBottomSheet(
        context: Get.context!,
        title: uri?.host != null ? I18nRawKeys.thisPageIsProvidedBy.trPlaceholder([uri?.host ?? '']):"",
        onSwitchAccount: () {
          Get.back();

          Get.bottomSheet(
            SwitchWalletModal(
              singleChain: true,
              coinType: QiRpcService().coinType,
              onSelectedWalletCallback: (coin) async {
                await propertyController.onAddressSelect(coin);
                DappsBrowserService.service
                    .switchAccount(WalletService.service.currentCoin!.coinAddress!);
                Get.back();
              },
            ),
            isScrollControlled: true,
          );
        },
        onCopyLink: () async {
          Get.back();
          Clipboard.setData(ClipboardData(text: uri.toString()));
          Toast.showInfo('链接已复制到剪切板!');
        },
        onShare: () async {
          Get.back();
          await Share.share(uri.toString(), subject: "");
        },
        onRefresh: () async {
          Get.back();
          await DappsBrowserService.service.clearCache();
          await DappsBrowserService.service.reload();
        },
        onOpenInBrowser: () async {
          Get.back();
          if (true || await canLaunch(uri.toString())) {
            await launch(uri.toString(), forceSafariVC: false);
          }
        },
      );

  }
}
