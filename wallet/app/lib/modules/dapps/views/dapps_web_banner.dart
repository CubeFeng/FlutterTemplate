import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_wallet/modules/dapps/controllers/dapp_web_controller.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:share_plus/share_plus.dart';

class DappWebBannerPage extends StatelessWidget {
  DappWebBannerPage({Key? key}) : super(key: key);

  final DappWebBannerController _controller = Get.put(DappWebBannerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.transparent,
        // extendBodyBehindAppBar: true,
        appBar: QiAppBar(
          title: Text(_controller.webTitle,
              overflow: TextOverflow.fade, style: const TextStyle(color: Colors.black87, fontSize: 18)),
          actions: [
            _controller.actionBtn.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      CupertinoIcons.share,
                      color: Colors.black87,
                    ),
                    onPressed: () async {
                      await Share.share(Get.parameters['url']!);
                    })
                : const SizedBox(),
          ],
          bottom: PreferredSize(
            child: Obx(() {
              return AnimatedOpacity(
                opacity: _controller.loadProgress.value < 1 ? 1 : 0,
                duration: const Duration(milliseconds: 100),
                child: LinearProgressIndicator(
                  value: _controller.loadProgress.value,
                  valueColor: const AlwaysStoppedAnimation(Colors.blueAccent),
                  minHeight: 2,
                  backgroundColor: Colors.white,
                ),
              );
            }),
            preferredSize: Size(Get.width, 0),
          ),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return AfterRouteAnimation(
        builder: (BuildContext context) {
          return _buildInWebView(Get.parameters['url']!);
        },
        holderWidget: Container(width: double.infinity, height: double.infinity, color: Colors.white));
  }

  Widget _buildInWebView(String url) {
    return Stack(
      children: [
        InAppWebView(
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
              mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            ),
          ),
          onLoadStart: _controller.onLoadStart,
          onProgressChanged: _controller.onProgressChanged,
          onTitleChanged: _controller.onTitleChanged,
          onLoadStop: _controller.onLoadStop,
          onLoadError: _controller.onLoadError,
        ),
        GetBuilder(
            init: _controller,
            builder: (_) {
              return Offstage(
                  offstage: _controller.webViewCreated,
                  child: Container(
                    width: Get.width,
                    height: Get.height,
                    color: Colors.white,
                  ));
            })
      ],
    );
  }
}
