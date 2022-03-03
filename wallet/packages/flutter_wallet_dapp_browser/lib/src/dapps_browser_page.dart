part of flutter_wallet_dapp_browser;

class DappsBrowserPage extends GetView<DappsBrowserController> {
  const DappsBrowserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      // extendBodyBehindAppBar: true,
        appBar: BrowserAppBar(
          controller: controller,
          // progress: controller.loadProgress.value,
          // title: controller.webTitle.value,
          backButtonPress: () async {
            await controller.back();
          },
          closeButtonPress: () async {
            if (controller.isEmbedLaunchMode) {
              // 作为为嵌入页启动时，直接关闭整个Flutter界面
              await SystemNavigator.pop();
            } else {
              Get.back();
            }
          },
          actionButtonPress: controller.navtionAction,
        ),
        body: BrowserWillPopScope(
          builder: (context) {
            return _buildBody();
          },
          canPop: () async =>
          await controller.webViewController?.canGoBack() == true,
          willPopCallback: () async {
            if (await controller.webViewController?.canGoBack() == true) {
              await controller.webViewController?.goBack();
              return false;
            }
            if (controller.isEmbedLaunchMode) {
              // 作为为嵌入页启动时，直接关闭整个Flutter界面
              await SystemNavigator.pop();
              return false;
            } else {
              return true;
            }
          },
        ));
  }

  Widget _buildBody() {
    return AfterRouteAnimation(builder: (BuildContext context) {
      return FutureBuilder(future: controller.getWhiteLinkList(), builder: (_,callBackModel){
        if (callBackModel.hasData){
          print('打开swap浏览器链接：${controller.swapUrl}');
          return _buildInWebView(controller.swapUrl);
        }
        return _buildEmptyBody();
      });
    });
  }

  Widget _buildEmptyBody() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
    );
  }

  Widget _buildInWebView(String url) {
    return FutureBuilder(
        future: controller.initialUserScripts,
        builder: (context, AsyncSnapshot script) {
          if (script.hasData) {
            return Stack(children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: Get.bottomBarHeight / Get.pixelRatio),
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(url),
                  ),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      // clearCache: true,
                      useShouldOverrideUrlLoading: true,
                      javaScriptEnabled: true,
                      supportZoom: false,
                    ),
                    // ios: IOSInAppWebViewOptions(disallowOverScroll: false),
                    android: AndroidInAppWebViewOptions(
                      useHybridComposition: true,
                      mixedContentMode:
                          AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                    ),
                  ),
                  onWebViewCreated: controller.onWebViewCreated,
                  onLoadStart: controller.onLoadStart,
                  shouldOverrideUrlLoading: controller.shouldOverrideUrlLoading,
                  onLoadStop: controller.onLoadStop,
                  onProgressChanged: controller.onProgressChanged,
                  onTitleChanged: controller.onTitleChanged,
                  onConsoleMessage: controller.onConsoleMessage,
                  onLoadError: controller.onLoadError,
                  onLoadHttpError: controller.onLoadHttpError,
                  initialUserScripts: script.data,
                ),
              ),
              GetBuilder(
                  init: controller,
                  builder: (_) {
                    return Offstage(
                        offstage: controller.webViewCreated,
                        child: Container(
                          width: Get.width,
                          height: Get.height,
                          color: Colors.white,
                        ));
                  })
            ]);
          }
          return const SizedBox();
        });
  }
}
