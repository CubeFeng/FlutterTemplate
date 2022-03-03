import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await precacheImage(ImageUtils.getAssetImage('common/splash_logo'), context);
      await [Permission.storage, Permission.phone].request();
      await Future.delayed(Duration(milliseconds: 1500));
      if (await LocalService.to.getCurrentVersionFirstStartupTimestamp() == null) {
        Get.offAllNamed(Routes.GUIDE);
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xFFFE9A4E),
          child: Stack(
            // alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 150,
                left: 0,
                right: 0,
                child: SizedBox(
                  width: 162,
                  height: 116,
                  child: LoadAssetImage('common/splash_logo'),
                ),
              ),
              Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(I18nKeys.ucore, style: TextStyle(fontSize: 25, color: Colors.white)),
                      SizedBox(height: 10),
                      Text(
                        I18nKeys.link_future,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ))
            ],
          )),
    );
  }
}
