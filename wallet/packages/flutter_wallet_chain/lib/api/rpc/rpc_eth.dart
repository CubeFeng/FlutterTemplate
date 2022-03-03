import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/api/rpc_client.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:http/http.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/src/crypto/secp256k1.dart' as secp256k1;
import 'package:web3dart/src/utils/typed_data.dart';
import 'package:web3dart/web3dart.dart';

/// RPC API 服务.
class QiEthRpcService extends IRpcClient {
  final Web3Client _web3client;
  final int chainId;

  QiEthRpcService(this._web3client, this.chainId);

  /// RPC获取gasPrice.
  Future<BigInt> getGasPrice() async {
    final balance = await _web3client.getGasPrice();
    return balance.getInWei;
  }

  /// RPC获取BlockNumber
  @override
  Future<List<int>> getBlockNumber(String nodeUrl) async {
    try {
      int time = DateTime.now().millisecond;
      final blockNumber = await Web3Client(nodeUrl, Client()).getBlockNumber();
      int costTime = DateTime.now().millisecond - time;
      return [blockNumber, costTime < 0 ? Random().nextInt(50) : costTime];
    } catch (_) {
      return [];
    }
  }

  /// RPC获取gasLimit.
  @override
  Future<BigInt> estimateGas({
    EthereumAddress? from,
    EthereumAddress? to,
    Uint8List? data,
  }) async {
    final balance =
        await _web3client.estimateGas(sender: from, to: to, data: data);
    return balance;
  }

  /// RPC获取余额.
  @override
  Future<BigInt> getBalance(String address) async {
    final balance =
        await _web3client.getBalance(EthereumAddress.fromHex(address));
    return balance.getInWei;
  }

  /// RPC获取nonce.
  @override
  Future<int> getTransactionCount(String address) async {
    final balance =
        await _web3client.getTransactionCount(EthereumAddress.fromHex(address));
    return balance;
  }

  /// RPC hash获取交易是否成功.
  @override
  Future<TransactionReceipt?> getTransactionStatus(String hash) async {
    try{
      return await _web3client.getTransactionReceipt(hash);
    }catch(e){
    }
  }

  /// RPC hash获取交易详情.
  @override
  Future<TransactionInformation?> getTransactionByHash(String hash) async {
    try{
      return await _web3client.getTransactionByHash(hash);
    }catch(e){
    }
  }

  /// RPC获取余额.
  @override
  Future<BigInt> getTokenBalance(String contractAddress, String address) async {
    //把 balanceOf(address) 经过 sha3 取除了 0x 外，前面的 8 位  sha3("balanceOf(address)").substr(2,8)>> 70a08231
    final data = '0x' +
        bytesToHex(keccakUtf8('balanceOf(address)').sublist(0, 4)) +
        '000000000000000000000000' +
        (address.startsWith('0x') ? address.substring(2) : address);
    final balance = await _web3client.callRaw(
        contract: EthereumAddress.fromHex(contractAddress),
        data: hexToBytes(data));
    return BigInt.parse(balance);
  }

  /// approve授权.
  @override
  Future<String> approve(
      String contractAddress, String address, String tokenId) async {
    //把 balanceOf(address) 经过 sha3 取除了 0x 外，前面的 8 位  sha3("balanceOf(address)").substr(2,8)>> 70a08231
    var data = '0x' +
        bytesToHex(keccakUtf8('approve(address,uint256)').sublist(0, 4)) +
        '000000000000000000000000' +
        (address.startsWith('0x') ? address.substring(2) : address) +
        '00000000000000000000000000000000000000000000000000000000000000$tokenId';
    print(data);
    final result = await _web3client.callRaw(
        contract: EthereumAddress.fromHex(contractAddress),
        data: hexToBytes(data));
    return result;
  }

  /// signTypeMessage签名.
  @override
  String signTypeMessage(String message,
      {QiCoinKeypair? keypair, String? privateKey, Credentials? credentials}) {
    if (credentials == null) {
      if (keypair != null) {
        credentials = EthPrivateKey.fromHex(keypair.privateKey);
      }
      if (privateKey != null) {
        credentials = EthPrivateKey.fromHex(privateKey);
      }
    }
    var ethPrivateKey = credentials as EthPrivateKey?;
    final messageHash = hexToBytes(message);
    final result = ethPrivateKey!.signTypeMessage(messageHash);
    return bytesToHex(result, include0x: true, padToEvenLength: true);
  }

  /// 签名消息
  @override
  Future<String> signTransaction(Transaction transaction,
      {QiCoinKeypair? keypair,
      String? privateKey,
      Credentials? credentials}) async {
    if (credentials == null) {
      if (keypair != null) {
        credentials = EthPrivateKey.fromHex(keypair.privateKey);
      }
      if (privateKey != null) {
        credentials = EthPrivateKey.fromHex(privateKey);
      }
    }
    final result = await _web3client.signTransaction(
      credentials!,
      transaction,
      chainId: chainId,
    );
    return bytesToHex(result, include0x: true, padToEvenLength: true);
  }

  @override
  Future<String> sendRawTransaction(Uint8List signedTransaction) async {
    final result = await _web3client.sendRawTransaction(signedTransaction);
    return result;
  }

  /// RPC签名广播.
  @override
  Future<String> sendTransaction(Transaction transaction,
      {QiCoinKeypair? keypair,
      String? privateKey,
      Credentials? credentials}) async {
    if (credentials == null) {
      if (keypair != null) {
        credentials = EthPrivateKey.fromHex(keypair.privateKey);
      }
      if (privateKey != null) {
        credentials = EthPrivateKey.fromHex(privateKey);
      }
    }
    final result = await _web3client.sendTransaction(
      credentials!,
      transaction,
      chainId: chainId,
    );
    return result;
  }


  @override
  Future<String> sendBtcTransaction(String from, String to, double amount, double fee, String privateKey) {
    throw UnimplementedError();
  }
}

///扩展signTypeMessage
extension SignExtension on EthPrivateKey {
  Uint8List signTypeMessage(Uint8List payload) {
    final signature = secp256k1.sign(payload, privateKey);
    final r = padUint8ListTo32(unsignedIntToBytes(signature.r));
    final s = padUint8ListTo32(unsignedIntToBytes(signature.s));
    final v = unsignedIntToBytes(BigInt.from(signature.v));
    return uint8ListFromList(r + s + v);
  }

}
