import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as sqflite;

import 'conv/conv.dart';
import 'dao/dao.dart';
import 'entity/entity.dart';

part 'db.g.dart';

/// 钱包数据库
@TypeConverters([
  DateTimeConverter,
  DateTimeNotNullConverter,
  BigIntConverter,
  WalletSourceConverter,
  WalletTypeConverter,
  TxStatusConverter,
])
@Database(
  version: 1,
  entities: [Address, Coin, Tx, Token, Wallet],
)
abstract class WalletDatabase extends FloorDatabase {
  /// 地址簿Dao
  AddressDao get addressDao;

  /// 币种Dao
  CoinDao get coinDao;

  /// 代币Dao
  TokenDao get tokenDao;

  /// 交易记录Dao
  TxDao get txDao;

  /// 钱包Dao
  WalletDao get walletDao;

  /// 清空数据库数据
  Future<void> wipeData() async {
    final database = (await getInstance()).database;
    await database.rawDelete('DELETE FROM tb_address');
    await database.rawDelete('DELETE FROM tb_tx');
    await database.rawDelete('DELETE FROM tb_token');
    await database.rawDelete('DELETE FROM tb_coin');
    await database.rawDelete('DELETE FROM tb_wallet');
  }

// region 数据库工厂
  static WalletDatabase? _instance;

  static String? _password;
  static bool? _inMemory;

  /// 配置数据库
  /// [password] 密码
  /// [inMemory] 是否为内存数据库
  /// [isCreateNow] 是否立即创建
  static Future<void> setup(
      {String? password, bool? inMemory, bool? isCreateNow}) async {
    _password = password;
    _inMemory = inMemory;
    if (isCreateNow == true) {
      await _createInstance();
    }
  }

  /// 获取数据库实例
  static Future<WalletDatabase> getInstance() async {
    _instance ??= await _createInstance();
    return _instance!;
  }

  /// 创建数据库实例
  static Future<WalletDatabase> _createInstance() async {
    final db = await (_inMemory == true
            ? $FloorWalletDatabase.inMemoryDatabaseBuilder()
            : $FloorWalletDatabase.databaseBuilder(
                /*name*/
                'wallet.db',
                /*password*/
                _password,
              ))
        .build();
    return db;
  }

//endregion

}
