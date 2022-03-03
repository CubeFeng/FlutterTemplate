import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:web3dart/credentials.dart';
import 'package:bip39/bip39.dart' as bip39;
import '../generate_service.dart';

class GenerateEth extends IGenerateService {
  @override
  bool qiValidatePrivateKey(QiCoinType coinType, String privateKey) {
    try {
      EthPrivateKey.fromHex(privateKey);
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  Future<QiCoinKeypair> qiGenerateKeypair(QiCoinType coinType, String mnemonic) async{
    final keypair = QiCoinKeypair();
    String path =
        "m/44'/${coinType.coinCode()}'/0'/0/${coinType.addressIndex()}";
    final seed = bip39.mnemonicToSeedHex(mnemonic);
    keypair.mnemonic = mnemonic;
    final chain = Chain.seed(seed);
    final key = chain.forPath(path);
    keypair.privateKey = key.privateKeyHex();
    keypair.publicKey = key.publicKey().toString();
    keypair.address = EthPrivateKey.fromHex(keypair.privateKey).address.hex;
    return keypair;
  }

  @override
  Future<QiCoinKeypair> qiGenerateKeypairWithPrivateKey(
      QiCoinType coinType, String privateKey) async {
    final keypair = QiCoinKeypair();
    keypair.privateKey = privateKey;
    keypair.address = EthPrivateKey.fromHex(keypair.privateKey).address.hex;
    return keypair;
  }
}
