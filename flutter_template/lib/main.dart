import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_template/apis/api_urls.dart';
import 'package:flutter_template/i18n/i18n.dart';
import 'package:flutter_template/routes/app_pages.dart';
import 'package:flutter_template/services/service.dart';
import 'package:flutter_template/theme/app_theme.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();

   /// 显示状态栏、底部按钮栏(因为在启动页的时候进行了隐藏)
   SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

   /// 透明状态栏
   if (DeviceUtils.isAndroid) {
      const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
   }

   /// 此处设置默认的api环境(初始值为test)
   AppEnv.defaultEnv = AppEnvironments.test;

   /// 执行 RunApp
   await runMainApp(
       appName: 'UCore',
       beforeRunApp: () async {
          /// 初始化 Url
          await ApiUrls.initApiUrls();
       },
       initialBinding: initService(),
       theme: AppTheme.theme,
       darkTheme: AppTheme.darkTheme,
       designSize: const Size(375, 812),
       translations: I18nTranslations(),
       supportedLocales: Locales.supportedLocales,
       locale: ui.window.locale,
       fallbackLocale: Locales.en_US,
       getPages: AppPages.routes,
       initialRoute: AppPages.routes.first.name);
}




/*******************原始 代码 ****************************/

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
