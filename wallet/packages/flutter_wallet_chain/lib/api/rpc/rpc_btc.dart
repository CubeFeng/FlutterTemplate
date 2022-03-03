import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/api/rpc_client.dart';
import 'package:flutter_wallet_chain/btc/bitcoin_flutter.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

/// RPC API 服务.
class QiBtcRpcService extends IRpcClient {
  var httpClient = HttpClient();
  final nodeUrl;

  QiBtcRpcService(this.nodeUrl);

  @override
  Future<String> sendBtcTransaction(String from, String to, double amount,
      double feeRate, String privateKey) async {
    final keyPair = ECPair.fromWIF(privateKey);
    final transactionBuilder =
        TransactionBuilder(network: isTestNet() ? testnet : bitcoin);
    transactionBuilder.setVersion(1);
    var request = await httpClient.postUrl(Uri.parse(nodeUrl));
    Map jsonRpc = {
      "jsonrpc": "1.0",
      "method": "listunspent",
      "params": [
        6,
        9999999,
        [from],
        true,
        {"minimumAmount": 0.0001}
      ]
    };
    request.headers.set("Authorization", "Basic ZGV2OmE=");
    request.add(utf8.encode(json.encode(jsonRpc)));
    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    Map jsonBody = jsonDecode(responseBody);
    List result = jsonBody['result'];
    result.sort((left, right) => right['amount'].compareTo(left['amount']));
    //result.sort((left, right) => left['amount'].compareTo(right['amount']));
    double fee = feeRate; //getFee(result, amount, feeRate);
    fee = fee < 0.0001 ? 0.0001 : fee;

    print('output:${to}， amount:${(amount * pow(10, 8)).toInt()}， ');
    transactionBuilder.addOutput(to, (amount * pow(10, 8)).toInt());
    double totalMoney = 0;
    int index = 0;
    for (Map item in result) {
      totalMoney += item['amount'];
      print('input:${item['txid']}， amount:${item['amount']}， ');
      transactionBuilder.addInput(item['txid'], item['vout']);
      index++;
      if (totalMoney > amount + fee) {
        if (totalMoney - (amount + fee) > 0.0000055) {
          //留有余量防止粉尘交易。
          transactionBuilder.addOutput(
              from, ((totalMoney - (amount + fee)) * pow(10, 8)).toInt());
          print(
              'output:${from}， amount:${((totalMoney - (amount + fee)) * pow(10, 8)).toInt()}， ');
        }
        break;
      }
    }
    for (var i = 0; i < index; i++) {
      transactionBuilder.sign(vin: i, keyPair: keyPair);
    }
    String hex = transactionBuilder.build().toHex();
    print(hex);
    request = await httpClient.postUrl(Uri.parse(nodeUrl));
    jsonRpc = {
      "jsonrpc": "1.0",
      "method": "sendrawtransaction",
      "params": [hex]
    };
    request.headers.set("Authorization", "Basic ZGV2OmE=");
    request.add(utf8.encode(json.encode(jsonRpc)));
    response = await request.close();
    responseBody = await response.transform(utf8.decoder).join();
    jsonBody = jsonDecode(responseBody);
    print(jsonBody);
    return jsonBody['result'];
  }

  getFee(List result, double amount, double feeRate) {
    double fee = 0;
    int inputNum = 0;
    double totalMoney = 0;
    for (Map item in result) {
      inputNum++;
      totalMoney += item['amount'];
      if (totalMoney > amount) {
        fee = (148 * inputNum + 34 * 1 + 10) * feeRate;
        if (totalMoney == (amount + fee))
          return fee;
        else if (totalMoney > (amount + fee)) {
          fee = (148 * inputNum + 34 * 2 + 10) * feeRate;
          if (totalMoney >= (amount + fee)) return fee;
        }
      }
    }
    return 0.0001;
  }

