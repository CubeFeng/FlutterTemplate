part of flutter_wallet_dapp_browser;

const dappsHandlers = [
  JavaScriptHandler('requestAccounts'),
  JavaScriptHandler('signTransaction'),
  JavaScriptHandler('signTypedMessage'),
  JavaScriptHandler('addEthereumChain'),
  JavaScriptHandler('switchEthereumChain'),
  JavaScriptHandler('offlineSignTransaction'),
  JavaScriptHandler('sendSignedTransaction'),
];

abstract class DappsJavaScriptHandlerInterceptor
    implements JavaScriptHandlerInterceptor {
  final DappsBrowserService _dappsBrowserService = DappsBrowserService.service;

  @override
  Future<JavaScriptHandlerResult?> handler(
      JavaScriptHandler handler, List<dynamic> args) async {
    final id = args[0]['id'];
    try {
      final result = await handlerScript(handler.name, id, args);
      if (result.isNotEmpty) {
        await _dappsBrowserService.sendResults(id, result);
      }
    } catch (e) {
      await _dappsBrowserService.sendError(id, e.toString());
    }
    return const JavaScriptHandlerResult();
  }

  /// 处理 web3、trustjs 的方法
  ///
  /// [handlerName] 方法名称
  /// [id] 消息ID
  /// [args] 参数
  Future<List<String>> handlerScript(
      String handlerName, int id, List<dynamic> args);
}
