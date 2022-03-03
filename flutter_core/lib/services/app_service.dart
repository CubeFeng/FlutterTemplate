import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/models/app_info_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
// import 'package:flutter_base_kit/utils/device_utils.dart';
import 'package:flutter_device_udid/flutter_device_udid.dart';
import 'package:flutter_ucore/widgets/app_update_widget.dart';
// import 'package:get/get.dart';
// import 'package:package_info_plus/package_info_plus.dart';
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
  void onReady() {
    super.onReady();
    if (kReleaseMode) {
      injectSentryInfo();
    }
    checkVersion();
  }

  Future<void> injectSentryInfo() async {
    await SentryManager.injectAppInfo(SentryAppExtInfo(
        deviceId: appInfoModel?.deviceId ?? '',
        commitId: appInfoModel?.commitId ?? '',
        buildTime: appInfoModel?.buildTime ?? '',
        channelName: appInfoModel?.channelName ?? '',
        channelVersion: appInfoModel?.channelVersion ?? ''));
  }

  Future<void> _initInfo() async {
    final String jsonString = await rootBundle.loadString('assets/config/app.config.json');
    final dynamic jsonObj = json.decode(jsonString);
    final aim = AppInfoModel().fromJson(jsonObj[DeviceUtils.isAndroid ? 'Android' : 'iOS'] as Map<String, dynamic>);
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
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

  void checkVersion({bool showTips = false, bool showLoading = false}) {
    if (showLoading) {
      Toast.showLoading();
    }
    UserApi.checkVersion(osType: DeviceUtils.isAndroid ? 1 : 2).then((value) {
      Toast.hideLoading();
      if (value.code == 0) {
        final version = int.tryParse(value.data?.version?.replaceAll('.', '') ?? '') ?? 0;
        final appVersion = int.tryParse(appInfoModel?.version?.replaceAll('.', '') ?? '') ?? 0;
        if (appVersion < version) {
          final versionInfo = value.data;
          if (versionInfo != null && versionInfo.downloadUrl != null) {
            Future.delayed(Duration(seconds: showLoading ? 0 : 3), () {
              Get.dialog(
                  AppUpdateWidget(
                    downloadUrl: versionInfo.downloadUrl!,
                    desc: versionInfo.content ?? '',
                    forced: versionInfo.forced == 1,
                  ),
                  barrierDismissible: false);
            });
          }
        } else {
          if (showTips) {
            Toast.show(I18nKeys.has_not_found_new_version);
          }
        }
      }
    }).catchError((_) {
      Toast.hideLoading();
    });
  }
}
