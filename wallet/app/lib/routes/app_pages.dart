// ignore_for_file: prefer_const_constructors

import 'package:flutter_wallet/modules/dapps/connect/scan_view.dart';
import 'package:flutter_wallet/modules/dapps/connect/views/wallet_connect_detail_page.dart';
import 'package:flutter_wallet/modules/dapps/connect/views/wallet_connect_history_page.dart';
import 'package:flutter_wallet/modules/dapps/connect/views/wallet_connect_page.dart';
import 'package:flutter_wallet/modules/dapps/views/dapps_web_banner.dart';
import 'package:flutter_wallet/modules/home/views/home_view.dart';
import 'package:flutter_wallet/modules/property/coin/record/bindings/coin_record_binding.dart';
import 'package:flutter_wallet/modules/property/coin/record/views/coin_record_view.dart';
import 'package:flutter_wallet/modules/property/coin/transaction/bindings/coin_transaction_binding.dart';
import 'package:flutter_wallet/modules/property/coin/transaction/views/coin_transaction_view.dart';
import 'package:flutter_wallet/modules/property/nft/list/bindings/nft_list_binding.dart';
import 'package:flutter_wallet/modules/property/nft/list/views/nft_list_view.dart';
import 'package:flutter_wallet/modules/property/nft/record/bindings/nft_record_binding.dart';
import 'package:flutter_wallet/modules/property/nft/record/views/nft_record_view.dart';
import 'package:flutter_wallet/modules/property/nft/transaction/bindings/nft_transaction_binding.dart';
import 'package:flutter_wallet/modules/property/nft/transaction/views/nft_transaction_view.dart';
import 'package:flutter_wallet/modules/property/record_detail_view.dart';
import 'package:flutter_wallet/modules/property/token/list/bindings/token_list_binding.dart';
import 'package:flutter_wallet/modules/property/token/list/views/token_list_view.dart';
import 'package:flutter_wallet/modules/property/token/record/bindings/token_record_binding.dart';
import 'package:flutter_wallet/modules/property/token/record/views/token_record_view.dart';
import 'package:flutter_wallet/modules/property/token/transaction/bindings/token_transaction_binding.dart';
import 'package:flutter_wallet/modules/property/token/transaction/views/token_transaction_view.dart';
import 'package:flutter_wallet/modules/property/transaction_nft_result_view.dart';
import 'package:flutter_wallet/modules/property/transaction_result_view.dart';
import 'package:flutter_wallet/modules/property/views/receive_qr_code_view.dart';
import 'package:flutter_wallet/modules/property/views/receive_share_view.dart';
import 'package:flutter_wallet/modules/scancode/views/scancode_view.dart';
import 'package:flutter_wallet/modules/settings/about/views/settings_about_view.dart';
import 'package:flutter_wallet/modules/settings/address/views/address_add_edit_view.dart';
import 'package:flutter_wallet/modules/settings/address/views/address_view.dart';
import 'package:flutter_wallet/modules/settings/message/views/settings_message_detail_view.dart';
import 'package:flutter_wallet/modules/settings/message/views/settings_message_view.dart';
import 'package:flutter_wallet/modules/settings/node/views/node_coin_view.dart';
import 'package:flutter_wallet/modules/settings/node/views/node_list_view.dart';
import 'package:flutter_wallet/modules/settings/security/bindings/setup_password_binding.dart';
import 'package:flutter_wallet/modules/settings/security/bindings/verify_password_binding.dart';
import 'package:flutter_wallet/modules/settings/security/views/security_lock_view.dart';
import 'package:flutter_wallet/modules/settings/security/views/settings_security_view.dart';
import 'package:flutter_wallet/modules/settings/security/views/setup_password_view.dart';
import 'package:flutter_wallet/modules/settings/security/views/verify_password_view.dart';
import 'package:flutter_wallet/modules/settings/share/setting_share_view.dart';
import 'package:flutter_wallet/modules/settings/system/views/system_options_view.dart';
import 'package:flutter_wallet/modules/splash/views/splash_view.dart';
import 'package:flutter_wallet/modules/ucore/home/ucore_home_binding.dart';
import 'package:flutter_wallet/modules/ucore/home/ucore_home_page.dart';
import 'package:flutter_wallet/modules/ucore/news/bindings/news_binding.dart';
import 'package:flutter_wallet/modules/ucore/news/views/news_view.dart';
import 'package:flutter_wallet/modules/unlock/views/unlock_view.dart';
import 'package:flutter_wallet/modules/wallet/create/bindings/mnemonic_binding.dart';
import 'package:flutter_wallet/modules/wallet/create/bindings/wallet_create_binding.dart';
import 'package:flutter_wallet/modules/wallet/create/views/mnemonic_create_view.dart';
import 'package:flutter_wallet/modules/wallet/create/views/mnemonic_verify_view.dart';
import 'package:flutter_wallet/modules/wallet/create/views/wallet_create_view.dart';
import 'package:flutter_wallet/modules/wallet/export/bindings/wallet_export_binding.dart';
import 'package:flutter_wallet/modules/wallet/export/views/wallet_export_view.dart';
import 'package:flutter_wallet/modules/wallet/hardware/manage/bindings/hd_wallet_manage_binding.dart';
import 'package:flutter_wallet/modules/wallet/hardware/manage/views/hd_wallet_manage_view.dart';
import 'package:flutter_wallet/modules/wallet/hardware/network/bindings/hd_wallet_network_binding.dart';
import 'package:flutter_wallet/modules/wallet/hardware/network/views/hd_wallet_network_view.dart';
import 'package:flutter_wallet/modules/wallet/import/bindings/wallet_import_binding.dart';
import 'package:flutter_wallet/modules/wallet/import/views/wallet_import_view.dart';
import 'package:flutter_wallet/modules/wallet/manager/bindings/wallet_manage_binding.dart';
import 'package:flutter_wallet/modules/wallet/manager/views/wallet_manage_view.dart';
import 'package:flutter_wallet_dapp_browser/flutter_wallet_dapp_browser.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

