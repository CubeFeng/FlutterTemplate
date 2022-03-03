import 'dart:typed_data';

import 'package:bs58check/bs58check.dart';
import 'package:crypto/crypto.dart';
import 'package:web3dart/crypto.dart' as web3dart_crypto;

import '../trx/tronTransactioin.dart';

class TronWallet {
  String get coinType => "TRX";

  static int get decimals => 6;

  static int get gasLimit => 10000000;

  static String getAddress(String pk){
    Uint8List pubKey =
        web3dart_crypto.privateKeyBytesToPublic(web3dart_crypto.hexToBytes(pk));
    String pubKeyKeccak256 =
        web3dart_crypto.bytesToHex(web3dart_crypto.keccak256(pubKey));
    String addressHex = '41' + pubKeyKeccak256.substring(24);
    Uint8List addressBin = web3dart_crypto.hexToBytes(addressHex);
    String hash1 = sha256.convert(sha256.convert(addressBin).bytes).toString();
    String checksum = hash1.substring(0, 8);
    checksum = addressHex + checksum;
    return base58.encode(web3dart_crypto.hexToBytes(checksum));
  }

  static Future<String> transactionMain(String pk, String fromAddress,
      String toAddress, num amount, num gasPrice, Map otherPrams) async {
    String refBlockHash = otherPrams["rbh"];
    String refBlockNum = otherPrams["rbn"];
    var createTrxTransaction = await TronTransaction.createTrxTransaction(
        fromAddress,
        toAddress,
        amount,
        refBlockHash,
        refBlockNum,
        gasLimit,
        decimals);
    String mSign =
        await TronTransaction.signTronTransaction(pk, createTrxTransaction);
    return mSign;
  }

  static Future<String> transactionToken(
      String pk,
      String fromAddress,
      String toAddress,
      num amount,
      num gasPrice,
      String contractAddress,
      int decimalForToken,
      Map otherPrams) async {
    String refBlockHash = otherPrams["rbh"];
    String refBlockNum = otherPrams["rbn"];
    //int dec = decimalForToken;//otherPrams["decimals"];//token的精度不能采用主链，所以由归集方传入
    var createTrxTransaction = await TronTransaction.createTrc20Transaction(
        fromAddress,
        toAddress,
        amount,
        refBlockHash,
        refBlockNum,
        gasLimit,
        contractAddress,
        decimalForToken);
    String mSign =
        await TronTransaction.signTronTransaction(pk, createTrxTransaction);
    return mSign;
  }
}
