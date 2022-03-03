import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_qrscan_plugin/flutter_qrscan_plugin.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanView extends StatefulWidget {
  const ScanView({Key? key}) : super(key: key);

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  @override
  void initState() {
    super.initState();

    if (false) {
      String url =
          'wc:2b19aaf7-6c9b-4775-b439-15cea93980f6@1?bridge=https%3A%2F%2Fbridge.walletconnect.org%2F&key=9101528bd453ece5e03d16bfd51daa58e6a53e23a80d1eee18832aa2551a00a4';
      Get.back(result: url);
      return;
    }

    Permission.camera.request().then((value) {
      print("_ScanCodeViewState camera $value");
      if (value == PermissionStatus.permanentlyDenied ||
          value == PermissionStatus.denied ||
          value == PermissionStatus.restricted) {}
    });

    Permission.photos.request().then((value) {
      print("_ScanCodeViewState photos $value");
      if (value == PermissionStatus.permanentlyDenied ||
          value == PermissionStatus.denied ||
          value == PermissionStatus.restricted) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: 340,
            child: Stack(
              children: [
                QrScanView(
                  scanPrompt: '',
                  enableFromGallery: false,
                  onResult: (result, source, disposable) {
                    if (result == null) {
                      disposable.rescan();
                      return;
                    }
                    Get.back(result: result.text);
                  },
                ),
                Positioned(
                  top: 36,
                  left: 16,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const WalletLoadAssetImage(
                      'common/icon_arrow_left',
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                itemView(
                    'wallet/icon_step1',
                    I18nKeys.openDAPP,
                    I18nKeys
                        .clickConnectWalletInTheUpperRightCornerOfDAPPAndSelectWalletconnect),
                const SizedBox(
                  height: 8,
                ),
                itemView(
                    'wallet/icon_step2',
                    I18nKeys.selectAddress,
                    I18nKeys
                        .afterSuccessfulScanningSelectTheAddressYouWantToConnect),
                const SizedBox(
                  height: 8,
                ),
                itemView(
                    'wallet/icon_step3',
                    I18nKeys.confirmConnection,
                    I18nKeys
                        .clickAuthorizedConnectionDAPPWillBeAuthorizedToDirectlyUseThisAddressForTransferTransactions),
              ],
            ),
          ))
        ],
      ),
    );
  }

  itemView(String assets, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 15),
            child: WalletLoadImage(
              assets,
              width: 25,
              height: 25,
              fit: BoxFit.fitHeight,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  desc,
                  maxLines: 2,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