/// App页面
class AppPages {
  AppPages._();

  static final routes = [
    /// 启动页
    GetPage<dynamic>(
      name: Routes.SPLASH,
      page: () => SplashView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      transition: Transition.fade,
    ),

    /// 解锁
    GetPage(
      name: Routes.UNLOCK,
      page: () => UnlockView(),
      transition: Transition.fade,
    ),

    /// 主页(初始页面)
    GetPage<dynamic>(
      name: Routes.HOME,
      page: () => HomeView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      transition: Transition.fade,
    ),

    /// 扫码
    GetPage<dynamic>(
      name: Routes.SCAN_CODE,
      page: () => ScanCodeView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 设置(地址管理)
    GetPage<dynamic>(
      name: Routes.SETTINGS_ADDRESS,
      page: () => AddressView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 设置(地址管理)
    GetPage<dynamic>(
      name: Routes.SETTINGS_ADDRESS_ADD_EDIT,
      page: () => AddressAddEditView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 设置（站内信）
    GetPage<dynamic>(
      name: Routes.SETTINGS_MESSAGE,
      page: () => SettingsMessageView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 设置消息详情
    GetPage<dynamic>(
      name: Routes.SETTINGS_MESSAGE_DETAIL,
      page: () => SettingsMessageDetailView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 系统设置
    GetPage<dynamic>(
      name: Routes.SETTINGS_OPTIONS,
      page: () => SystemOptionsView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 安全中心
    GetPage<dynamic>(
      name: Routes.SETTINGS_SECURITY,
      page: () => SettingsSecurityView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 关于我们
    GetPage<dynamic>(
      name: Routes.SETTINGS_ABOUT,
      page: () => SettingsAboutView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 创建助记词
    GetPage<dynamic>(
      name: Routes.MNEMONIC_CREATE,
      page: () => MnemonicCreateView(),
      binding: MnemonicBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 验证助记词
    GetPage<dynamic>(
      name: Routes.MNEMONIC_VERIFY,
      page: () => MnemonicVerifyView(),
      binding: MnemonicBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 验证助记词
    GetPage<dynamic>(
      name: Routes.WALLET_CREATE,
      page: () => WalletCreateView(),
      binding: WalletCreateBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 导入钱包
    GetPage<dynamic>(
      name: Routes.WALLET_IMPORT,
      page: () => WalletImportView(),
      binding: WalletImportBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 主币交易记录
    GetPage<dynamic>(
      name: Routes.TRANSACTION_LIST,
      page: () => CoinRecordView(),
      binding: CoinRecordBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 主币转账
    GetPage<dynamic>(
      name: Routes.TRANSACTION,
      page: () => CoinTransactionView(),
      binding: CoinTransactionBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 代币列表
    GetPage<dynamic>(
      name: Routes.TOKEN_LIST,
      page: () => TokenListView(),
      binding: TokenListBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 代币交易记录
    GetPage<dynamic>(
      name: Routes.TOKEN_TRANSACTION_LIST,
      page: () => TokenRecordView(),
      binding: TokenRecordBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// NFT列表
    GetPage<dynamic>(
      name: Routes.NFT_LIST,
      page: () => NftListView(),
      binding: NftListBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// NFT代币交易记录
    GetPage<dynamic>(
      name: Routes.NFT_TRANSACTION_LIST,
      page: () => NftRecordView(),
      binding: NftRecordBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 代币转账
    GetPage<dynamic>(
      name: Routes.TOKEN_TRANSACTION,
      page: () => TokenTransactionView(),
      binding: TokenTransactionBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// NFT代币转账
    GetPage<dynamic>(
      name: Routes.NFT_TRANSACTION,
      page: () => NftTransactionView(),
      binding: NftTransactionBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 转账详情
    GetPage<dynamic>(
      name: Routes.TRANSACTION_DETAIL,
      page: () => RecordDetailView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 转账结果
    GetPage<dynamic>(
      name: Routes.TRANSACTION_RESULT,
      page: () => TransactionResultView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// NFT转账结果
    GetPage<dynamic>(
      name: Routes.TRANSACTION_NFT_RESULT,
      page: () => TransactionNftResultView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// NFT代币转账
    GetPage<dynamic>(
      name: Routes.WALLET_MANAGE,
      page: () => WalletManageView(),
      binding: WalletManageBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 钱包导出
    GetPage<dynamic>(
      name: Routes.WALLET_EXPORT,
      page: () => WalletExportView(),
      binding: WalletExportBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// HD钱包管理
    GetPage<dynamic>(
      name: Routes.HD_WALLET_MANAGE,
      page: () => HDWalletManageView(),
      binding: HDWalletManageBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// HD钱包网络添加
    GetPage<dynamic>(
      name: Routes.HD_WALLET_NETWORK,
      page: () => HDWalletNetworkView(),
      binding: HDWalletNetworkBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 收款二维码
    GetPage<dynamic>(
      name: Routes.PROPERTY_RECEIVE_QR_CODE,
      page: () => ReceiveQrCodeView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 收款地址分享
    GetPage<dynamic>(
      name: Routes.PROPERTY_RECEIVE_SHARE,
      page: () => ReceiveShareView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 设置钱包密码
    GetPage<dynamic>(
      name: Routes.SECURITY_SETUP_PASSWORD,
      page: () => SetupPasswordView(),
      binding: SetupPasswordBinding(),
    ),

    /// 验证密码
    GetPage<dynamic>(
      name: Routes.SECURITY_VERIFY_PASSWORD,
      page: () => VerifyPasswordView(),
      binding: VerifyPasswordBinding(),
    ),

    /// 验证密码
    GetPage<dynamic>(
      name: Routes.SETTINGS_SECURITY_LOCK,
      page: () => SettingsSecurityLock(),
      // binding: VerifyPasswordBinding(),
    ),

    /// dapp banner web
    GetPage<dynamic>(
      name: Routes.DAPPS_Web_BANNER,
      page: () => DappWebBannerPage(),
    ),

    GetPage<dynamic>(
      name: Routes.SETTINGS_NODE_LIST,
      page: () => NodeListView(),
    ),

    GetPage<dynamic>(
      name: Routes.SETTINGS_NODE_COIN,
      page: () => NodeCoinView(),
    ),

    GetPage<dynamic>(
      name: Routes.SETTINGS_SHARE,
      page: () => InviteSharePage(),
    ),

    GetPage<dynamic>(
      name: Routes.Dapp_Wallet_Connect,
      page: () => WalletConnectPage(),
    ),
    GetPage<dynamic>(
      name: Routes.Dapp_Wallet_Connect_History,
      page: () => WalletConnectHistoryPage(),
    ),
    GetPage<dynamic>(
      name: Routes.Dapp_Wallet_Connect_Detail,
      page: () => WalletConnectDetailPage(),
    ),
    GetPage<dynamic>(
      name: Routes.Dapp_Wallet_Connect_SCAN,
      page: () => ScanView(),
    ),


    ///
    GetPage<dynamic>(
      name: Routes.UCORE_HOME_NEWS,
      page: () => UCHomePage(),
      binding: UCHomeBinding(),
    ),

    GetPage<dynamic>(
      name: Routes.UCORE_RSS_NEWS,
      page: () => NewsView(),
      binding: NewsBinding(),
    ),

    /// dapp 浏览器
    DappsBrowserService.service.browserPage(routeName: Routes.DAPPS_BROWSER),
  ];
}
