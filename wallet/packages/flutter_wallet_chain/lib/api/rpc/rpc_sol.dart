import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_wallet_chain/api/generate/generate_sol.dart';
import 'package:flutter_wallet_chain/api/rpc_client.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:solana/solana.dart';
import 'package:web3dart/web3dart.dart';

/// RPC API 服务.
class QiSolRpcService extends IRpcClient {
  late RpcClient httpClient;
  final nodeUrl;

  QiSolRpcService(this.nodeUrl) {
    httpClient = RpcClient(nodeUrl);
  }

  @override
  Future<String> sendBtcTransaction(String from, String to, double amount,
      double feeRate, String privateKey) async {
    final blockHash = await httpClient.getRecentBlockhash();
    final SignedTx signedTx = await GenerateSol.sign(
        from, to, amount, privateKey, blockHash.blockhash);
    return await httpClient.sendTransaction(
      signedTx.encode(),
    );
  }

  Future<String> sendTokenTransaction(String from, String to, double amount,
      double feeRate, String privateKey, String contractAddress) async {
    final blockHash = await httpClient.getRecentBlockhash();
    final SignedTx signedTx = await GenerateSol.sign(
        from, to, amount, privateKey, blockHash.blockhash,
        contract: contractAddress);
    return await httpClient.sendTransaction(
      signedTx.encode(),
    );
  }

  @override
  Future<BigInt> getBalance(String address) async {
    print(address);
    try {
      var request = await httpClient.getBalance(address);
      print(request);
      return BigInt.from(request);
    } catch (e) {
      print(e);
      return BigInt.zero;
    }
  }

  @override
  Future<List<int>> getBlockNumber(String nodeUrl) async {
    try {
      int time = DateTime.now().millisecond;
      var request = await httpClient.getBlockHeight();
      int costTime = DateTime.now().millisecond - time;
      return [request, costTime < 0 ? Random().nextInt(50) : costTime];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<BigInt> getGasPrice() async {
    return BigInt.from(1);
  }

  @override
  Future<BigInt> estimateGas(
      {EthereumAddress? from, EthereumAddress? to, Uint8List? data}) async {
    return BigInt.from(1);
  }

  @override
  Future<BigInt> getTokenBalance(String contractAddress, String address) async {
    print(address);
    try {
      var request = await httpClient.getTokenAccountBalance(address);
      print(request);
      return BigInt.from(request.decimals);
    } catch (e) {
      print(e);
      return BigInt.zero;
    }
  }

  @override
  Future<TransactionInformation?> getTransactionByHash(String hash) async {
    return TransactionInformation.fromMap({
      'gasPrice': '1',
      'blockHash': hash,
      'from': '0x0000000000000000000000000000000000000000',
      'gas': '1',
      'hash': hash,
      'input': '',
      'nonce': '1',
      'value': '1',
      'v': '1',
      'r': '1',
      's': '1',
    });
  }

  @override
  Future<int> getTransactionCount(String address) async {
    return 0;
  }

  @override
  Future<TransactionReceipt?> getTransactionStatus(String hash) async {
    try {
      TransactionDetails? request = await httpClient.getTransaction(hash);
      if (request != null) {
        if (request.meta == null) {
          return TransactionReceipt.fromMap({
            'transactionHash': '0x00',
            'transactionIndex': '0x00',
            'blockHash': '0x00',
            'cumulativeGasUsed': '0x00',
            'blockNumber': request.slot.toString(),
            'gasUsed': 1,
            'status': '0x00',
          });
        }
        return TransactionReceipt.fromMap({
          'transactionHash': '0x00',
          'transactionIndex': '0x00',
          'blockHash': '0x00',
          'cumulativeGasUsed': '0x00',
          'blockNumber': request.slot.toString(),
          'gasUsed': '0x${request.meta!.fee.toRadixString(16)}',
          'status': request.meta!.err == null ? '0x01' : '0x00',
        });
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<String> sendRawTransaction(Uint8List signedTransaction) {
    // TODO: implement sendRawTransaction
    throw UnimplementedError();
  }

  @override
  Future<String> sendTransaction(Transaction transaction,
      {QiCoinKeypair? keypair, String? privateKey, Credentials? credentials}) {
    // TODO: implement sendTransaction
    throw UnimplementedError();
  }

  @override
  Future<String> signTransaction(Transaction transaction,
      {QiCoinKeypair? keypair, String? privateKey, Credentials? credentials}) {
    // TODO: implement signTransaction
    throw UnimplementedError();
  }

  @override
  String signTypeMessage(String message,
      {QiCoinKeypair? keypair, String? privateKey, Credentials? credentials}) {
    // TODO: implement signTypeMessage
    throw UnimplementedError();
  }

  @override
  Future<String> approve(
      String contractAddress, String address, String tokenId) {
    throw UnimplementedError();
  }
}
