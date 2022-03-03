import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/home/controllers/home_controller.dart';
import 'dart:ui' as ui;

class InviteSharePage extends StatelessWidget {
  InviteSharePage({Key? key}) : super(key: key);
  final _homeController = Get.find<HomeController>();
  final _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        RepaintBoundary(
          key: _globalKey,
          child: _buildShareCard(),
        ),

        Positioned(
          child: Container(
            width: double.infinity,
            height: double.infinity,

            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(
                    'packages/flutter_wallet_assets/assets/images/settings/share_bg_icon.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Positioned(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: QiAppBar(
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                    icon: const Icon(
                      CupertinoIcons.share,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      _didShare();
                    })
              ],
            ),
            body: Container(
              // color: Colors.red,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  SizedBox(height: 65.h),
                  Text(
                    I18nKeys.inviteShareTitle,
                    style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    I18nKeys.inviteShareSubtitle,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  const SizedBox(
                    height: 245,
                    width: 327,
                    child: WalletLoadAssetImage("settings/share_content_icon"),
                  ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(bottom: 52.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "AITD Wallet",
                                style: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                I18nKeys.inviteShareBottomDec,
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF000000)),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5,),
                        QrImage(data: _homeController.appInfoModel.h5Url??'', size: 50.r,padding: EdgeInsets.zero,),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }


  Widget _buildShareCard() {
    return Container(
      width: 333.h,
      height: 570.h,
      margin: EdgeInsets.only(
        top: 15.sp,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
                'packages/flutter_wallet_assets/assets/images/settings/invite_share_cardbg.png'),
            fit: BoxFit.fill),
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          // color: Colors.red,
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              SizedBox(height: 60.h),
              Text(
                I18nKeys.inviteShareTitle,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                I18nKeys.inviteShareSubtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50.h,
              ),
              const SizedBox(
                height: 204,
                width: 278,
                child: WalletLoadAssetImage("settings/share_content_icon"),
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.only(bottom: 22.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "AITD Wallet",
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            I18nKeys.inviteShareTitle,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF000000)),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5,),
                    QrImage(data: _homeController.appInfoModel.downloadUrl!, size: 50.r,padding: EdgeInsets.zero,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _didShare() async {
    final boundary =
    _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(
      pixelRatio: ui.window.devicePixelRatio,
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    final dir = await getTemporaryDirectory();
    print(dir.path);
    var savedFile = File('${dir.path}/share.png');
    await savedFile.writeAsBytes(pngBytes, mode: FileMode.write, flush: true);
    await Share.shareFiles([savedFile.path]);
    //Get.back();
  }
}
