import 'dart:typed_data';

import 'package:flutter_wallet_chain/api/rpc_client.dart';
import 'package:flutter_wallet_chain/model/net_info.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:web3dart/web3dart.dart';

/// RPC API 服务.
class QiRpcService {
  static final QiRpcService _instance = QiRpcService._internal();

  ///工厂方法获取该类的实例
  factory QiRpcService() {
    return _instance;
  }

  ///walletConnect服务
  static QiRpcServiceConnect() {
    return QiRpcService._internal();
  }

  // 隐藏了构造方法
  QiRpcService._internal() {
    switchChainNet(_defaultNet);

    final supportCoins = QiCoinType.values;
    supportCoins.forEach((element) {
      if (element.isSupport()) {
        _supportCoins.add(element);
      }
    });
  }

  /// 切换使用的链网络，分为测试网和主网
  void switchChainNet(QiChainNet chainNet) {
    List configure;
    if (chainNet == QiChainNet.TEST_NET) {
      configure = _rpcConfigure['test'];
    } else {
      configure = _rpcConfigure['main'];
    }
    configure.forEach((item) {
      final qiRpcConfig = QiRpcConfig.fromJson(item);
      _rpcConfig[qiRpcConfig.coinType] = qiRpcConfig;
    });
  }

  QiCoinType _coinType = QiCoinType.AITD;
  late QiRpcConfig _currentRpc;
  late String _currentNodeUrl;
  late IRpcClient _web3client;
  final List<QiCoinType> _supportCoins = [];

  ///当前APP支持的链
  List<QiCoinType> get supportCoins => _supportCoins;

  ///当前APP使用的链
  QiCoinType get coinType => _coinType;

  /// 获取当前的Web3Client
  IRpcClient get web3client => _web3client;

  /// 获取当前的RPC信息
  QiRpcConfig get currentRpc => _currentRpc;

  ///当前使用的节点
  String get currentNodeUrl => _currentNodeUrl;

  /// 切换使用的链
  Future<void> switchChain(QiCoinType coinType, String? nodeUrl) async {
    _coinType = coinType;
    _currentRpc = qiGetRpcConfig(coinType)!;
    _currentNodeUrl = nodeUrl ?? _currentRpc.nodes[0];
    _web3client = IRpcClient.getRpcClient(
        coinType, _currentNodeUrl, _currentRpc.chainId);
  }

  /// 切换节点
  changeNodeUrl(String nodeUrl) {
    _currentNodeUrl = nodeUrl;
    _web3client =
        IRpcClient.getRpcClient(coinType, nodeUrl, _currentRpc.chainId);
  }

  /// 网络节点替换本地节点
  fetchNodes(QiCoinType coinType, List<String>? nodes) {
    for (var item in _rpcConfig.keys) {
      if (item == coinType) {
        QiRpcConfig? itemConfig = _rpcConfig[item];
        if (itemConfig != null && nodes != null && nodes.length > 0) {
          itemConfig.nodes = nodes;
        }
      }
    }
  }

  /// RPC获取gasPrice.
  Future<BigInt> getGasPrice() async {
    return await _web3client.getGasPrice();
  }

  /// RPC获取BlockNumber
  Future<List<int>> getBlockNumber(String nodeUrl) async {
    return await _web3client.getBlockNumber(nodeUrl);
  }

  /// RPC获取gasLimit.
  Future<BigInt> estimateGas({
    EthereumAddress? from,
    EthereumAddress? to,
    Uint8List? data,
  }) async {
    return await _web3client.estimateGas(from: from, to: to, data: data);
  }

  /// RPC获取余额.
  static Future<BigInt> getCoinBalance(
      QiCoinType coinType, String? node, String address) async {
    IRpcClient _web3client = IRpcClient.getRpcClient(
        coinType, node ?? qiGetRpcConfig(coinType)!.nodes[0], 1);
    return await _web3client.getBalance(address);
  }

  /// RPC获取余额.
  Future<BigInt> getBalance(String address) async {
    return await _web3client.getBalance(address);
  }

  /// RPC获取nonce.
  Future<int> getTransactionCount(String address) async {
    return await _web3client.getTransactionCount(address);
  }

