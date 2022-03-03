import 'package:bip39/bip39.dart' as bip39;
import 'package:bs58check/bs58check.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:solana/solana.dart';

import '../generate_service.dart';

Future<String> addSolanaToken(
    String nodeUrl, String privateKey, String contractAddress) async {
  Ed25519HDKeyPair account = await Wallet.fromSeedWithHdPath(
      seed: bip39.mnemonicToSeed(contractAddress + privateKey),
      hdPath: "m/44'/501'/0'/0'");
  print(account.address);
  Ed25519HDKeyPair creator =
      await Wallet.fromPrivateKeyBytes(privateKey: base58.decode(privateKey));
  RpcClient rpcClient = RpcClient(nodeUrl);
  const space = TokenProgram.neededAccountSpace;
  final rent = await rpcClient.getMinimumBalanceForRentExemption(space);
  final message = TokenProgram.createAccount(
    address: account.address,
    owner: creator.address,
    mint: contractAddress,
    rent: rent,
    space: space,
  );
  final signature = await rpcClient.signAndSendTransaction(
    message,
    [creator, account],
  );
  print(signature);
  return account.address;
}

class GenerateSol extends IGenerateService {
  @override
  Future<QiCoinKeypair> qiGenerateKeypair(
      QiCoinType coinType, String mnemonic) async {
    final keypair = QiCoinKeypair();
    String path = "m/44'/${coinType.coinCode()}'/0'/0'";
    final seed = bip39.mnemonicToSeed(mnemonic);
    keypair.mnemonic = mnemonic;
    Ed25519HDKeyPair ed25519hdKeyPair =
        await Wallet.fromSeedWithHdPath(seed: seed, hdPath: path);
    var key = await ed25519hdKeyPair.extract();
    var pub = await ed25519hdKeyPair.extractPublicKey();
    keypair.privateKey = base58encode(key.bytes);
    keypair.publicKey = base58encode(pub.bytes);
    keypair.address = ed25519hdKeyPair.address;
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
    Ed25519HDKeyPair ed25519hdKeyPair =
        await Wallet.fromPrivateKeyBytes(privateKey: base58.decode(privateKey));
    keypair.address = ed25519hdKeyPair.address;
    return keypair;
  }

  static Future<SignedTx> sign(String from, String to, double amount,
      String privateKey, String blockHash,
      {contract}) async {
    Ed25519HDKeyPair ed25519hdKeyPair =
        await Wallet.fromPrivateKeyBytes(privateKey: base58.decode(privateKey));

    if (contract != null) {
      return await ed25519hdKeyPair.signMessage(
        message: TokenProgram.transfer(
          owner: ed25519hdKeyPair.address,
          source: from,
          destination: to,
          amount: amount.toInt(),
        ),
        recentBlockhash: blockHash,
      );
    }
    return await ed25519hdKeyPair.signMessage(
      message: SystemProgram.transfer(
        source: from,
        destination: to,
        lamports: amount.toInt(),
      ),
      recentBlockhash: blockHash,
    );
  }
}
