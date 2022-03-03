// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_base_kit/net/http/http.dart';
import 'package:flutter_base_kit/widgets/toast.dart';
import 'package:flutter_wallet/apis/api_urls.dart';
import 'package:flutter_wallet/models/wallet_importtype_model.dart';
import 'package:flutter_wallet/modules/property/controllers/property_controller.dart';
import 'package:flutter_wallet/modules/settings/node/controller/node_controller.dart';
import 'package:flutter_wallet/modules/wallet/manager/controllers/wallet_manage_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/http_service.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:get/get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/utils/app_utils.dart';

Iterable<QiCoinType>? selectNet;
String? cachePassword;

///
class WalletCreateController extends GetxController {
  WalletImportType importType =
      getImpType(Get.parameters['importType'] ?? "menmonic");

  WalletCreateType createType =
      getCreateType(Get.parameters['createType'] ?? "singleImport");

  final String inputTextEncrypt = Get.parameters['inputText'] ?? "";
  final String fixMode = Get.parameters['fixMode'] ?? "";
  late String inputText;
  final chainName =
      Get.parameters['chainName'] ?? QiRpcService().coinType.chainName();
  final keystorePassword = Get.parameters['password'];

  late String textTitle = "";
  final subTitle = "".obs;

  ///
  final Map<QiCoinType, QiCoinKeypair> keypairMaps = {};

  final List<WalletItemModel> itemList = [];

  int successCount = 0;

  ///
  bool complete = false;

  @override
  void onInit() {
    super.onInit();
    if (inputTextEncrypt.isNotEmpty) {
      inputText = encrypt(inputTextEncrypt, cachePassword!);
    }

    switch (createType) {
      case WalletCreateType.netExtend:
        textTitle = I18nKeys.createHdIdentityWallet;
        subTitle.value = I18nKeys.creating;
        for (var element in selectNet!) {
          itemList.add(WalletItemModel(element.chainName(),
              "property/icon_coin_${element.chainName().toLowerCase()}", "0"));
        }
        break;
      case WalletCreateType.hdCreate:
        textTitle = I18nKeys.createHdIdentityWallet;
        subTitle.value = I18nKeys.creating;
        for (var coinType in QiRpcService().supportCoins) {
          itemList.add(WalletItemModel(coinType.chainName(),
              "property/icon_coin_${coinType.chainName().toLowerCase()}", "0"));
        }
        break;
      case WalletCreateType.hdImport:
        textTitle = I18nKeys.importHdIdentityWallet;
        subTitle.value = I18nKeys.importing;
        for (var coinType in QiRpcService().supportCoins) {
          itemList.add(WalletItemModel(coinType.chainName(),
              "property/icon_coin_${coinType.chainName().toLowerCase()}", "0"));
        }
        break;
      case WalletCreateType.singleCreate:
        textTitle = I18nKeys.createSignleWallet;
        subTitle.value = I18nKeys.creating;
        itemList.add(WalletItemModel(
            chainName, "property/icon_coin_${chainName.toLowerCase()}", "0"));
        break;
      case WalletCreateType.singleImport:
        textTitle = I18nRawKeys.importWallet.trPlaceholder([chainName]);
        subTitle.value = I18nKeys.creating;
        itemList.add(WalletItemModel(
            chainName, "property/icon_coin_${chainName.toLowerCase()}", "0"));
        break;
    }

    buildCreatWallet();
  }

  Future<void> buildCreatWallet() async {
    print("buildCreatWallet $createType");
    switch (createType) {
      case WalletCreateType.netExtend:
        {
          String? walletId = Get.parameters['walletId'];
          Wallet? wallet =
              await DBService.service.walletDao.findById(int.parse(walletId!));
          for (var element in selectNet!) {
            final qiCoinKeypair = await qiGenerateKeypairWithMnemonic(
                coinType: element,
                mnemonic: decrypt(wallet!.mnemonic!, cachePassword!));
            _creatAndSaveCoin(int.parse(walletId), element, qiCoinKeypair);
          }
        }
        break;
      case WalletCreateType.hdCreate:
      case WalletCreateType.hdImport:
        {
          _creatHDWallet();
        }
        break;
      case WalletCreateType.singleCreate:
        {
          final qiCoinKeypair = await qiGenerateKeypairWithMnemonic(
              coinType: QiCoinCode44.parse(chainName),
              mnemonic: inputTextEncrypt);
          var wallet = Wallet(
              walletType: WalletType.SINGLE_CHAIN,
              mnemonic: inputText,
              walletSource: WalletSource.CREATE);
          wallet.preHandle();
          final walletId = await DBService.to.walletDao.saveAndReturnId(wallet);

          _creatAndSaveCoin(
              walletId, QiCoinCode44.parse(chainName), qiCoinKeypair);
        }
        break;
      case WalletCreateType.singleImport:
        {
          _singleImportWallet();
        }
        break;
    }
  }

