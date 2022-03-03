import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/apis/api_urls.dart';
import 'package:flutter_wallet/embed/embed_helper.dart';
import 'package:flutter_wallet/extensions/extension_key.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/models/version_info_model.dart';
import 'package:flutter_wallet/modules/wallet/create/controllers/wallet_create_controller.dart';
import 'package:flutter_wallet/services/app_service.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/http_service.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/services/security_service.dart';
import 'package:flutter_wallet/services/wallet_connect_service.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/api/generate_api.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:flutter_wallet_db/src/entity/entity.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

///
class HomeController extends GetxController with SingleGetTickerProviderMixin {
  static HomeController get to => Get.find();

  ///
  late final tabController = TabController(length: 3, vsync: this);

  final _tabIndex = 0.obs;

  int get tabIndex => _tabIndex.value;

  final bottomTabBarKey = GlobalKey();

  Size? get bottomTabBarSize => bottomTabBarKey.boxSize;

  late bool _needUpdateVersion = false;

  bool get needUpdateVersion => _needUpdateVersion;

  late VersionInfoModel _appInfoModel;

  VersionInfoModel get appInfoModel => _appInfoModel;

  @override
  void onInit() {
    super.onInit();
    tabController.addListener(() => _tabIndex.value = tabController.index);
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    //设置默认
    _appInfoModel = VersionInfoModel();
    _appInfoModel.versionNo = "2.0.2";
    _appInfoModel.downloadUrl = "https://coin-download.aitd.io";

    // 嵌入式启动时不检查更新
    if (!EmbedHelper.isEmbedLaunch && !kDebugMode) {
      checkUpdate();
    }
    checkDatabase4OldVersion();
  }

  static checkDatabase4OldVersion() async {
    try {
      Directory dir = await getTemporaryDirectory();
      Directory databaseDirectory =
          Directory(dir.parent.path + '/databases/AITD-Wallet');
      Database db = await openDatabase(
        databaseDirectory.path,
        password: "tianqixuda20200821",
      );
      Map<String, String> privateMaps = {}; //需要导入的私钥列表
      String mnemonicWord = ''; //需要导入的身份钱包助记词
      List<Map<String, Object?>> maps = await db.query('COIN_INFO');
      for (var element in maps) {
        Map<String, Object?> item = element;
        int coinComeType = getRow<int>(item, 'COIN__COME_TYPE', 1);
        if (coinComeType == 1) {
          //币种的来源（0代表创建，1代表导入）,忽略创建的币种
          String privateKey = getRow<String>(item, 'PRIVATE_KEY', '');
          int isMainChain = getRow<int>(item, 'IS_MAIN_CHAIN', 0);
          if (isMainChain == 1) {
            //只导入主链的信息
            String coinType = getRow<String>(item, 'MAIN_CHAIN_NAME', 'AITD');
            if (privateKey.isNotEmpty) {
              privateMaps[privateKey] = coinType;
            }
          }
        }
      }

      maps = await db.query('USER_INFORMATION');
      if (maps.isNotEmpty) {
        Map<String, Object?> hdMap = maps[0];
        mnemonicWord = getRow<String>(hdMap, 'MNEMONIC_WORD', '');
      }
      db.close();

      if (mnemonicWord.isNotEmpty || privateMaps.isNotEmpty) {
        UniModals.showImportModal(
            onBackPress: () async => false,
            onConfirm: () async {
              UniModals.showVerifySecurityPasswordModal(
                title: Text(I18nKeys.pleaseEnterPwd),
                verifyPassword: SecurityService.to.hasSecurityPassword,
                onSuccess: () {},
                onPasswordGet: (password) async {
                  Get.back();
                  Toast.showLoading();
                  if (!SecurityService.to.hasSecurityPassword) {
                    bool isBioPay = await SecurityService.to.isOpenBiometryPay;
                    await SecurityService.to
                        .setSecurityPassword(password, original: isBioPay);
                  }
                  await importWallet(mnemonicWord, privateMaps, password);
                  DBService.to.dbChanged.value += 1;
                  await databaseDirectory.delete(recursive: true);
                  Toast.hideLoading();
                },
              );
            },
            onCancel: () async {
              Get.back();
              databaseDirectory.delete(recursive: true);
            });
      }
    } catch (e) {
      print(e);
    }
  }

