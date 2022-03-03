import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/modules/dapps/connect/controllers/wallet_connect_history_controller.dart';
import 'package:flutter_wallet/modules/home/controllers/home_controller.dart';
import 'package:flutter_wallet/modules/wallet/create/controllers/wallet_create_controller.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/security_service.dart';
import 'package:flutter_wallet/widgets/modals/transaction_fee_modal.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:intl/intl.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:wallet_connect/wc_session_store.dart';
import 'package:web3dart/src/crypto/formatting.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/foundation.dart';

/// 数据库服务
class WalletConnectService extends GetxService {
  /// 数据库服务实例
  static WalletConnectService get to => Get.find();

  /// 数据库服务实例
  static WalletConnectService get service => Get.find();

  List<ConnectService> connectServiceList = [];

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadService();
  }

  remove(ConnectService service) {
    service.killSession();
  }

  List<ConnectService> getConnectedService() {
    List<ConnectService> list = [];
    for (ConnectService service in connectServiceList) {
      if (service.status == '2') {
        list.add(service);
      }
    }
    return list;
  }

  loadService() async {
    final connectMaps =
        StorageUtils.sp.read<List<String>>('walletConnectHistoryList');
    if (connectMaps != null && connectMaps.isNotEmpty) {
      for (var element in connectMaps) {
        dynamic params = json.decode(element);
        String connectUrl = params['url'];

        print(params);

        ConnectService? connectService;
        for (var element in connectServiceList) {
          if (element.connectUrl == connectUrl) {
            connectService = element;
          }
        }
        if (connectService == null) {
          ConnectService connectService = ConnectService();
          WCSessionStore session = WCSessionStore.fromJson(params);
          int? coinId = params['coinId'];
          if (coinId != null) {
            Coin? coin = await DBService.service.coinDao.findById(coinId);
            connectService.coin = coin;
            connectService.status =
                coin == null ? '3' : params['status'] ?? '0';
          }
          connectService.connectUrl = connectUrl;
          connectService.time =
              params['time'] ?? DateTime.now().millisecondsSinceEpoch;
          connectService.count = params['count'] ?? 0;
          connectService._sessionStore = session;
          connectService.myPeerMeta = session.remotePeerMeta;
          connectServiceList.add(connectService);
        } else {
          connectService.count = params['count'] ?? 0;
        }
      }
    }
  }

  ///创建 Peer Meta
  qrScanHandler(String url) {
    for (var element in connectServiceList) {
      if (element.connectUrl == url) {
        return element;
      }
    }
    ConnectService connectService = ConnectService();
    return connectService;
  }

  reconnect(ConnectService service) {
    service.connectToPreviousSession();
  }

  saveService(ConnectService service) async {
    ConnectService? exitService;
    for (var element in connectServiceList) {
      if (element.myPeerMeta.url == service.myPeerMeta.url) {
        exitService = element;
      }
    }
    if (exitService != null) {
      exitService.stopRunning();
      service.count = exitService.count;
      connectServiceList.remove(exitService);
    }
    service.time = DateTime.now().millisecondsSinceEpoch;
    connectServiceList.add(service);
    connectServiceList.sort((left, right) => right.time.compareTo(left.time));
    List<String> strings = [];
    for (var element in connectServiceList) {
      if (element._sessionStore != null) {
        WCSessionStore session = element._sessionStore!;
        Map<String, dynamic> itemMap = session.toJson();
        itemMap['coinId'] = element.coin != null ? element.coin!.id : null;
        itemMap['url'] = element.connectUrl;
        itemMap['count'] = element.count;
        itemMap['status'] = element.status;
        itemMap['time'] = element.time;
        strings.add(json.encode(itemMap));
      }
    }
    StorageUtils.sp.write('walletConnectHistoryList', strings);

    if (Get.isRegistered<HomeController>()) {
      if (Get.isRegistered<WalletConnectHistoryController>() == false) {
        await loadService();
      }
      Get.find<HomeController>().update();
    }
  }
}

