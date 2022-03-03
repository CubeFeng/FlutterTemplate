import 'package:flutter_wallet/embed/embed_service.dart';
import 'package:flutter_wallet/modules/home/controllers/home_controller.dart';
import 'package:flutter_wallet/modules/property/controllers/property_controller.dart';
import 'package:flutter_wallet/modules/settings/controllers/my_controller.dart';
import 'package:flutter_wallet/services/app_service.dart';
import 'package:flutter_wallet/services/auth_service.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/http_service.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/services/security_service.dart';
import 'package:flutter_wallet/services/wallet_connect_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:get/get.dart';

/// 初始化 service
Future<BindingsBuilder> globalBindings() async {
  await Get.putAsync(() async => await DBService().didInit());
  return BindingsBuilder(() {
    Get.putAsync(() async => AppService());
    Get.putAsync(() async => HttpService());
    Get.putAsync(() async => AuthService());
    Get.putAsync(() async => LocalService());
    Get.putAsync(() async => SecurityService());
    Get.putAsync(() async => WalletService());
    Get.putAsync(() async => WalletConnectService());
    // 全局Controller
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => PropertyController());
    Get.lazyPut(() => MyController());
  });
}
