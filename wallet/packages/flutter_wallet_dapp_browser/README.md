

## 使用准备

1. 通过`Get`初始化**DappsBrowserService**
2. 设置节点信息

```dart
DappsBrowserService.config(chainId, rpcUrl, handlerInterceptor);
```

获取dapp浏览器路由

routeName: 需要自行定义

```dart
DappsBrowserService.browserPage({routeName: '可以自定义, 默认是/dapps_browser'});
```

3. 打开页面

```dart
Get.toNamed('routeName', arguments: {'url': 'dapp url'});
```
