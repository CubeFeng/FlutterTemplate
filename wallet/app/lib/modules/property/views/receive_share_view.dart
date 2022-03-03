import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ReceiveShareView extends StatefulWidget {
  const ReceiveShareView({Key? key}) : super(key: key);

  @override
  State<ReceiveShareView> createState() => _ReceiveShareViewState();
}

class _ReceiveShareViewState extends State<ReceiveShareView> {
  final globalKey = GlobalKey();

  Coin get coin => Get.arguments as Coin;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      Future.delayed(Duration(milliseconds: 150), () {
        _didShare();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1D385C),
            Color(0xFF293767),
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 75.h,
          ),
          RepaintBoundary(
            key: globalKey,
            child: _buildShareCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildShareCard() {
    return Container(
      width: 320.w,
      height: 451.h,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('packages/flutter_wallet_assets/assets/images/share/share_card.png'),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(height: 24.h),
            WalletLoadAssetImage(
              'property/icon_coin_${coin.coinUnit!.toLowerCase()}',
              width: 43.r,
              height: 43.r,
            ),
            SizedBox(height: 10.h),
            Text(
              I18nKeys.sweepAndPayMe,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: Colors.white),
            ),
            SizedBox(height: 25.h),
            Container(
              width: 162.r,
              height: 162.r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: QrImage(data: coin.coinAddress!, size: 162),
            ),
            SizedBox(height: 32.h),
            Container(
              height: 20.h,
              padding: EdgeInsets.only(
                left: 15.w,
                right: 15.w,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    I18nKeys.collectionAddress,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 52.w),
              child: Text(
                coin.coinAddress ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Padding(
              padding: EdgeInsets.only(left: 29.sp, right: 29.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WalletLoadAssetImage('share/share_logo',
                      width: 128.w, height: 17.h),
                  QrImage(
                    data: 'http://reg.aitdcoin.com/#/download',
                    size: 36.r,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _didShare() async {
    final boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
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