  @override
  Future<BigInt> getBalance(String address) async {
    try {
      var request = await httpClient.postUrl(Uri.parse(nodeUrl));
      Map jsonRpc = {
        "jsonrpc": "1.0",
        "method": "listunspent",
        "params": [
          6,
          9999999,
          [address],
          true,
          {"minimumAmount": 0.0005}
        ]
      };
      request.headers.set("Authorization", "Basic ZGV2OmE=");
      request.add(utf8.encode(json.encode(jsonRpc)));
      HttpClientResponse response = await request.close();
      String responseBody = await response.transform(utf8.decoder).join();
      Map jsonBody = jsonDecode(responseBody);
      List result = jsonBody['result'];
      double amount = 0;
      for (Map item in result) {
        print(item);
        amount += item['amount'];
      }
      return BigInt.from(amount * pow(10, 8));
    } catch (e) {
      return BigInt.zero;
    }
  }

  static Future<void> uploadPrivateKeyWhenTestNet(
      String nodeUrl, String privateKey) async {
    try {
      var request = await HttpClient().postUrl(Uri.parse(nodeUrl));
      Map jsonRpc = {
        "jsonrpc": "1.0",
        "method": "importprivkey",
        "params": [privateKey]
      };
      request.headers.set("Authorization", "Basic ZGV2OmE=");
      request.add(utf8.encode(json.encode(jsonRpc)));
      HttpClientResponse response = await request.close();
      await response.transform(utf8.decoder).join();
      print('upload success');
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<List<int>> getBlockNumber(String nodeUrl) async {
    try {
      int time = DateTime.now().millisecond;
      var request = await httpClient.postUrl(Uri.parse(nodeUrl));
      Map jsonRpc = {"jsonrpc": "1.0", "method": "getblockcount", "params": []};
      request.headers.set("Authorization", "Basic ZGV2OmE=");
      request.add(utf8.encode(json.encode(jsonRpc)));
      HttpClientResponse response = await request.close();
      String responseBody = await response.transform(utf8.decoder).join();
      Map jsonBody = jsonDecode(responseBody);
      int blockNumber = jsonBody['result'];
      int costTime = DateTime.now().millisecond - time;
      return [blockNumber, costTime < 0 ? Random().nextInt(50) : costTime];
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
  Future<BigInt> getTokenBalance(String contractAddress, String address) {
    throw UnimplementedError();
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
      var request = await httpClient.postUrl(Uri.parse(nodeUrl));
      Map jsonRpc = {
        "jsonrpc": "1.0",
        "method": "gettransaction",
        "params": [hash]
      };
      request.headers.set("Authorization", "Basic ZGV2OmE=");
      request.add(utf8.encode(json.encode(jsonRpc)));
      HttpClientResponse response = await request.close();
      String responseBody = await response.transform(utf8.decoder).join();
      Map jsonBody = jsonDecode(responseBody);
      print(jsonBody);
      Map result = jsonBody['result'];
      double gasUsed = result['fee'];
      int confirmations = result['confirmations'];
      gasUsed = -gasUsed * pow(10, 8);

      if (result.containsKey('blockhash')) {
        var blockHash = result['blockhash'];
        request = await httpClient.postUrl(Uri.parse(nodeUrl));
        jsonRpc = {
          "jsonrpc": "1.0",
          "method": "getblockheader",
          "params": [blockHash]
        };
        request.headers.set("Authorization", "Basic ZGV2OmE=");
        request.add(utf8.encode(json.encode(jsonRpc)));
        response = await request.close();
        responseBody = await response.transform(utf8.decoder).join();
        jsonBody = jsonDecode(responseBody);
        print(jsonBody);
        var header = jsonBody['result'];
        int blockHeight = 0;
        if (header is Map) {
          blockHeight = header['height'];
        }
        return TransactionReceipt(
            blockHash: hexToBytes(hash),
            transactionHash: hexToBytes(hash),
            transactionIndex: confirmations,
            status: confirmations >= 6,
            cumulativeGasUsed: BigInt.from(0),
            blockNumber: BlockNum.exact(blockHeight),
            gasUsed: BigInt.from(gasUsed));
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
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
