part of flutter_wallet_dapp_browser;

class DappsBrowserController extends GetxController {
  final DappsBrowserService _dappsBrowserService = DappsBrowserService.service;
  InAppWebViewController? webViewController;

  /// 网页标题
  final webTitle = ''.obs;

  /// 网页左侧关闭按钮
  final closeBtnVisible = false.obs;

  /// 网页右侧操作按钮
  final actionBtnVisible = true.obs;

  /// 网页加载进度, 为了美观给 20 默认值
  final loadProgress = 0.2.obs;

  bool isInject = false;

  bool webViewCreated = false;

  late String swapUrl = "";

  late final String _whiteLinkUrl;

  late final String _path;

  /// 是否作为为嵌入页启动
  late final bool isEmbedLaunchMode;

  @override
  void onInit() async {
    super.onInit();
    _whiteLinkUrl = Get.parameters['whiteLinkUrl'] ?? "";
    _path = Get.parameters['path'] ?? "";
    swapUrl = Get.parameters['url'] ?? 'https://swap-pre.aitd.io';
    isEmbedLaunchMode = Get.parameters['launchMode'] == 'embed';
  }


  ///请求swap 白名单列表
  Future<bool> getWhiteLinkList() async {
    if (!_whiteLinkUrl.isNotNullOrEmpty){
      return true;
    }

    HttpClient _linkClient = HttpClient();

    ResponseModel<Map> resultMap =
    await   _linkClient.get<Map>(_whiteLinkUrl);

    Map map = resultMap.data!;

    for (String tempStr in map['data']) {

      //解码
      final baseUrl = EncryptUtils.decodeBase64(
        tempStr,
      );

      List<String> baseUrlList = [];
      int index = 0;
      // 以#分割 ，并把#前面第一个字母去掉
      for (String element in baseUrl.split("#")) {
        index++;
        if (index < baseUrl.split("#").length && element.length > 1) {
          element = element.substring(1);
        }
        baseUrlList.add(element);
      }

      String tempUrl = baseUrlList.join(".");

      //验证URL
      ResponseModel<String> result =
      await _linkClient.get<String>("http://$tempUrl");
      // print("getWhiteLinkList tempUrl :$tempUrl result:$result");
      if (result.status == 200) {
        swapUrl = "http://$tempUrl$_path";
        return true;
      }
    }

    return true;
  }

  @override
  void onClose() {
    InjectJavaScriptConfig.onWebViewDispose(webViewController);
    super.onClose();
  }

  Future<void> back() async {
    if (await webViewController?.canGoBack() == true) {
      await webViewController?.goBack();
    } else {
      if (isEmbedLaunchMode) {
        // 作为为嵌入页启动时，直接关闭整个Flutter界面
        SystemNavigator.pop();
      } else {
        Get.back();
      }
    }
  }

  /// webView 创建成果
  void onWebViewCreated(InAppWebViewController controller) async {
    webViewController = controller;
    await injectConfig();
    await InjectJavaScriptConfig.onWebViewReday(controller);
  }

  Future<void> injectConfig() async {
    /// 注册 javascript handle
    JavaScriptHandlerManager.registerHandlers(webViewController!,
        _dappsBrowserService.javaScriptHandler, dappsHandlers);
// await InjectJavaScriptConfig.injectDebugTools(webViewController);
  }

  /// initialUserScripts
  Future<UnmodifiableListView<UserScript>> get initialUserScripts {
    return DappUserScriptUtils.initialUserScripts(
        _dappsBrowserService.chainId, _dappsBrowserService.rpcUrl);
  }

  /// 加载开始
  void onLoadStart(InAppWebViewController controller, Uri? url) async {
    loadProgress.value = 0.2;
  }

  Future<NavigationActionPolicy?> shouldOverrideUrlLoading(
      InAppWebViewController controller,
      NavigationAction navigationAction) async {
    Uri? uri = navigationAction.request.url;

    if (!["http", "https", "file", "chrome", "data", "javascript", "about"]
        .contains(uri?.scheme)) {
      if (true || await canLaunch(uri.toString())) {
        // Launch the App
        await launch(
          uri.toString(),
        );
        // and cancel the request
        return Future.value(NavigationActionPolicy.CANCEL);
      }
    }
    return Future.value(NavigationActionPolicy.ALLOW);
  }

  void onLoadStop(InAppWebViewController controller, Uri? uri) async {
    closeBtnVisible.value = await controller.canGoBack();
    if (!webViewCreated) {
      webViewCreated = true;
      update();
    }
  }

  void onProgressChanged(InAppWebViewController controller, int progress) {
    loadProgress.value = progress / 100;
  }

  void onTitleChanged(InAppWebViewController controller, String? title) async {
    webTitle.value = title ?? '';
  }

