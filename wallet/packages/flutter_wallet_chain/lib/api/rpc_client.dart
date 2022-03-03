import 'dart:typed_data';

import 'package:flutter_wallet_chain/api/rpc/rpc_btc.dart';
import 'package:flutter_wallet_chain/api/rpc/rpc_eth.dart';
import 'package:flutter_wallet_chain/api/rpc/rpc_sol.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

/// RPC API 服务.
abstract class IRpcClient {
  /// 获取RPC客户端.
  static IRpcClient getRpcClient(
      QiCoinType coinType, String nodeUrl, int chainId) {
    if (coinType == QiCoinType.AITD || coinType == QiCoinType.ETH) {
      return QiEthRpcService(Web3Client(nodeUrl, Client()), chainId);
    } else if (coinType == QiCoinType.SOL) {
      return QiSolRpcService(nodeUrl);
    } else {
      return QiBtcRpcService(nodeUrl);
    }
  }

  /// RPC获取gasPrice.
  Future<BigInt> getGasPrice();

  /// RPC获取BlockNumber
  Future<List<int>> getBlockNumber(String nodeUrl);

  /// RPC获取gasLimit.
  Future<BigInt> estimateGas({
    EthereumAddress? from,
    EthereumAddress? to,
    Uint8List? data,
  });

  /// RPC获取余额.
  Future<BigInt> getBalance(String address);

  /// RPC获取nonce.
  Future<int> getTransactionCount(String address);

  /// RPC hash获取交易是否成功.
  Future<TransactionReceipt?> getTransactionStatus(String hash);

  /// RPC hash获取交易详情.
  Future<TransactionInformation?> getTransactionByHash(String hash);

  /// RPC获取余额.
  Future<BigInt> getTokenBalance(String contractAddress, String address);

  /// approve授权.
  Future<String> approve(
      String contractAddress, String address, String tokenId);

  /// signTypeMessage签名.
  String signTypeMessage(String message,
      {QiCoinKeypair? keypair, String? privateKey, Credentials? credentials});

  Future<String> sendRawTransaction(Uint8List signedTransaction);

  /// 签名消息
  Future<String> signTransaction(Transaction transaction,
      {QiCoinKeypair? keypair, String? privateKey, Credentials? credentials});

  /// RPC签名广播.
  Future<String> sendTransaction(Transaction transaction,
      {QiCoinKeypair? keypair, String? privateKey, Credentials? credentials});

  /// RPC签名广播.
  Future<String> sendBtcTransaction(
      String from, String to, double amount, double fee, String privateKey);
}
