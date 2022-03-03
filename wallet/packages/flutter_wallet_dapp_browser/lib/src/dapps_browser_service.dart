import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_wallet_dapp_browser/flutter_wallet_dapp_browser.dart';
import 'package:flutter_wallet_dapp_browser/src/dapp_handler/dapps_navigation_action_handler_interceptor.dart';

class DappsBrowserService extends GetxService {
  static DappsBrowserService get service => Get.find();

  DappsBrowserController? get _dappsBrowserController =>
      Get.find<DappsBrowserController>();
  InAppWebViewController? get _webViewController =>
      _dappsBrowserController?.webViewController;

  late int _chainId;
  late String _rpcUrl;

  /// get
  int get chainId => _chainId;
  String get rpcUrl => _rpcUrl;

  /// inteceptor
  DappsJavaScriptHandlerInterceptor? _javaScriptHandler;
  DappsJavaScriptHandlerInterceptor? get javaScriptHandler =>
      _javaScriptHandler;

  DappsNavigationActionHandlerInterceptor? _navigationActionHandler;
  DappsNavigationActionHandlerInterceptor? get navigationActionHandler =>
      _navigationActionHandler;

  /// 配置
  void config({
    required int chainId,
    required String rpcUrl,
    required DappsJavaScriptHandlerInterceptor javaScriptHandler,
    required DappsNavigationActionHandlerInterceptor navigationActionHandler,
  }) {
    _chainId = chainId;
    _rpcUrl = rpcUrl;
    _javaScriptHandler = javaScriptHandler;
    _navigationActionHandler = navigationActionHandler;
  }

  /// --------------------------------------- dapp 操作事件 ------------------------------------------------
  /// 发送异常事件
  Future<void> sendError(int id, String error) async {
    await _webViewController?.evaluateJavascript(
        source: 'window.ethereum.sendError($id, \'$error\');');
  }

  Future<void> sendResult(int id, String result) async {
    await _webViewController?.evaluateJavascript(
        source: 'window.ethereum.sendResponse($id, \'$result\');');
  }

  Future<void> sendResults(int id, List<String> result) async {
    await _webViewController?.evaluateJavascript(
        source: 'window.ethereum.sendResponse($id, ${json.encode(result)});');
  }

  Future<void> setAddress(String address) async {
    await _webViewController?.evaluateJavascript(
        source: 'window.ethereum.setAddress("$address");');
  }

  Future<void> evaluateJavascript(
      {required String source, ContentWorld? contentWorld}) async {
    await _webViewController?.evaluateJavascript(
        source: source, contentWorld: contentWorld);
  }

  /// 获取dapp浏览器页面
  GetPage<dynamic> browserPage({String routeName = '/dapps_browser'}) {
    return GetPage<dynamic>(
      name: routeName,
      page: () => const DappsBrowserPage(),
      binding: DappsBrowserBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    );
  }

  /// 设置地址
  Future<void> changeAddress(String address) async {
    await setAddress(address);
  }

  /// 切换账号
  Future<void> switchAccount(String address) async {
    await setAddress(address);
    _webViewController?.reload();
  }

  /// 当前URL
  Future<Uri?> getURL() async {
    return Uri.parse(_dappsBrowserController!.swapUrl);
    return await _webViewController?.getUrl();
  }

  ///清理缓存
  Future<void> clearCache() async {
    await _webViewController?.clearCache();
  }

  ///刷新
  Future<void> reload() async {
    await _webViewController?.reload();
  }

  /// 更换链
  Future<void> switchChain(int chainId, String rpcUrl) async {
    _chainId = chainId;
    _rpcUrl = rpcUrl;

    final js = '''
        var config = {
          chainId: $chainId,
          rpcUrl: "$rpcUrl",
          isDebug: $kDebugMode
        };
        window.ethereum.setConfig(config);
        ''';
    await _webViewController?.evaluateJavascript(source: js);
  }
}