  /// RPC hash获取交易是否成功.
  Future<TransactionReceipt?> getTransactionStatus(String hash) async {
    return await _web3client.getTransactionStatus(hash);
  }

  /// RPC hash获取交易详情.
  Future<TransactionInformation?> getTransactionByHash(String hash) async {
    return await _web3client.getTransactionByHash(hash);
  }

  /// RPC获取余额.
  Future<BigInt> getTokenBalance(String contractAddress, String address) async {
    return await _web3client.getTokenBalance(contractAddress, address);
  }

  /// approve授权.
  Future<String> approve(
      String contractAddress, String address, String tokenId) async {
    return await _web3client.approve(contractAddress, address, tokenId);
  }

  /// signTypeMessage签名.
  String signTypeMessage(String message,
      {QiCoinKeypair? keypair, String? privateKey, Credentials? credentials}) {
    return _web3client.signTypeMessage(message,
        keypair: keypair, privateKey: privateKey, credentials: credentials);
  }

  /// 签名消息
  Future<String> signTransaction(Transaction transaction,
      {QiCoinKeypair? keypair,
      String? privateKey,
      Credentials? credentials}) async {
    return _web3client.signTransaction(transaction,
        keypair: keypair, privateKey: privateKey, credentials: credentials);
  }

  Future<String> sendRawTransaction(Uint8List signedTransaction) async {
    return await _web3client.sendRawTransaction(signedTransaction);
  }

  /// RPC签名广播.
  Future<String> sendTransaction(Transaction transaction,
      {QiCoinKeypair? keypair,
      String? privateKey,
      Credentials? credentials}) async {
    return _web3client.sendTransaction(transaction,
        keypair: keypair, privateKey: privateKey, credentials: credentials);
  }

  /// RPC签名广播.
  Future<String> sendBtcTransaction(String from, String to, double amount, double fee, String privateKey) async {
    return _web3client.sendBtcTransaction(from, to, amount, fee, privateKey);
  }

  /// 设置默认的网络
  static void setChainNet(QiChainNet net) {
    _defaultNet = net;
  }
}

///通过链ID获取当前链
QiCoinType qiFindChainById(int? id) {
  for (var item in _rpcConfig.keys) {
    QiRpcConfig itemConfig = _rpcConfig[item]!;
    if (itemConfig.chainId == id) {
      return item;
    }
  }
  return QiCoinType.AITD;
}

/// 所有的RPC配置
final Map<QiCoinType, QiRpcConfig> _rpcConfig = <QiCoinType, QiRpcConfig>{};

/// 获取当前的RPC配置
QiRpcConfig? qiGetRpcConfig(QiCoinType coinType) => _rpcConfig[coinType];

QiChainNet _defaultNet = QiChainNet.TEST_NET;

/// 是否是测试网
bool isTestNet() {
  return _defaultNet == QiChainNet.TEST_NET;
}

/// RPC的一些配置信息
final dynamic _rpcConfigure = {
  'main': [
    {
      'chain': 'aitd',
      'nodes': [
        'http://18.141.247.72:8545',
        'http://113.31.105.131:18545',
        'http://13.213.171.94:8545',
      ],
      'chainId': 19
    },
    {
      'chain': 'eth',
      'nodes': [
        'https://mainnet.infura.io/v3/12298ac6e6bd44c9aa132efc1a43453c'
      ],
      'chainId': 1
    },
    {
      'chain': 'sol',
      'nodes': ['https://lingering-green-pine.solana-testnet.quiknode.pro/f6f294f614352deb7f59ce5d4d8bfad41112ef89/'],
      'chainId': 501
    }
  ],
  'test': [
    {
      'chain': 'aitd',
      'nodes': ['http://http-testnet.aitd.io', 'http://113.31.105.131:8545/'],
      'chainId': 239
    },
    {
      'chain': 'eth',
      'nodes': ['http://54.151.168.225:7545'],
      'chainId': 1337
    },
    {
      'chain': 'btc',
      'nodes': ['http://192.168.1.16:18443'],
      'chainId': 0
    },
    {
      'chain': 'sol',
      'nodes': ['https://lingering-green-pine.solana-testnet.quiknode.pro/f6f294f614352deb7f59ce5d4d8bfad41112ef89/'],
      'chainId': 501
    }
  ]
};
