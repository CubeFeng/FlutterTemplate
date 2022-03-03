import 'dart:math';
import 'dart:typed_data';

import 'package:bs58check/bs58check.dart';
import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_wallet_chain/trx/protos/gen/Tron.pbenum.dart';
import 'package:protobuf/protobuf.dart';
import 'package:web3dart/crypto.dart' as web3dart_crypto;

import 'protos/gen/Tron.pb.dart';
import 'protos/gen/balance_contract.pb.dart';
import 'protos/gen/google/protobuf/any.pb.dart';
import 'protos/gen/smart_contract.pb.dart';

class Ttransaction {
  Uint8List tx;

  Ttransaction(this.tx);
}

class TronTransaction {
  static Future<String> signTronTransaction(
      String privateKeyHex, Ttransaction transaction) async {
    Transaction tra = Transaction.fromBuffer(transaction.tx);
    Digest txid = sha256.convert(tra.rawData.writeToBuffer());

    web3dart_crypto.MsgSignature ms = web3dart_crypto.sign(
        Uint8List.fromList(txid.bytes),
        web3dart_crypto.hexToBytes(privateKeyHex));

    String r = fixHexLength(ms.r.toRadixString(16));
    String s = fixHexLength(ms.s.toRadixString(16));
    String v = fixHexLength((ms.v - 27).toRadixString(16), length: 2);
    String signature = r + s + v;

    tra.signature.add(web3dart_crypto.hexToBytes(signature));
    Uint8List signedTx = tra.writeToBuffer();
    return web3dart_crypto.bytesToHex(signedTx);
  }

  static String fixHexLength(String hex, {int length = 64}) {
    if (length <= hex.length) {
      return hex.substring(0, length);
    } else {
      return ('0' * (length - hex.length)) + hex;
    }
  }

  static BigInt numPow2BigInt(num value, decimals) {
    String bigValue = (value.toDouble() * pow(10, decimals)).toString();
    // print(bigValue);
    BigInt bigIntValue =
        BigInt.parse(bigValue.substring(0, bigValue.indexOf('.')));
    // print(bigIntValue);
    return bigIntValue;
  }

  static Future<Ttransaction> createTrc20Transaction(
      String from,
      String to,
      num value,
      String refBlockHash,
      String refBlockNum,
      int feeLimit,
      String contractAddress,
      int decimals) async {
    TriggerSmartContract tsc = TriggerSmartContract.create();
    tsc.ownerAddress = _decode58Check(from)!;
    tsc.contractAddress = _decode58Check(contractAddress)!;

    String operationHex = 'a9059cbb000000000000000000000000' +
        web3dart_crypto.bytesToHex(_decode58Check(to)!.toList()).substring(2);
    String valueHex = numPow2BigInt(value, decimals).toRadixString(16);

    String tokenHex = fixHexLength(valueHex);
    String dataHex = operationHex + tokenHex;
    // print('dataHex: ' + dataHex);
    tsc.data = web3dart_crypto.hexToBytes(dataHex);

    Transaction tx = _createTronTransaction(
        tsc,
        Transaction_Contract_ContractType.TriggerSmartContract,
        refBlockHash,
        refBlockNum,
        feeLimit);
    return Ttransaction(tx.writeToBuffer());
    // }
  }

  static Future<Ttransaction> createTrxTransaction(
      String from,
      String to,
      num value,
      String refBlockHash,
      String refBlockNum,
      int feeLimit,
      int decimals) async {
    // if (WalletProxy.tronType.keys.contains(type)) {
    //   CoinInfo coinInfo = WalletProxy.tronType[type];
    TransferContract tfc = TransferContract.create();
    tfc.ownerAddress = _decode58Check(from)!;
    tfc.toAddress = _decode58Check(to)!;
    tfc.amount = Int64(numPow2BigInt(value, decimals).toInt());

    Transaction tx = _createTronTransaction(
        tfc,
        Transaction_Contract_ContractType.TransferContract,
        refBlockHash,
        refBlockNum,
        feeLimit);
    return Ttransaction(tx.writeToBuffer());
    // }
  }

  static Uint8List? _decode58Check(String input) {
    Uint8List address = base58.decode(input);
    // print(address.length);
    if (address.length == 25) {
      // print(bytesToHex(address.sublist(0, 21)));
      return address.sublist(0, 21);
    }
    return null;
  }

  static Transaction _createTronTransaction(
      GeneratedMessage tfc,
      Transaction_Contract_ContractType ct,
      String refBlockHash,
      String refBlockNum,
      int feeLimit) {
    Transaction tx = Transaction.create();

    Transaction_Contract txc = Transaction_Contract.create();

    Any any = Any.pack(tfc);
    txc.parameter = any;
    txc.type = ct;
    Transaction_raw tr = tx.ensureRawData();
    tr.contract.add(txc);
    tr.timestamp = Int64(DateTime.now().millisecondsSinceEpoch);
    tr.expiration = tr.timestamp + 10 * 60 * 60 * 1000;
    print('timestamp: ' + tr.timestamp.toString());
    print('expiration: ' + tr.expiration.toString());

    // tr.timestamp = Int64(1612177284210);
    // tr.expiration = Int64(1612213284210);

    tx.rawData.refBlockHash =
        web3dart_crypto.hexToBytes(refBlockHash.substring(16, 32));
    tx.rawData.refBlockBytes =
        web3dart_crypto.hexToBytes(refBlockHash.substring(12, 16));
    tx.rawData.refBlockNum = Int64.parseInt(refBlockNum);
    tx.rawData.feeLimit = Int64(feeLimit);

    // print(web3dart_crypto.bytesToHex(tx.rawData.refBlockHash));
    // print(web3dart_crypto.bytesToHex(tx.rawData.refBlockBytes));

    return tx;
  }
}
