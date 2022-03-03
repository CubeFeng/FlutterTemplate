import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart' hide runMainApp;
import 'package:flutter_base_kit/utils/device_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_wallet/apis/api_urls.dart';
import 'package:flutter_wallet/embed/embed_service.dart';
import 'package:flutter_wallet/i18n/i18n.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/service.dart';
import 'package:flutter_wallet/theme/app_theme.dart';
import 'package:flutter_wallet/vendor/application_framework.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_dapp_browser/flutter_wallet_dapp_browser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// autoimport umeng: 请不要更改此行

Future<void> main() async {
  startApp(initialRoute: Routes.SPLASH);
}

Future<void> startApp({
  required String initialRoute,
  Locale? locale,
  Size? predictScreenSize,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 透明状态栏
  if (DeviceUtils.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
  }

  /// 此处设置默认的api环境(初始值为test)
  AppEnv.defaultEnv = AppEnvironments.pre;

  /// 提前注入
  Get.put(DappsBrowserService());
  Get.put(EmbedService());

  /// 执行 RunApp
  await runMainApp(
    appName: 'AITD Wallet',
    beforeRunApp: () async {
      /// 初始化 Url
      await ApiUrls.initApiUrls();

      /// 根据 app 环境配置对应的链环境
      QiRpcService.setChainNet(AppEnv.currentEnv() == AppEnvironments.prod
          ? QiChainNet.MAIN_CHAIN_NET
          : QiChainNet.TEST_NET);

      // autoconfig umeng: 请不要更改此行

      logger.i('应用运行路径: ${await getApplicationSupportDirectory()}');
    },
    afterRunApp: () async {
      /// 显示状态栏、底部按钮栏(因为在启动页的时候进行了隐藏)
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    },
    initialBinding: await globalBindings(),
    theme: AppTheme.theme,
    darkTheme: AppTheme.darkTheme,
    designSize: const Size(375, 812),
    predictScreenSize: predictScreenSize ?? const Size(375, 812),
    themeMode: ThemeMode.light,
    translations: I18nTranslations(),
    supportedLocales: SupportedLocales.values,
    locale: locale ?? Get.locale,
    fallbackLocale: SupportedLocales.zh_CN,
    getPages: AppPages.routes,
    defaultTransition: Transition.cupertino,
    initialRoute: initialRoute,
    sentryDSN: kReleaseMode
        ? 'https://45044522a0bb40ce90b89b957ca6eee5@o1065516.ingest.sentry.io/6057299'
        : null,
    localizationsDelegates: const [
      RefreshLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
  );
}
