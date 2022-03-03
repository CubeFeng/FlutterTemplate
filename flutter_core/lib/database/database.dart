import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'converter/converter.dart';
import 'dao/message_dao.dart';
import 'entity/message_entity.dart';

part 'database.g.dart';

@TypeConverters([DateTimeConverter, MessageContentConverter])
@Database(version: 2, entities: [MessageEntity])
abstract class AppDatabase extends FloorDatabase {
  MessageDao get messageDao;

  //<editor-fold desc="Database Factory">
  static AppDatabase? _instance;

  /// 获取数据库实例
  static Future<AppDatabase> getInstance() async {
    _instance ??= await _createInstance();
    return _instance!;
  }

  /// 创建数据库实例
  static Future<AppDatabase> _createInstance() async {
    /// 数据库升级
    /// 1=>2 新增用户ID字段
    final migration_1_2 = Migration(1, 2, (db) async {
      await db.execute("ALTER TABLE MessageEntity ADD user_id TEXT NOT NULL DEFAULT ''");
    });
    return await $FloorAppDatabase
        .databaseBuilder('app_database.db')
        .addMigrations([migration_1_2]).build();
  }
  //</editor-fold>
}
