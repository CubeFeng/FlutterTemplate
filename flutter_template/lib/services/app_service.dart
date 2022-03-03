import 'dart:convert';

import 'package:flutter_template/models/app_info_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_udid/flutter_device_udid.dart';
import 'package:get/get.dart';
import 'package:flutter_base_kit/utils/device_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

class AppService extends GetxService {
  static AppService get service => Get.find();

  AppInfoModel? _appInfoModel;

  Future<AppInfoModel?> get info async {
    // 因为目前只支持 iOS、Android
    if (!DeviceUtils.isMobile) {
      throw UnsupportedError('不支持当前平台');
    }
    if (_appInfoModel == null) {
      await _initInfo();
    }
    return _appInfoModel;
  }

  @override
  void onInit()  async{
    await _initInfo();
    super.onInit();
  }

  Future<void> _initInfo() async{
    final String jsongString = await rootBundle.loadString('assets/config/app.config.json');
    final dynamic jsonObj = json.decode(jsongString);
    _appInfoModel = AppInfoModel().fromJson(jsonObj[DeviceUtils.isAndroid ? 'Android' : 'iOS'] as Map<String,dynamic>);
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    _appInfoModel!.version = packageInfo.version;
    _appInfoModel!.buildVersion = packageInfo.buildNumber;
    _appInfoModel!.packageName = packageInfo.packageName;

    var deviceId;
    try{
      deviceId  = await FlutterDeviceUdid.udid;
    }catch(e){
      deviceId = const Uuid().v4();
    }
    _appInfoModel!.deviceId = deviceId;
  }
}