  void onConsoleMessage(
      InAppWebViewController controller, ConsoleMessage consoleMessage) {
    debugPrint('JS Console: ${consoleMessage.message}');
  }

  void onLoadError(
      InAppWebViewController controller, Uri? uri, int code, String message) {
    debugPrint('onLoadError: $message');
  }

  void onLoadHttpError(InAppWebViewController controller, Uri? uri,
      int statusCode, String description) {
    debugPrint('onLoadError: $description');
  }

  navtionAction(){
    _dappsBrowserService.navigationActionHandler?.handler(NavigationActionName.showBottomSheet, Get.arguments);
  }

  // Future<void> showActionSheet() async {
  //   final uri = await webViewController?.getUrl();
  //
  //   final topActions = [
  //     {
  //       'title': '切换账号',
  //       'icon': const Icon(CupertinoIcons.money_pound_circle_fill),
  //       'onPress': () {
  //         _dappsBrowserService.navigationActionHandler
  //             ?.handler(NavigationActionName.changeAccount, Get.arguments);
  //       }
  //     },
  //     // {
  //     //   'title': '加入收藏',
  //     //   'icon': const Icon(CupertinoIcons.bookmark),
  //     //   'onPress': () {
  //     //     _dappsBrowserService.navigationActionHandler
  //     //         ?.handler(NavigationActionName.addFavorites, Get.arguments);
  //     //   }
  //     // },
  //
  //     // {
  //     //   'title': '扫码',
  //     //   'icon': const Icon(CupertinoIcons.camera),
  //     //   'onPress': () async {
  //     //     _dappsBrowserService.navigationActionHandler
  //     //         ?.handler(NavigationActionName.scan, Get.arguments);
  //     //   }
  //     // },
  //   ];
  //
  //   final bottomActions = [
  //     // {
  //     //   'title': '浮窗',
  //     //   'icon': const Icon(CupertinoIcons.bolt_fill),
  //     //   'onPress': () {
  //     //     _dappsBrowserService.navigationActionHandler
  //     //         ?.handler(NavigationActionName.floatWindow, Get.arguments);
  //     //   }
  //     // },
  //     // {
  //     //   'title': '投诉',
  //     //   'icon': const Icon(CupertinoIcons.airplane),
  //     //   'onPress': () {
  //     //     _dappsBrowserService.navigationActionHandler
  //     //         ?.handler(NavigationActionName.complaint, Get.arguments);
  //     //   }
  //     // },
  //
  //     {
  //       'title': '分享',
  //       'icon': const Icon(CupertinoIcons.share),
  //       'onPress': () async {
  //         await Share.share(uri.toString(), subject: webTitle.value);
  //       }
  //     },
  //     {
  //       'title': '复制链接',
  //       'icon': const Icon(CupertinoIcons.link),
  //       'onPress': () async {
  //         Clipboard.setData(ClipboardData(text: uri.toString()));
  //         Toast.showInfo('链接已复制到剪切板!');
  //       }
  //     },
  //     {
  //       'title': '刷新',
  //       'icon': const Icon(CupertinoIcons.refresh),
  //       'onPress': () async {
  //         await webViewController?.reload();
  //       },
  //       'onLongPress': () async {
  //         await webViewController?.clearCache();
  //         await webViewController?.reload();
  //       }
  //     },
  //     {
  //       'title': '浏览器中打开',
  //       'icon': const Icon(CupertinoIcons.back),
  //       'onPress': () async {
  //         if (await canLaunch(uri.toString())) {
  //           await launch(uri.toString(), forceSafariVC: false);
  //         }
  //       }
  //     },
  //   ];
  //
  //   // showBrowserActionSheet(Get.context!, '此网页由${uri?.host ?? ''}提供', topActions, bottomActions);
  //
  //   showBrowserBottomSheet(
  //     context: Get.context!,
  //     title: '此网页由${uri?.host ?? ''}提供',
  //     onSwitchAccount: () {
  //       Get.back();
  //       _dappsBrowserService.navigationActionHandler
  //           ?.handler(NavigationActionName.changeAccount, Get.arguments);
  //     },
  //     onCopyLink: () async {
  //       Get.back();
  //       Clipboard.setData(ClipboardData(text: uri.toString()));
  //       Toast.showInfo('链接已复制到剪切板!');
  //     },
  //     onShare: () async {
  //       Get.back();
  //       await Share.share(uri.toString(), subject: webTitle.value);
  //     },
  //     onRefresh: () async {
  //       Get.back();
  //       await webViewController?.clearCache();
  //       await webViewController?.reload();
  //     },
  //     onOpenInBrowser: () async {
  //       Get.back();
  //       if (await canLaunch(uri.toString())) {
  //         await launch(uri.toString(), forceSafariVC: false);
  //       }
  //     },
  //   );
  // }
}
