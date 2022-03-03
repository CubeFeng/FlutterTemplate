import 'dart:async';

import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/modules/property/controllers/property_controller.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/security_service.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/services/wallet_service.dart';

class RestoreSettingsController extends GetxController {
  late List<Map> _optionsList = [];
  final _selectedCount = 0.obs;
  late Timer _timer;
  final maxCount = 10.obs;

  bool get canRestoreAction => maxCount.value == -1 && _selectedCount.value == 4;

  ///恢复初始数据弹窗
  void selectedOptionsWithMap(map) {

    for (Map tempMap in _optionsList) {
      if (map["status"] == "0" && map["id"] == tempMap["id"]) {
        _selectedCount.value += 1;
        tempMap["status"] = "1";
        break;
      }

      if (map["status"] == "1" && map["id"] == tempMap["id"]) {
        _selectedCount.value -= 1;
        tempMap["status"] = "0";
        break;
      }
    }
  }

  List<Map> getOptionList() {
    List<Map> tempList = [
      {"name": I18nKeys.restoreSettingsTip1, "status": "0", "id": "110"}.obs,
      {"name": I18nKeys.restoresSettingsTip2, "status": "0", "id": "111"}.obs,
      {"name": I18nKeys.restoreSettingsTip3, "status": "0", "id": "112"}.obs,
      {"name": I18nKeys.restoreSettingsTip4, "status": "0", "id": "113"}.obs,
    ];
    _optionsList = tempList;
    return tempList;
  }

  Future<void> _cleanWalletDB() async {
    WalletService.service.currentCoin = null;
    Get.find<PropertyController>().update();
    StorageUtils.sp.delete('currentCoin');
    DBService.to.db.wipeData();
    SecurityService.to.cleanPassword();
  }

  void addTimer(bool cancel) {
    if (cancel) {
      _selectedCount.value = 0;
      _timer.cancel();
    } else {
      _selectedCount.value = 0;
      maxCount.value = 10;
      _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
        // print("  倒计时 ");
        if (maxCount < 0) {
          _timer.cancel();
        } else {
          maxCount.value -= 1;
        }
        update();
      });
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    print("object onClose");
  }
}
