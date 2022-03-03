import 'package:flutter_ucore/services/app_service.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/services/config_service.dart';
import 'package:flutter_ucore/services/db_service.dart';
import 'package:flutter_ucore/services/http_service.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:flutter_ucore/services/message_service.dart';
import 'package:flutter_ucore/services/oauth2_service.dart';
import 'package:flutter_ucore/services/task_service.dart';
import 'package:get/get.dart';

Future<BindingsBuilder> initService() async {
  await Get.putAsync(() async => await DBService().init());
  return BindingsBuilder(() {
    Get.putAsync(() async => await ConfigService());
    Get.putAsync(() async => await AppService());
    Get.putAsync(() async => await HttpService());
    Get.putAsync(() async => await AuthService());
    Get.putAsync(() async => await MessageService());
    Get.putAsync(() async => await OAuth2Service());
    Get.putAsync(() async => await LocalService());
    Get.putAsync(() async => await TaskService());
  });
}
