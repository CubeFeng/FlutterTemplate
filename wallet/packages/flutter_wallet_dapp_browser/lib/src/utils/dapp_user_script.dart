import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// 用于注册 userScript
///
/// addUserScript 与 evaluateJavascript 的主要区别在于
/// 前者是常驻内存中, 后者在 reload 后就会被释放
class DappUserScriptUtils {
  DappUserScriptUtils._();
// http://172.63.1.186:8545
  static Future<UnmodifiableListView<UserScript>> initialUserScripts(int chainId, String rpcUrl) async {
    String trustJs = await rootBundle.loadString('packages/flutter_wallet_dapp_browser/assets/js/aitd-wallet-min.js');
    return Future.value(UnmodifiableListView([
      UserScript(source: trustJs, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START),
      UserScript(source: '''
        (function() {
          console.log('开始注入web3!')
          var config = {
              chainId: $chainId,
              rpcUrl: "$rpcUrl",
              isDebug: $kDebugMode
          };
          window.ethereum = new trustwallet.Provider(config);
          window.web3 = new trustwallet.Web3(window.ethereum);
          trustwallet.postMessage = (jsonObj) => {
            const _name = jsonObj['name'] ? jsonObj['name'] : 'message';
            window.flutter_inappwebview.callHandler(_name, jsonObj);
          };
          console.log('web3注入完成!')
        })();
        ''', injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START),
    ]));
  }
}
