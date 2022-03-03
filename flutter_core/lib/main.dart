import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_dev_tools/data_delegate.dart';
import 'package:flutter_dev_tools/flutter_dev_tools.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ucore/apis/api_urls.dart';
import 'package:flutter_ucore/common/in_app_navigator_observer.dart';
import 'package:flutter_ucore/i18n/i18n.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/app_service.dart';
import 'package:flutter_ucore/services/service.dart';
import 'package:flutter_ucore/theme/app_theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
///  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
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 显示状态栏、底部按钮栏(因为在启动页的时候进行了隐藏)
  await AppHelper.disableFullscreen();

  /// 透明状态栏
  if (DeviceUtils.isAndroid) {
    const systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  await AppHelper.portraitModeOnly();

  /// 此处设置默认的api环境(初始值为test)
  AppEnv.defaultEnv = AppEnvironments.pre;

  /// 执行 RunApp
  await runMainApp(
    appName: 'UCore',
    beforeRunApp: () async {
      /// 初始化 Url
      await ApiUrls.initApiUrls();

      logger.i('应用运行路径: ${await getApplicationSupportDirectory()}');
    },
    afterRunApp: () async {
      if (AppEnv.currentEnv() != AppEnvironments.prod) {
        FlutterDevTools.init(delegate: DevToolsDelegate());
      }
    },
    initialBinding: await initService(),
    theme: AppTheme.theme,
    darkTheme: AppTheme.theme,
    designSize: const Size(375, 812),
    themeMode: ThemeMode.system,
    translations: I18nTranslations(),
    supportedLocales: SupportedLocales.values,
    locale: Get.locale,
    fallbackLocale: SupportedLocales.zh_CN,
    getPages: AppPages.routes,
    defaultTransition: Transition.cupertino,
    navigatorObservers: [InAppNavigatorObserver()],
    initialRoute: AppPages.routes.first.name,
    sentryDSN: kReleaseMode
        ? 'https://1582f27705f94fed9af64fe7cd1c4ad0@o1065516.ingest.sentry.io/6057298'
        : null,
    localizationsDelegates: const [
      RefreshLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
  );
}

class DevToolsDelegate implements FlutterDevToolsDataDelegate {
  @override
  Map<String, dynamic>? get apiHost {
    return ApiUrls.apiHost.toJson();
  }

  @override
  List<Map<String, dynamic>>? get data {
    final appInfo = AppService.service.appInfoModel;
    final infoData = [
      {'title': '编译时间', 'value': appInfo?.buildTime},
      {'title': 'commit', 'value': appInfo?.commitId},
      {'title': 'branch', 'value': appInfo?.branch},
      {'title': '渠道类型', 'value': appInfo?.channelType},
      {'title': '渠道名称', 'value': appInfo?.channelName},
      {'title': '渠道版本', 'value': appInfo?.channelVersion}
    ];
    return infoData;
  }
}
