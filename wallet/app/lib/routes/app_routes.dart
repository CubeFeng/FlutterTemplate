// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

/// 路由路径
class Routes {
  Routes._();

  /// 启动页
  static const String SPLASH = '/splash';

  /// 解锁页面
  static const String UNLOCK = '/unlock';

  /// 主页
  static const String HOME = '/home';

  /// 扫码
  static const String SCAN_CODE = '/scan-code';

  /// 系统设置
  static const String SETTINGS_OPTIONS = '/settings/options';

  /// 安全中心
  static const String SETTINGS_SECURITY = '/settings/security';

  /// 设置-地址管理
  static const String SETTINGS_ADDRESS = '/settings/address';

  /// 设置-地址管理-添加/编辑地址
  static const String SETTINGS_ADDRESS_ADD_EDIT = '/settings/address/add-edit';

  /// 设置-站内信
  static const String SETTINGS_MESSAGE = '/settings/message';

  /// 设置-站内信-详细
  static const String SETTINGS_MESSAGE_DETAIL = '/settings/message/detail';

  ///修改密码
  static const String SETTINGS_SECURITY_UPDATE_PASSWORD =
      '/settings/update/password';

  ///关于我们
  static const String SETTINGS_ABOUT = '/settings/about';

  ///币种
  static const String SETTINGS_OPTIONS_CURRENCY = '/settings/options/currency';

  ///语言
  static const String SETTINGS_OPTIONS_LANGUAGE = '/settings/options/language';

  /// 创建助记词
  static const String MNEMONIC_CREATE = '/mnemonic/create';

  /// 验证助记词
  static const String MNEMONIC_VERIFY = '/mnemonic/verify';

  /// 创建钱包
  /// 页面参数 inputText
  /// 页面参数 importType
  static const String WALLET_CREATE = '/wallet/verify';

  /// 导入钱包
  static const String WALLET_IMPORT = '/wallet/import';

  /// 钱包管理
  static const String WALLET_MANAGE = '/wallet/manage';

  /// 钱包导出
  /// 页面参数 arguments [WalletExportArgs]
  static const String WALLET_EXPORT = '/wallet/export';

  /// 交易记录
  static const String TRANSACTION_LIST = '/transaction/list';

  /// 转账
  static const String TRANSACTION = '/transaction/index';

  /// 转账结果
  static const String TRANSACTION_RESULT = '/transaction/result';

  /// NFT转账结果
  static const String TRANSACTION_NFT_RESULT = '/transaction/nft/result';

  /// 代币列表
  static const String TOKEN_LIST = '/token/list';

  /// 代币交易记录
  static const String TOKEN_TRANSACTION_LIST = '/token/transaction/list';

  /// NFT代币列表
  static const String NFT_LIST = '/nft/list';

  /// NFT代币交易记录
  static const String NFT_TRANSACTION_LIST = '/nft/transaction/list';

  /// 代币转账
  static const String TOKEN_TRANSACTION = '/token/transaction';

  /// NFT代币转账
  static const String NFT_TRANSACTION = '/nft/transaction';

  /// 转账详情
  static const String TRANSACTION_DETAIL = '/transaction/detail';

  /// HD钱包管理
  static const String HD_WALLET_MANAGE = '/wallet/manage/hd';

  /// HD钱包网络添加
  static const String HD_WALLET_NETWORK = '/wallet/manage/network';

  /// dapp 浏览器
  static const String DAPPS_BROWSER = '/dapps/browser';

  /// dapp 浏览器 banner web
  static const String DAPPS_Web_BANNER = "/dapps/web/banner";

  /// 收款二维码
  static const String PROPERTY_RECEIVE_QR_CODE = '/property/receive-qr-code';

  /// 收款地址分享
  static const String PROPERTY_RECEIVE_SHARE = '/property/receive-share';

  /// 设置钱包密码
  static const String SECURITY_SETUP_PASSWORD = "/security/setup-password";

  /// 验证密码
  static const String SECURITY_VERIFY_PASSWORD = "/security/verify-password";

  /// 应用锁
  static const String SETTINGS_SECURITY_LOCK = "/security/setting-lock";

  /// 节点
  static const String SETTINGS_NODE_COIN = "/setting/node/coin";

  /// 节点
  static const String SETTINGS_NODE_LIST = "/setting/node/list";

  ///分享
  static const String SETTINGS_SHARE = "/setting/share";

  /// wallet connect
  static const String Dapp_Wallet_Connect = "/dapp/wallet-connect-temp";
  static const String Dapp_Wallet_Connect_History = "/dapp/wallet-connect/history";
  static const String Dapp_Wallet_Connect_Detail = "/dapp/wallet-connect/detail";
  static const String Dapp_Wallet_Connect_SCAN = "/dapp/wallet-connect/scan";
  static const String Dapp_Wallet_Connect_temp = "/dapp/wallet-connect";

  static const String UCORE_HOME_NEWS = "/ucore/home/news";
  static const String UCORE_RSS_NEWS = "/ucore/rss/news";

}
