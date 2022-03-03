import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_base_kit/utils/device_utils.dart';
import 'package:flutter_device_udid/flutter_device_udid.dart';
import 'package:flutter_wallet/generated/json_partner/json_partner.dart';
import 'package:flutter_wallet/models/app_info_model.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

class AppService extends GetxService {
  static AppService get to => Get.find();

  static AppService get service => Get.find();

  final _appInfoModel = Rx<AppInfoModel?>(null);

  AppInfoModel? get appInfoModel => _appInfoModel.value;

  /// 获取app相关信息
  /// [AppInfoModel] 应用信息
  Future<AppInfoModel?> get info async {
    // 因为目前只支持 iOS、Android
    if (!DeviceUtils.isMobile) {
      throw UnsupportedError('不支持当前平台');
    }
    if (_appInfoModel.value == null) {
      await _initInfo();
    }
    return _appInfoModel.value;
  }

  @override
  void onInit() async {
    await _initInfo();
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    if (kReleaseMode) {
      injectSentryInfo();
    }
  }

  Future<void> _initInfo() async {
    final jsonString = await WalletAssets.loadString('assets/config/app.config.json');
    final dynamic jsonObj = json.decode(jsonString);
    final aim = JsonPartner.fromJsonAsT<AppInfoModel>(
        jsonObj[DeviceUtils.isAndroid ? 'Android' : 'iOS'] as Map<String, dynamic>);
    final packageInfo = await PackageInfo.fromPlatform();
    aim.version = packageInfo.version;
    aim.buildVersion = packageInfo.buildNumber;
    aim.packageName = packageInfo.packageName;
    String deviceId;
    try {
      deviceId = await FlutterDeviceUdid.udid;
    } catch (e) {
      deviceId = const Uuid().v4();
    }
    aim.deviceId = deviceId.replaceAll('-', '');
    _appInfoModel.value = aim;
  }

  Future<void> injectSentryInfo() async {
    await SentryManager.injectAppInfo(SentryAppExtInfo(
        deviceId: appInfoModel?.deviceId ?? '',
        commitId: appInfoModel?.commitId ?? '',
        buildTime: appInfoModel?.buildTime ?? '',
        channelName: appInfoModel?.channelName ?? '',
        channelVersion: appInfoModel?.channelVersion ?? ''));
  }
}
