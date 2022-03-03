import 'dart:io';

import 'package:flutter_base_kit/flutter_base_kit.dart';

class SecurityLockController extends GetxController {
  late List<Map> optionsList = [

  ];


  late String lockType;

  // Platform
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    print("object onClose");
    if (DeviceUtils.isAndroid) {
      lockType = "指纹解锁";
    }else{

      Platform.isIOS;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    print("object onClose");
  }
}
