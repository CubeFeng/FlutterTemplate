import 'dart:async';

import 'package:flutter_ucore/services/local_service.dart';
import 'package:flutter_ucore/services/oauth2_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static const THEME_ID = 0x01;

  StreamSubscription? _themeSub;

  @override
  void onInit() {
    super.onInit();
    OAuth2Service.to.startInterceptOAuth2();
    _themeSub = LocalService.to.darkThemeObservable.listen((_) async {
      await Future.delayed(Duration(milliseconds: 250));
      update([THEME_ID]);
    });
  }

  @override
  void onClose() {
    _themeSub?.cancel();
    super.onClose();
  }
}
