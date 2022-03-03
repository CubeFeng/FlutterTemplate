import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 数据库服务
class DBService extends GetxService {
  /// 数据库服务实例
  static DBService get to => Get.find();

  /// 数据库服务实例
  static DBService get service => Get.find();

  late final WalletDatabase _db;

  /// 数据库实例
  WalletDatabase get db => _db;

  /// 地址簿
  AddressDao get addressDao => _db.addressDao;

  /// 钱包
  WalletDao get walletDao => _db.walletDao;

  /// 币种
  CoinDao get coinDao => _db.coinDao;

  /// 代币
  TokenDao get tokenDao => _db.tokenDao;

  /// 交易记录
  TxDao get txDao => _db.txDao;

  /// 数据库更新监听
  final dbChanged = 1.obs;

  Future<DBService> didInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    final sp = await SharedPreferences.getInstance();
    var timestamp = sp.getString("__.wallet.timestamp");
    if (timestamp == null) {
      timestamp = DateTime.now().microsecondsSinceEpoch.toString();
      sp.setString("__.wallet.timestamp", timestamp);
    }
    final password = EncryptUtils.encryptMD5(timestamp, "@aitd-wallet").toLowerCase();
    await WalletDatabase.setup(
      password: password,
      isCreateNow: true,
    );
    _db = await WalletDatabase.getInstance();
    return this;
  }
}
