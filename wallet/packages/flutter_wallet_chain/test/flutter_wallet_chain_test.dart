import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wallet_chain/api/generate_api_keystore.dart';
import 'package:flutter_wallet_chain/api/generate_service.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/btc/bitcoin_flutter.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_chain/trx/tronWallet.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;

int currentTimeMillis() {
  return DateTime.now().millisecondsSinceEpoch;
}

var time;

void printCost() {
  print('>>>>>耗时:${currentTimeMillis() - time} ms');
  time = currentTimeMillis();
}

void main() {

  test('Sol测试', () async {
    String mnemonic =
        'chimney refuse inspire language subway horror middle tube property knife garage exclude';
    String privateKey = 'sD5DJAFyRqLyan7NWinn82fevx5GvNq6SAuVF3UNAomv75j89naVp72Mmw3jibAEs8hDEtgKmfjwyd3RUPCvhQF';
    String address = 'BGoeW8MGQuip64uJW5Rz9sYXrKzeB4RbYTGFXck1VNsM';

    QiCoinKeypair qiCoinKeypair = await qiGenerateKeypairWithMnemonic(coinType:QiCoinType.SOL, mnemonic: mnemonic);
    print(qiCoinKeypair.privateKey);
    print(qiCoinKeypair.address);
    print(qiCoinKeypair.publicKey);


    QiCoinKeypair qiCoinKeypair2 = await qiGenerateKeypairWithPrivateKey(QiCoinType.SOL, qiCoinKeypair.privateKey);
    print(qiCoinKeypair2.address);
  });
  test('TRX测试', () async {

    String pk = 'c7027f3c53efbeaefc8f2f102c0e12bdc45ab769866d41366f53b49ccac47c12';

    QiCoinKeypair qiCoinKeypair = await qiGenerateKeypairWithPrivateKey(QiCoinType.TRX, pk);
    print(qiCoinKeypair.privateKey);
    print(qiCoinKeypair.address);

    if(true){
      return;
    }
    String mnemonic =
        'chimney refuse inspire language subway horror middle tube property knife garage exclude';
    var seed2 = bip39.mnemonicToSeed(mnemonic);
    var hdWallet = new HDWallet.fromSeed(seed2, network: bitcoin);
    hdWallet = hdWallet.derivePath("m/44'/195'/0'/0/0");

    print(hdWallet.address);
    // => 12eUJoaWBENQ3tNZE52ZQaHqr3v4tTX4os
    print(hdWallet.pubKey);
    // => 0360729fb3c4733e43bf91e5208b0d240f8d8de239cff3f2ebd616b94faa0007f4
    print(hdWallet.privKey);
    // => 01304181d699cd89db7de6337d597adf5f78dc1f0784c400e41a3bd829a5a226
    print(hdWallet.wif);
    // => KwG2BU1ERd3ndbFUrdpR7ymLZbsd7xZpPKxsgJzUf76A4q9CkBpY
    String address = TronWallet.getAddress(hdWallet.privKey!);
    print(address);

    print('-----------------');
    var wallet = BtcWallet.fromWIF(hdWallet.wif!, bitcoin);
    print(wallet.address);
    // => 19AAjaTUbRjQCMuVczepkoPswiZRhjtg31
    print(wallet.pubKey);
    // => 03aea0dfd576151cb399347aa6732f8fdf027b9ea3ea2e65fb754803f776e0a509
    print(wallet.privKey);
    // => 3095cb26affefcaaa835ff968d60437c7c764da40cdd1a1b497406c7902a8ac9
    print(wallet.wif);
    // => Kxr9tQED9H44gCmp6HAdmemAzU3n84H3dGkuWTKvE23JgHMW8gct

    final alice = ECPair.fromWIF(
        'L1uyy5qTuGrVXrmrsvHWHgVzW9kKdrp27wBC7Vs6nZDTF2BRUVwy');
    final txb = new TransactionBuilder();
    txb.setVersion(1);
    txb.addInput(
        '61d520ccb74288c96bc1a2b20ea1c0d5a704776dd0164a396efec3ea7040349d',
        0);
    txb.addOutput('1cMh228HTCiwS8ZsaakH8A8wze1JR5ZsP', 12000);
    txb.sign(vin: 0, keyPair: alice);
    expect(txb.build().toHex(),
        '01000000019d344070eac3fe6e394a16d06d7704a7d5c0a10eb2a2c16bc98842b7cc20d561000000006b48304502210088828c0bdfcdca68d8ae0caeb6ec62cd3fd5f9b2191848edae33feb533df35d302202e0beadd35e17e7f83a733f5277028a9b453d525553e3f5d2d7a7aa8010a81d60121029f50f51d63b345039a290c94bffd3180c99ed659ff6ea6b1242bca47eb93b59fffffffff01e02e0000000000001976a91406afd46bcdfd22ef94ac122aa11f241244a37ecc88ac00000000');

  });


  test('BTC测试', () async {
    String mnemonic =
        'chimney refuse inspire language subway horror middle tube property knife garage exclude';
    var seed2 = bip39.mnemonicToSeed(mnemonic);
    var hdWallet = new HDWallet.fromSeed(seed2, network: bitcoin);
    hdWallet = hdWallet.derivePath("m/44'/0'/0'/0/0");

    print(hdWallet.address);
    // => 12eUJoaWBENQ3tNZE52ZQaHqr3v4tTX4os
    print(hdWallet.pubKey);
    // => 0360729fb3c4733e43bf91e5208b0d240f8d8de239cff3f2ebd616b94faa0007f4
    print(hdWallet.privKey);
    // => 01304181d699cd89db7de6337d597adf5f78dc1f0784c400e41a3bd829a5a226
    print(hdWallet.wif);
    // => KwG2BU1ERd3ndbFUrdpR7ymLZbsd7xZpPKxsgJzUf76A4q9CkBpY

    print('-----------------');
    var wallet = BtcWallet.fromWIF(hdWallet.wif!, bitcoin);
    print(wallet.address);
    // => 19AAjaTUbRjQCMuVczepkoPswiZRhjtg31
    print(wallet.pubKey);
    // => 03aea0dfd576151cb399347aa6732f8fdf027b9ea3ea2e65fb754803f776e0a509
    print(wallet.privKey);
    // => 3095cb26affefcaaa835ff968d60437c7c764da40cdd1a1b497406c7902a8ac9
    print(wallet.wif);
    // => Kxr9tQED9H44gCmp6HAdmemAzU3n84H3dGkuWTKvE23JgHMW8gct

    final alice = ECPair.fromWIF(
        'L1uyy5qTuGrVXrmrsvHWHgVzW9kKdrp27wBC7Vs6nZDTF2BRUVwy');
    final txb = new TransactionBuilder();
    txb.setVersion(1);
    txb.addInput(
        '61d520ccb74288c96bc1a2b20ea1c0d5a704776dd0164a396efec3ea7040349d',
        0);
    txb.addOutput('1cMh228HTCiwS8ZsaakH8A8wze1JR5ZsP', 12000);
    txb.sign(vin: 0, keyPair: alice);
    expect(txb.build().toHex(),
        '01000000019d344070eac3fe6e394a16d06d7704a7d5c0a10eb2a2c16bc98842b7cc20d561000000006b48304502210088828c0bdfcdca68d8ae0caeb6ec62cd3fd5f9b2191848edae33feb533df35d302202e0beadd35e17e7f83a733f5277028a9b453d525553e3f5d2d7a7aa8010a81d60121029f50f51d63b345039a290c94bffd3180c99ed659ff6ea6b1242bca47eb93b59fffffffff01e02e0000000000001976a91406afd46bcdfd22ef94ac122aa11f241244a37ecc88ac00000000');

  });

  test('AITD测试', () async {
    QiRpcService.setChainNet(QiChainNet.TEST_NET);
    //QiRpcService.setChainCoin(QiCoinType.AITD);

    if (false) {
      //测试swap签名
      final result = await QiRpcService().signTypeMessage(
          '0x323874936ddfc02f684cb5b1154cb92e4a1eec4f32a52e84551a9b7bb4b8ee24',
          privateKey:
              '0302452f66900e361bf5661da672d3bcb456865b0701efffbd616c25f0030a92');
      print(
          '对比结果：0x4a1df59cf3fa39243c5f1ef313646d157983f5a3f6e8ac907e89e80b67b31c3e4c284c7ab5df9da4368ac556a047bc5aec6b9e375e5f688e3b8f495eae70a7f01b');
      print(result);
      return;
    }

    if (true) {
      //通过keystore生成钱包
      final keypair = await qiGenerateWalletWithKeystore(
          password: 'Asd123',
          keystore:
              '{"crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"f6300e03de9e53e7ec1014f81b35f83d"},"ciphertext":"60820590056c1841e4a44c8f47ff008524702479c2101ff1cb9c3b4a02b5209e98","kdf":"scrypt","kdfparams":{"dklen":32,"n":4096,"r":8,"p":6,"salt":"ed7f11f2e20a2469537de58df5b89ea311e220e8ee6aaac937221debf6707662"},"mac":"59d2878ac4c3d9d02cac480aedbbed82f11b89a613b26e25227896f3be40c7e8"},"id":"422e1ce7-88ac-4a0e-8bf2-2d421df358d1","version":3}');
      print('生成私钥:${keypair.privateKey}');
      print('生成地址:${keypair.address}');

      print('Dart的Random.secure()与Android的SecureRandom不同，无法生成一致');
      var keystore = qiGenerateKeystore(
          password: 'Asd12345', privateKey: keypair.privateKey);
      print('生成keystore:$keystore');
      keystore = qiGenerateKeystore(
          password: 'Asd12345', privateKey: keypair.privateKey);
      print('生成keystore:$keystore');
      return;
    }

    if (true) {
      ///获取代币余额
      final amountARC20 = await QiRpcService().getTokenBalance(
          '0x4b6b9f3695205c8468ddf9ab4025ec2a09bdff1a',
          '0x3e358c63286b8506e12015711e8dd66c546e2dbe');
      print(amountARC20);
      final amountABTC = await QiRpcService().getTokenBalance(
          '0x4c32b8f1cb4310bf5f3b82a8f41d194a6fe98c69',
          '0x3e358c63286b8506e12015711e8dd66c546e2dbe');
      print(amountABTC);
      return;
    }

    if (true) {
      ///手续费模块
      final rpcConfig = QiRpcService().currentRpc;
      print('chainName：${rpcConfig.coinType}');
      print('chainId：${rpcConfig.chainId}');
      print('nodes：${rpcConfig.nodes}');

      final gasPrice = await QiRpcService().getGasPrice();
      print('gasPrice:');
      print(gasPrice);

      final gas = await QiRpcService().estimateGas(
        to: EthereumAddress.fromHex(
            '0x3e358c63286b8506e12015711e8dd66c546e2dbe'),
      );

      print('普通转账gasLimit:');
      print(gas);

      final function = ContractFunction('safeTransferFrom', [
        FunctionParameter('_from', AddressType()),
        FunctionParameter('_to', AddressType()),
        FunctionParameter('_tokenId', UintType())
      ]);
      final params = [
        EthereumAddress.fromHex('0x3e358c63286b8506e12015711e8dd66c546e2dbe'),
        EthereumAddress.fromHex('0xfaaed14621507209c15d20f0420a6ba95312c605'),
        BigInt.from(36)
      ];
      final data = function.encodeCall(params);
      final gasContract = await QiRpcService().estimateGas(
        to: EthereumAddress.fromHex(
            '0xdad1025d2cae2d3559b1abbce1f77401adefbb8c'),
        data: data,
      );
      print('合约gasLimit:');
      print(gasContract);
      return;
    }
    time = currentTimeMillis();
    //生成钱包信息
    var randomMnemonic = qiGenerateMnemonic();
    randomMnemonic =
        'chimney refuse inspire language subway horror middle tube property knife garage exclude';
    final qiCoinKeypair = await qiGenerateKeypairWithMnemonic(
        coinType: QiCoinType.ETH, mnemonic: randomMnemonic);
    print('生成助记词:$randomMnemonic');
    print('生成私钥:${qiCoinKeypair.privateKey}');
    print('生成地址:${qiCoinKeypair.address}');
    printCost();

    //验证助记词合法性
    final isValid = qiValidateMnemonic(randomMnemonic);
    print('助记词是否有效：$isValid');

    final rpcConfig = QiRpcService().currentRpc;
    print('chainName：${rpcConfig.coinType}');
    print('chainId：${rpcConfig.chainId}');
    print('nodes：${rpcConfig.nodes}');

    final amount = await QiRpcService().getBalance(qiCoinKeypair.address);
    print('获取余额：$amount');
    printCost();

    final result = await QiRpcService().sendTransaction(
        Transaction(
            to: EthereumAddress.fromHex(
                '0xfaaed14621507209c15d20f0420a6ba95312c605'),
            gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
            maxGas: 21000,
            value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1)),
        privateKey: qiCoinKeypair.privateKey);
    print('https://eth-explorer-pre.aitd.io/tx/$result');
    printCost();

    //切换主网、测试网，
    QiRpcService().switchChainNet(QiChainNet.TEST_NET);
    //切换链，
   // QiRpcService().switchChain(QiCoinType.ETH);
  });
}
