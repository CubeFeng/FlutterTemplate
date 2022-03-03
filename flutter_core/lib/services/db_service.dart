import 'package:flutter_ucore/database/dao/message_dao.dart';
import 'package:flutter_ucore/database/database.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

class DBService extends GetxService {
  static DBService get service => Get.find();

  late final AppDatabase _database;

  AppDatabase get db => _database;

  MessageDao get messageDao => _database.messageDao;

  Future<DBService> init() async {
    _database = await AppDatabase.getInstance();
    return this;
  }

  @override
  void onInit() async {
    super.onInit();
  }
}
