import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InjectJavaScriptConfig {
  InjectJavaScriptConfig._();

  /// 注入调试工具
  static Future<void> injectDebugTools(InAppWebViewController? webViewController) async {
    if (kDebugMode) {
      await webViewController?.injectJavascriptFileFromUrl(
          urlFile: Uri.parse('https://unpkg.com/vconsole/dist/vconsole.min.js'));

      webViewController?.evaluateJavascript(source: '''
    setTimeout(() => {
        window.vConsole = new window.VConsole({
          defaultPlugins: ['system', 'network', 'element', 'storage'],
          maxLogNumber: 1000,
        });
      }, 3000);
    ''');
    }
  }

  /// 网页加载完回调
  static Future<void> onWebViewReday(InAppWebViewController? webViewController) async {
    String platformReadyJS = "window.dispatchEvent(new Event('WebViewReady'));";
    await webViewController?.evaluateJavascript(source: platformReadyJS);
  }

  /// 网页销毁回调
  static Future<void> onWebViewDispose(InAppWebViewController? webViewController) async {
    String platformReadyJS = "window.dispatchEvent(new Event('WebViewDispose'));";
    await webViewController?.evaluateJavascript(source: platformReadyJS);
  }
}
