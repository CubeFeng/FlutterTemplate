import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/api_urls.dart';
import 'package:flutter_ucore/common/in_app_navigator_observer.dart';
import 'package:flutter_ucore/database/entity/message_entity.dart';
import 'package:flutter_ucore/events/event.dart';
import 'package:flutter_ucore/events/message_event.dart';
import 'package:flutter_ucore/models/user/app_information_model.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/services/config_service.dart';
import 'package:flutter_ucore/services/db_service.dart';
import 'package:flutter_ucore/services/http_service.dart';
import 'package:flutter_ucore/theme/text_style.dart';

class MessageService extends GetxService
    with WidgetsBindingObserver, InAppRouteListener {
  static MessageService get service => Get.find();

  /// 消息未读数据量
  RxInt _unReadMessageCount = 0.obs;

  int get unReadMessageCount => _unReadMessageCount.value;

  late NeWebSocket _ws;

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  /// 是否可以连接, 用于未登录情况
  bool _canConnect = true;

  @override
  void onInit() {
    super.onInit();

    /// 创建 ws
    _ws = NeWebSocket(
      ApiUrls.apiHost.wsHost,
      onOpen: _onOpen,
      onMessage: _onMessage,
      onClose: _onClose,
      onError: _onError,
      enableLog: kDebugMode,
      heartTimes: const Duration(seconds: 10),
      heartMessage: _heartMessage,
    );
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(onConnectivityChanged);

    /// 监听应用前后台
    WidgetsBinding.instance?.addObserver(this);

    /// 监听应用内路由
    InAppNavigatorObserver().addListener(this);

    /// 更新app角标
    _unReadMessageCount.listen((int count) {
      FlutterAppBadger.updateBadgeCount(count);
    });

    _updateUnReadMessageCount();
  }

  @override
  void didInAppRouteStartUserGesture(Route route, Route? previousRoute) {
    // 检测到用户开始操作路由手势时先关闭TopBanner
    if (Get.isSnackbarOpen == true) {
      Get.back();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_canConnect) {
          if (_ws.status == SocketStatus.connected) {
            _ws.heartBeatSubscription?.resume();
          } else {
            _ws.connect();
          }
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _ws.heartBeatSubscription?.pause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void onReady() {
    super.onReady();

    /// 之后登录状态才进行获取消息
    if (AuthService.to.isLoggedInValue) {
      _ws.connect();
    } else {
      _canConnect = false;
    }
    AuthService.to.isLogin.listen((bool isLogin) {
      if (isLogin) {
        _canConnect = true;
        _ws.connect();
        _updateUnReadMessageCount();
      } else {
        _canConnect = false;
        _ws.heartBeatSubscription?.cancel();
        _ws.close();
        _unReadMessageCount.value = 0;
      }
    });
  }

  /// 打开后, 请求授权
  void _onOpen() async {
    final userId = AuthService.to.userModel?.userId ?? '';
    _ws.send(json.encode({
      "header": {
        "to": "advisory-message-server",
        "from": userId,
        "token": AuthService.to.accessToken ?? '',
        "method": "/rox/auth",
        "qos": 1,
        "serialId": "${userId}${RandomUtils.uniqueString()}",
        "appId": ConfigService.service.appId,
        "direct": "PUBLISH",
        "timestramp": DateTime.now().millisecondsSinceEpoch ~/ 1000
      },
      "body": {"state": RandomUtils.uniqueString()}
    }));
    _ws.initHeartBeat();
  }

  void _onMessage(dynamic msg) async {
    if (msg != null) {
      try {
        var data = json.decode(msg);
        var header = data['header'];
        if (header['direct'] != 'PUBLISH') {
          return;
        }
        var method = header['method'];
        var body = data['body'];

        /// 反馈消息
        var reportMsg = {
          'header': {
            'method': method,
            'qos': 2,
            'serialId': header['serialId'],
            'direct': 'PUBACK',
            'timestramp': DateTime.now().millisecondsSinceEpoch ~/ 1000
          },
          'body': {'code': '0', 'msg': '成功', 'data': {}}
        };
        _ws.send(json.encode(reportMsg));

        if (method == '/rox/sms') {
          body['sender'] = header['from'];
          body['recver'] = header['to'];
          _saveMessage([body as Map<String, dynamic>]);
        } else if (method == '/rox/batch/sms') {
          _saveMessage(
              (body as List).map((e) => e as Map<String, dynamic>).toList());
        }
      } catch (e) {
        logger.e(e);
      }
    }
  }

  void _saveMessage(List<Map<String, dynamic>> data) async {
    logger.d('save message');
    for (var i = 0; i < data.length; i++) {
      final msg = data[i];
      final info = await _fetchAppInfo(msg['sender'] as String);
      if (info != null) {
        msg['appId'] = info.appId;
        msg['icon'] = info.appHeader;
        msg['appName'] = info.appName;
        msg['userId'] = AuthService.to.userModel?.userId ?? '';
        int id = await DBService.service.messageDao
            .insertMessage(MessageEntity.fromJson(msg));
        MessageEntity? message =
            await DBService.service.messageDao.findMessageById(id);
        if (message != null) {
          if (Get.currentRoute != Routes.USER_MESSAGE &&
              Get.currentRoute != Routes.USER_MESSAGE_DETAIL) {
            Get.snackbar(message.appName, message.vo.title,
                barBlur: 100,
                animationDuration: Duration(milliseconds: 400),
                titleText: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(message.appName, style: TextStyles.textBold14)),
                messageText: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(message.vo.title, style: TextStyles.text)),
                icon: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: ClipRRect(
                    child: LoadImage(message.icon),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ), onTap: (_) {
              message.isRead = true;
              updateMessag(message);
              Get.toNamed(Routes.USER_MESSAGE_DETAIL, arguments: message.vo);
            });
          }
          if (eventBus.publishSubject.hasListener) {
            eventBus.fire(OnReciveMessageEvent(message));
          }
        }
      }
    }
    _updateUnReadMessageCount();
  }

  /// 更新 message
  Future<void> updateMessag(MessageEntity msg) async {
    await DBService.service.messageDao.updateMessag(msg);
    _updateUnReadMessageCount();
  }

  Future<List<MessageEntity>> getMessageList() {
    final userId = AuthService.to.userModel?.userId;
    if (userId == null) {
      return Future.value([]);
    }
    return DBService.service.messageDao.findAllByUserId(userId);
  }

  /// 更新未读消息数量
  void _updateUnReadMessageCount() {
    final userId = AuthService.to.userModel?.userId;
    if (userId == null) {
      _unReadMessageCount.value = 0;
      return;
    }
    DBService.service.messageDao.findAllByUserId(userId).then(
        (value) => _unReadMessageCount.value = value.count((it) => !it.isRead));
  }

  void _onClose() {
    logger.d('onClose');
  }

  bool _isConnecting = false;

  void _onError(WebSocketChannelException e) {
    logger.w(e.message);
    if (_canConnect && !_isConnecting) {
      _isConnecting = true;
      _ws.reconnect().then((value) => _isConnecting = false);
    }
  }

  Future<dynamic> _heartMessage() async {
    final userId = AuthService.to.userModel?.userId ?? '';
    return json.encode({
      "header": {
        "method": "/rox/heart",
        "serialId": "${userId}${RandomUtils.uniqueString()}",
        "direct": "PUBLISH",
        "timestramp": DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "qos": 1
      },
      "body": {}
    });
  }

  /// 获取 app 信息
  Future<AppInformationModel?> _fetchAppInfo(String appId) async {
    final res = await HttpService.service.http
        .post<AppInformationModel>(ApiUrls.getAppInfo, data: {"appId": appId});
    if (res.code == 0 && res.data != null) {
      return res.data;
    }
    return null;
  }

  void onConnectivityChanged(ConnectivityResult result) {
    /// 如果没有网络
    if (result == ConnectivityResult.none) {
      _ws.heartBeatSubscription?.cancel();
      _ws.close();
    } else {
      if (_canConnect &&
          _ws.status != SocketStatus.connected &&
          _ws.status != SocketStatus.connecting) {
        _ws.connect();
      }
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    _ws.heartBeatSubscription?.cancel();
    WidgetsBinding.instance?.removeObserver(this);
    InAppNavigatorObserver().removeListener(this);
    _ws.close();
    super.onClose();
  }
}
