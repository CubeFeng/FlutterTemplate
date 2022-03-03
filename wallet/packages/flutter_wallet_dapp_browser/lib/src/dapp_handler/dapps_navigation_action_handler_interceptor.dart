enum NavigationActionName {
  showBottomSheet, // 底部弹窗

}

abstract class DappsNavigationActionHandlerInterceptor {
  /// [name] 名称
  /// [arguments] Get.arguments 参数
  Future<void> handler(NavigationActionName name, dynamic arguments);
}