  static importWallet(String mnemonicWord, Map<String, String> privateMaps,
      String password) async {
    if (mnemonicWord.isNotEmpty) {
      String inputText = '';
      String inputTextEncrypt = '';
      var data = json.decode(mnemonicWord);
      for (String item in data) {
        if (inputText.isNotEmpty) {
          inputText = '$inputText $item';
        } else {
          inputText = item;
        }
      }
      inputTextEncrypt = WalletCreateController.encrypt(inputText, password);
      var wallet = Wallet(
          mnemonic: inputTextEncrypt,
          walletType: WalletType.HD,
          walletSource: WalletSource.CREATE);
      wallet.preHandle();

      ///查询wallet数据库
      final walletList =
          await DBService.to.walletDao.findAllByMnemonic(inputTextEncrypt);
      if (walletList.isEmpty) {
        int walletId = await DBService.to.walletDao.saveAndReturnId(wallet);

        ///查询支持的coin 列表
        for (var coinType in QiRpcService().supportCoins) {
          ///助记词创建钱包
          final qiCoinKeypair = await qiGenerateKeypairWithMnemonic(
              coinType: coinType, mnemonic: inputText);
          final coin = Coin(
            walletId: walletId,
            coinType: coinType.chainName(),
            coinName: coinType.fullName(),
            coinDecimals: coinType.coinDecimal(),
            coinUnit: coinType.coinUnit(),
            privateKey: WalletCreateController.encrypt(
                qiCoinKeypair.privateKey, password),
            publicKey: qiCoinKeypair.publicKey,
            coinAddress: qiCoinKeypair.address,
          );
          coin.preHandle();
          await DBService.to.coinDao.saveAndReturnId(coin);
        }
      }
    }
    if (privateMaps.isNotEmpty) {
      for (String privateKey in privateMaps.keys) {
        QiCoinType coinType =
            QiCoinCode44.parse(privateMaps[privateKey] ?? 'AITD');
        final qiCoinKeypair =
            await qiGenerateKeypairWithPrivateKey(coinType, privateKey);
        final coin = Coin(
          coinType: coinType.chainName(),
          coinName: coinType.fullName(),
          coinDecimals: coinType.coinDecimal(),
          coinUnit: coinType.coinUnit(),
          privateKey: WalletCreateController.encrypt(
              qiCoinKeypair.privateKey, password),
          publicKey: qiCoinKeypair.publicKey,
          coinAddress: qiCoinKeypair.address,
        );
        coin.preHandle();

        ///查询本地是否已经存在该地址
        final dbCoin = await DBService.to.coinDao
            .findAllByCoinAddress(coinType.coinUnit(), qiCoinKeypair.address);
        if (dbCoin.isEmpty) {
          var wallet = Wallet(
              walletType: WalletType.SINGLE_CHAIN,
              walletSource: WalletSource.IMPORT);
          wallet.preHandle();
          final walletId = await DBService.to.walletDao.saveAndReturnId(wallet);
          coin.walletId = walletId;
          coin.id = await DBService.to.coinDao.saveAndReturnId(coin);
        }
      }
    }
  }

  static T getRow<T>(Map<String, Object?> map, String key, T defaultValue) {
    Object? value = map[key];
    if (value != null && value is T) {
      T res = value as T;
      return res;
    }
    {
      return defaultValue;
    }
  }

  checkUpdate({forceShow = false}) async {
    ResponseModel<VersionInfoModel> response = await HttpService.service.http
        .get<VersionInfoModel>(ApiUrls.getVersion, data: {
      "langCode": LocalService.to.languageCodeNet,
      "type": DeviceUtils.isAndroid ? 1 : 2
    });
    _appInfoModel = response.data!;
    print(response.data!.versionNo);
    final appInfo = await AppService.service.info;
    String version = appInfo?.channelVersion ?? "2.0.0"; //版本号
    int versionCurrent = int.parse(version.replaceAll('.', ''));
    int versionNet = int.parse(response.data!.versionNo!.replaceAll('.', ''));
    int versionNetMin =
        int.parse(response.data!.minVersionNo!.replaceAll('.', ''));
    if (versionCurrent < versionNet) {
      _needUpdateVersion = true;
      if (versionCurrent < versionNetMin) {
        //force
      } else {
        //one day show once
        int? dateTimeInt = StorageUtils.sp.read<int>('versionTime');
        if (dateTimeInt != null) {
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateTimeInt);
          if (dateTime.isAtSameDayAs(DateTime.now())) {
            if (!forceShow) {
              return;
            }
          }
        }
        StorageUtils.sp
            .write('versionTime', DateTime.now().millisecondsSinceEpoch);
      }
    } else {
      return;
    }

    UniModals.showSingleActionPromptModal(
        icon: const WalletLoadImage("settings/version_upgrade"),
        title: Text(I18nKeys.findNewVersion),
        showCloseIcon: versionCurrent >= versionNetMin,
        barrierDismissible: false,
        cancelable: false,
        message: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'V${response.data!.versionNo} ${I18nKeys.update}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              response.data!.versionContent ?? "",
            ),
          ],
        ),
        action: InkWell(
            onTap: () async {
              if (true || await canLaunch(response.data!.h5Url!)) {
                await launch(response.data!.h5Url!, forceSafariVC: false);
              }
            },
            child: Text(I18nKeys.update)),
        actionStyle: UniButtonStyle.Primary);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  checkConnect() async {
    await WalletConnectService.service.loadService();
    update();
  }
}
