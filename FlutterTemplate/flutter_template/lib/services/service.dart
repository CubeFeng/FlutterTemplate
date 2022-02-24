import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_template/services/app_service.dart';
import 'package:flutter_template/services/config_service.dart';
import 'package:flutter_template/services/http_service.dart';

BindingsBuilder initService() {
  return BindingsBuilder(() {
    Get.putAsync(() async => await ConfigService());
    Get.putAsync(() async => await AppService());
    Get.putAsync(() async => await HttpService());
  });
}
