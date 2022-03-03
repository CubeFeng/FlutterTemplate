import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

/// 收款二维码
class ReceiveQrCodeView extends StatelessWidget {
  ///
  final globalKey = GlobalKey();

  ReceiveQrCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Coin coin = WalletService.service.currentCoin!;
    String image = Get.parameters['image'] ?? '';
    return Scaffold(
      appBar: QiAppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const WalletLoadAssetImage(
            'common/icon_arrow_left',
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF277CEB),
        title: Text(
          I18nKeys.receive,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          RepaintBoundary(
            key: globalKey,
            child: _buildShareCard(coin),
          ),
          Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF277CEB),
                    Color(0xFF2750EB),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 491,
                    width: 345,
                    margin: EdgeInsets.only(
                        left: 15.sp, right: 15.sp, top: 24.sp, bottom: 36.sp),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'packages/flutter_wallet_assets/assets/images/wallet/img_share_bg.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 24),
                            image.isEmpty
                                ? WalletLoadAssetImage(
                                    'property/icon_coin_${coin.coinUnit!.toLowerCase()}',
                                    width: 43.r,
                                    height: 43.r,
                                  )
                                : WalletLoadImage(
                                    image,
                                    width: 43.r,
                                    height: 43.r,
                                  ),
                            SizedBox(height: 14),
                            Text(
                              I18nKeys.sweepAndPayMe,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Color(0xFF333333),
                              ),
                            ),
                            SizedBox(height: 24),
                            QrImage(data: coin.coinAddress!, size: 182.r),
                            SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(11)),
                              child: Text(
                                I18nKeys.collectionAddress,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: const Color(0xFF666666),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 55),
                              child: Text(
                                coin.coinAddress!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF666666),
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 65,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton.icon(
                                  icon: const WalletLoadAssetImage(
                                      'wallet/icon_share'),
                                  style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(Colors.transparent)
                                  ),
                                  label: Text(
                                    I18nKeys.share,
                                    style: TextStyle(
                                        color: const Color(0xFF333333),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    _didShare();
                                    // Get.toNamed(
                                    //   Routes.PROPERTY_RECEIVE_SHARE,
                                    //   arguments: coin,
                                    // );
                                  },
                                ),
                              ),
                              Gaps.vvLine(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.09)),
                              Expanded(
                                child: TextButton.icon(
                                  icon: const WalletLoadAssetImage(
                                      'wallet/icon_copy'),
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(Colors.transparent)
                                  ),
                                  label: Text(
                                    I18nKeys.copy,
                                    style: TextStyle(
                                        color: const Color(0xFF333333),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: coin.coinAddress));
                                    Get.showTopBanner(I18nKeys.copySuc,
                                        style: TopBannerStyle.Default);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      I18nRawKeys
                          .noteThisAddressIsOnlyApplicableToTheTransferOnTheXXXChainAndShouldNotBeUsedInOtherCurrencies
                          .trPlaceholder([coin.coinUnit ?? ""]),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFFFFFF).withOpacity(0.8)),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildShareCard(Coin coin) {
    return Container(
      width: 320,
      height: 451,
      margin: EdgeInsets.only(
        top: 15.sp,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
                'packages/flutter_wallet_assets/assets/images/share/share_card.png'),
            fit: BoxFit.fill),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 24),
                WalletLoadAssetImage(
                  'property/icon_coin_${coin.coinUnit!.toLowerCase()}',
                  width: 43.r,
                  height: 43.r,
                ),
                SizedBox(height: 10),
                Text(
                  I18nKeys.sweepAndPayMe,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                ),
                SizedBox(height: 25),
                Container(
                  width: 162.r,
                  height: 162.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: QrImage(data: coin.coinAddress!, size: 162),
                ),
                SizedBox(height: 32),
                Container(
                  height: 20,
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
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
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 52),
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
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 29, right: 29, bottom: 19),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WalletLoadAssetImage('share/share_logo',
                      width: 128, height: 17),
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