  static String encrypt(String content, String password) {
    return EncryptUtils.aesEncrypt(
      content,
      EncryptUtils.encryptMD5(password),
    );
  }

  static String decrypt(String content, String password) {
    return EncryptUtils.aesDecrypt(
      content,
      EncryptUtils.encryptMD5(password),
    );
  }

  ///创建HD钱包
  Future<void> _creatHDWallet() async {
    var wallet = Wallet(
        mnemonic: inputText,
        walletType: WalletType.HD,
        walletSource: WalletSource.CREATE);
    wallet.preHandle();

    ///查询wallet数据库
    final walletList =
        await DBService.to.walletDao.findAllByMnemonic(inputText);
    int walletId;
    if (walletList.isNotEmpty) {
      Toast.showError(I18nKeys.mnemonicAlreadyExists);
      walletId = walletList[0].id!;
    } else {
      walletId = await DBService.to.walletDao.saveAndReturnId(wallet);
    }

    ///查询支持的coin 列表
    for (var coinType in QiRpcService().supportCoins) {
      ///助记词创建钱包
      final qiCoinKeypair = await qiGenerateKeypairWithMnemonic(
          coinType: coinType, mnemonic: inputTextEncrypt);
      _creatAndSaveCoin(walletId, coinType, qiCoinKeypair,
          changeCurrentCoin: coinType == QiRpcService().coinType);
    }
  }

  ///导入钱包
  void _singleImportWallet() async {
    if (importType == WalletImportType.menmonic) {
      final qiCoinKeypair = await qiGenerateKeypairWithMnemonic(
          coinType: QiCoinCode44.parse(chainName),
          mnemonic: fixMode == 'fixMode' ? inputText : inputTextEncrypt);
      var wallet = Wallet(
          walletType: WalletType.SINGLE_CHAIN,
          mnemonic: inputText,
          walletSource: WalletSource.IMPORT);
      wallet.preHandle();
      final walletId = await DBService.to.walletDao.saveAndReturnId(wallet);

      _creatAndSaveCoin(walletId, QiCoinCode44.parse(chainName), qiCoinKeypair);
    } else if (importType == WalletImportType.privatyKey) {
      final qiCoinKeypair = await qiGenerateKeypairWithPrivateKey(
          QiCoinCode44.parse(chainName), inputTextEncrypt);
      var wallet = Wallet(
          walletType: WalletType.SINGLE_CHAIN,
          walletSource: WalletSource.IMPORT);
      wallet.preHandle();
      final walletId = await DBService.to.walletDao.saveAndReturnId(wallet);

      _creatAndSaveCoin(walletId, QiCoinCode44.parse(chainName), qiCoinKeypair);
    } else if (importType == WalletImportType.keyStore) {
      if (keystorePassword == null) {
        Toast.showError("keystore ${I18nKeys.filePasswordCannotBeEmpty}");
      }

      try {
        final qiCoinKeypair = await qiGenerateWalletWithKeystore(
            password: keystorePassword ?? "", keystore: inputTextEncrypt);

        print(
            "keystore 创建 私钥：${qiCoinKeypair.privateKey} 地址：${qiCoinKeypair.address}");
        var wallet = Wallet(
            walletType: WalletType.SINGLE_CHAIN,
            walletSource: WalletSource.IMPORT);
        wallet.preHandle();
        final walletId = await DBService.to.walletDao.saveAndReturnId(wallet);

        _creatAndSaveCoin(
            walletId, QiCoinCode44.parse(chainName), qiCoinKeypair);
      } catch (_) {
        ///keystore错误
        _updateItemList(chainName, "2");
      }
    }
  }

