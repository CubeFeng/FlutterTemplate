import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_wallet_chain/btc/bitcoin_flutter_base.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';

import '../generate_api.dart';
import '../generate_service.dart';

class GenerateBtc extends IGenerateService {
  @override
  Future<QiCoinKeypair> qiGenerateKeypair(QiCoinType coinType, String mnemonic) async{
    final keypair = QiCoinKeypair();
    String path =
        "m/44'/${coinType.coinCode()}'/0'/0/${coinType.addressIndex()}";
    final seed = bip39.mnemonicToSeed(mnemonic);

    var hdWallet = new HDWallet.fromSeed(seed, network: getNet(coinType));
    hdWallet = hdWallet.derivePath(path);
    keypair.privateKey = hdWallet.wif;
    keypair.publicKey = hdWallet.pubKey;
    keypair.address = hdWallet.address;
    return keypair;
  }

  @override
  bool qiValidatePrivateKey(QiCoinType coinType, String privateKey) {
    return true;
  }

  @override
  Future<QiCoinKeypair> qiGenerateKeypairWithPrivateKey(
      QiCoinType coinType, String privateKey) async {
    final keypair = QiCoinKeypair();
    keypair.privateKey = privateKey;
    var wallet = BtcWallet.fromWIF(privateKey, getNet(coinType));
    keypair.publicKey = wallet.pubKey;
    keypair.address = wallet.address;
    return keypair;
  }
}
