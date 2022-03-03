import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_qrscan_plugin/flutter_qrscan_plugin.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanCodeView extends StatefulWidget {
  const ScanCodeView({Key? key}) : super(key: key);

  @override
  State<ScanCodeView> createState() => _ScanCodeViewState();
}

class _ScanCodeViewState extends State<ScanCodeView> {
  @override
  void initState() {
    super.initState();

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
      body: Stack(
        children: [
          QrScanView(
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
    );
  }
}