class ConnectService {
  late WCClient _wcClient;
  String status = "0";
  String preStatus = "-1";
  late String connectUrl;
  WCSessionStore? _sessionStore;
  late WCPeerMeta myPeerMeta;
  Coin? coin;
  int time = DateTime.now().millisecondsSinceEpoch;
  int count = 0;
  late QiRpcService qiRpcService;

  getAddress() {
    if (coin == null) {
      return '';
    }
    return coin!.coinAddress!;
  }

  getWCClient() {
    return _wcClient;
  }

  getSession() {
    return _sessionStore;
  }

  isConnected() {
    return status == "2";
  }

  isConnecting() {
    return status == "0";
  }

  getIcon() {
    if (_sessionStore != null) {
      print(_sessionStore!.remotePeerMeta.icons[0]);
      return _sessionStore!.remotePeerMeta.icons[0];
    }
    return '';
  }

  getName() {
    if (_sessionStore != null) {
      return _sessionStore!.remotePeerMeta.name;
    }
    return '';
  }

  getUrl() {
    if (_sessionStore != null) {
      return _sessionStore!.remotePeerMeta.url;
    }
    return '';
  }

  String getTime() {
    return DateFormat("yyyy-MM-dd HH:mm")
        .format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  ConnectService() {
    _wcClient = WCClient(
      onSessionRequest: _onSessionRequest,
      onFailure: _onSessionError,
      onDisconnect: _onSessionClosed,
      onEthSign: _onSign,
      onEthSignTransaction: _onSignTransaction,
      onEthSendTransaction: _onSignTransaction,
      onCustomRequest: (_, __) {},
      onConnect: _onConnect,
    );
  }

  VoidCallback? listener;

  void setListener(VoidCallback listener) {
    this.listener = listener;
  }

  void setSession(WCSessionStore sessionStore) {
    _sessionStore = sessionStore;
  }

  void connect(String connectUrl) {
    this.connectUrl = connectUrl;
    if (connectUrl.startsWith('wc:')) {
      if (connectUrl.contains('bridge') && connectUrl.contains('key')) {
        print("Wallet connect ===== URL：$connectUrl");
        final session = WCSession.from(connectUrl);
        print('session $session');
        final peerMeta = WCPeerMeta(
          name: "Aitd Wallet",
          url: "https://walletconnect.org",
          description: "Aitd Wallet",
          icons: ["http://swap-pre.aitd.io/favicon.png"],
        );
        try {
          _wcClient.connectNewSession(session: session, peerMeta: peerMeta);
        } catch (e) {
          print(e);
        }
      }
    } else {
      Toast.show("Wallet Connect URL Error");
      Get.back();
    }
  }

  connectToPreviousSession() {
    print("Wallet connect ===== connectToPreviousSession");
    if (_sessionStore != null) {
      _wcClient.connectFromSessionStore(_sessionStore!);
    } else {
      Toast.show("No previous session found.");
    }
  }

  approveSession(Coin coin) {
    print("Wallet connect ===== approveSession");
    this.coin = coin;
    qiRpcService = QiRpcService.QiRpcServiceConnect();
    final selectCoinType = QiCoinCode44.parse(coin.coinType ?? '');
    qiRpcService.switchChain(selectCoinType,
        StorageUtils.sp.read<String>('currentNode-' + (coin.coinType ?? '')));

    _wcClient.approveSession(
      accounts: [coin.coinAddress!],
      chainId: _wcClient.chainId,
    );
    _sessionStore = _wcClient.sessionStore;
  }

  rejectSession() {
    print("Wallet connect ===== rejectSession");
    _wcClient.rejectSession();
  }

  killSession() {
    print("Wallet connect ===== killSession");
    if (_wcClient.session == null) {
      _onSessionClosed(0, '');
      return;
    }
    try {
      _wcClient.killSession();
    } catch (_) {
      _onSessionClosed(0, '');
    }
  }

  _onSign(int id, WCEthereumSignMessage message) async {
    print("Wallet connect ===== onSign message：$message");

    final isOpenBiometryPay = await SecurityService.to.isOpenBiometryPay;
    UniModals.showVerifySecurityPasswordModal(
      onSuccess: () {},
      onPasswordGet: (password) {
        String data = message.data ?? "";
        var hash = qiRpcService.signTypeMessage(data,
            privateKey:
                WalletCreateController.decrypt(coin!.privateKey!, password));
        print("发送签名： $hash");
        _wcClient.approveRequest<String>(
          id: id,
          result: hash,
        );
      },
      passwordAuthOnly: !isOpenBiometryPay,
      switchPasswordAuto: !isOpenBiometryPay,
    );
  }

  _onSignTransaction(int id, WCEthereumTransaction transaction) {
    print("Wallet connect ===== onSignTransactio message：$transaction");
    String data = transaction.data;
    String gas = strip0x(transaction.gas ?? '');
    String value = strip0x(transaction.value ?? '0');
    Get.bottomSheet(
      TransactionFeeModal(
        onConfirmCallback: (gasPrice) async {
          EtherAmount price = EtherAmount.inWei(BigInt.from(gasPrice));
          Get.back();
          final isOpenBiometryPay = await SecurityService.to.isOpenBiometryPay;
          UniModals.showVerifySecurityPasswordModal(
            onSuccess: () {},
            onPasswordGet: (password) async {
              int c =
                  await qiRpcService.getTransactionCount(coin!.coinAddress!);

              Transaction myTransaction = Transaction(
                  to: EthereumAddress.fromHex(transaction.to),
                  gasPrice: price,
                  maxGas: BigInt.parse(gas, radix: 16).toInt(),
                  data: hexToBytes(data),
                  nonce: c,
                  value: EtherAmount.inWei(BigInt.parse(value, radix: 16)));

              var hash = await qiRpcService.sendTransaction(myTransaction,
                  privateKey: WalletCreateController.decrypt(
                      coin!.privateKey!, password));
              print("发送签名： $hash");
              _wcClient.approveRequest<String>(
                id: id,
                result: hash,
              );
              count++;
              if (listener != null) {
                listener!.call();
              }
              await WalletConnectService.service.saveService(this);
            },
            passwordAuthOnly: !isOpenBiometryPay,
            switchPasswordAuto: !isOpenBiometryPay,
          );
        },
        amount: value,
        gasLimit: BigInt.from(int.parse(gas, radix: 16)),
      ),
      isScrollControlled: true,
    );
  }

  ///请求 会话
  _onSessionRequest(int id, WCPeerMeta peerMeta) async {
    print("Wallet connect ===== SessionRequest $peerMeta");
    myPeerMeta = peerMeta;
    preStatus = status;
    status = "1";
    if (listener != null) {
      listener!.call();
    }
  }

  ///已经链接
  _onConnect() async {
    print("Wallet connect ===== onConnect");
    preStatus = status;
    status = "2";
    await WalletConnectService.service.saveService(this);
    if (listener != null) {
      listener!.call();
    }
    if (Get.isRegistered<WalletConnectHistoryController>()) {
      Get.find<WalletConnectHistoryController>().update();
    }
    timer = Timer.periodic(const Duration(milliseconds: 3000), (t) {
      print('执行心跳');
      if (_wcClient.session == null) {
        timer!.cancel();
        return;
      }
      _wcClient.approveRequest(id: -1, result: []);
    });
  }

  Timer? timer;

  _onSessionClosed(int? code, String? reason) async {
    print("Wallet connect ===== SessionClosed reason：$reason");
    preStatus = status;
    status = "3";
    if (preStatus == '2') {
      await WalletConnectService.service.saveService(this);
    }
    if (listener != null) {
      listener!.call();
    }
    if (Get.isRegistered<WalletConnectHistoryController>()) {
      Get.find<WalletConnectHistoryController>().update();
    }
    if (timer != null) {
      timer!.cancel();
    }
  }

  _onSessionError(dynamic message) async {
    _onSessionClosed(0, 'reason');
  }

  String getChain() {
    if (_sessionStore != null) {
      return qiFindChainById(_sessionStore!.chainId).coinUnit();
    }
    return '';
  }

  void stopRunning() {
    if (timer != null) {
      timer!.cancel();
    }
  }
}