  /// 保存coin
  void _creatAndSaveCoin(
      int walletId, QiCoinType coinType, QiCoinKeypair qiCoinKeypair,
      {changeCurrentCoin = true}) async {
    final coin = Coin(
      walletId: walletId,
      coinType: coinType.chainName(),
      coinName: coinType.fullName(),
      coinDecimals: coinType.coinDecimal(),
      coinUnit: coinType.coinUnit(),
      privateKey: encrypt(qiCoinKeypair.privateKey, cachePassword!),
      publicKey: qiCoinKeypair.publicKey,
      coinAddress: qiCoinKeypair.address,
    );
    coin.preHandle();

    ///查询本地是否已经存在该地址
    final dbCoin = await DBService.to.coinDao
        .findAllByCoinAddress(coinType.coinUnit(), qiCoinKeypair.address);

    if (dbCoin.isNotEmpty) {
      Toast.showError(I18nKeys.addressAlreadyExists);

      ///db存在
      _updateItemList(coinType.chainName(), "2");
    } else {
      ///db不存在 保存coin
      coin.id = await DBService.to.coinDao.saveAndReturnId(coin);
      if (changeCurrentCoin) {
        DBService.to.dbChanged.value += 1;
        Get.find<PropertyController>().onAddressSelect(coin);
      }

      /// 更新itemlist
      _updateItemList(coinType.chainName(), "1");

      ResponseModel<String> resposne = await HttpService.service.http
          .post<String>(ApiUrls.submitAddress, data: {
        "address": coin.coinAddress,
        "channel": (createType == WalletCreateType.hdCreate ||
                createType == WalletCreateType.singleCreate)
            ? 1
            : 0,
        "coin": coin.coinUnit
      });
      if (coinType == QiCoinType.BTC && isTestNet()) {
        //BTC测试网需要把私钥上传到节点，存储节点数据
        QiBtcRpcService.uploadPrivateKeyWhenTestNet(
            NodeController.getNode(coinType), qiCoinKeypair.privateKey);
      }
      print(resposne.data);
    }
  }

  /// 更新itemlist  status 1成功 2失败 0正在进行中
  void _updateItemList(String chainName, String status) {
    if (status == "1") {
      successCount++;
      DBService.to.dbChanged.value += 1;
    }

    int completeCount = 0;
    for (WalletItemModel model in itemList) {
      if (model.title == chainName) {
        model.status = status;
      }

      if (model.status != "0") {
        completeCount++;
      }
    }

    if (completeCount == itemList.length) {
      complete = true;

      if (successCount == itemList.length) {
        subTitle.value = (createType == WalletCreateType.singleImport ||
                createType == WalletCreateType.hdImport)
            ? I18nKeys.importSucceeded
            : I18nKeys.createdSuccessfully;
      } else if (successCount == 0) {
        subTitle.value = (createType == WalletCreateType.singleImport ||
                createType == WalletCreateType.hdImport)
            ? I18nKeys.importFailed
            : I18nKeys.creationFailed;
      } else {
        subTitle.value = (createType == WalletCreateType.singleImport ||
                createType == WalletCreateType.hdImport)
            ? I18nKeys.importComplete
            : I18nKeys.creationComplete;
      }
    } else {
      subTitle.value = (createType == WalletCreateType.singleImport ||
              createType == WalletCreateType.hdImport)
          ? I18nKeys.importing
          : I18nKeys.creating;
    }

    update();
  }

  void doneAction() {
    AppUtils.hideKeyboard();

    if (true ||
        createType == WalletCreateType.hdCreate ||
        createType == WalletCreateType.singleCreate ||
        successCount == itemList.length) {
      Get.find<WalletManageController>().reload();
      Get.until((route) => Get.currentRoute == Routes.WALLET_MANAGE);
    } else {
      Get.back();
    }
  }

  ///
  void verify() {
    //TODO:判断是否正确
    if (true) {
      Get.toNamed(Routes.WALLET_CREATE);
    }
  }
}
