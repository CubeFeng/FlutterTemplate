part of flutter_wallet_dapp_browser;

class DappsBrowserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DappsBrowserController());
  }
}
