import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter_wallet/embed/embed_helper.dart';
import 'package:flutter_wallet/main.dart' as wallet_main;
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('===============Embed Wallet===============');
  print('===============defaultRouteName: ${ui.window.defaultRouteName}');
  final sp = await SharedPreferences.getInstance();
  final width = sp.getDouble("embed.screen.width");
  final height = sp.getDouble("embed.screen.height");
  final predictScreenSize =
      (width == null || height == null) ? null : Size(width, height);

  await wallet_main.startApp(
    initialRoute: Routes.HOME,
    locale: EmbedHelper.embedLaunchLocale,
    predictScreenSize: predictScreenSize,
  );
}
