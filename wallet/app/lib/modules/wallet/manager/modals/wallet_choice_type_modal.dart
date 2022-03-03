import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/models/wallet_importtype_model.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/generated/icon_font.g.dart';

/// 请选择钱包类型
class WalletChoiceTypeModal extends StatefulWidget {
  final String chainName;

  const WalletChoiceTypeModal({
    Key? key,
    required this.chainName,
  }) : super(key: key);

  @override
  State<WalletChoiceTypeModal> createState() => _WalletChoiceTypeModalState();
}

class _WalletChoiceTypeModalState extends State<WalletChoiceTypeModal> {
  var _isImportMode = false;
  int _fixCount = 0;
  var _isFixMode = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Material(
        color: Colors.white.withOpacity(0.1),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 21.w),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(15.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:
                      _isImportMode ? _buildImportMode() : _buildChoiceType(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceType() {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 14.sp,
        color: const Color(0xFF333333),
        fontWeight: FontWeight.bold,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.h),
          Text(I18nKeys.chooseWalletType, style: TextStyle(fontSize: 13.sp)),
          SizedBox(height: 21.h),
          _buildFuncItem(
            icon: const IconFont(
              IconFont.iconXzHD,
            ),
            title: Text(I18nKeys.createHdIdentityWallet),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.MNEMONIC_CREATE,
                parameters: {
                  "chainName": widget.chainName,
                  "createType": WalletCreateType.hdCreate.typeName
                },
              );
            },
          ),
          SizedBox(height: 15.h),
          _buildFuncItem(
            icon: const IconFont(IconFont.iconDrHD),
            title: Text(I18nKeys.importHdIdentityWallet),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.WALLET_IMPORT, parameters: {
                "createType": WalletCreateType.hdImport.typeName,
              });
            },
          ),
          SizedBox(height: 15.h),
          _buildFuncItem(
            icon: const IconFont(IconFont.iconXzqianbao),
            title: Text(I18nKeys.createSignleWallet),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.MNEMONIC_CREATE, parameters: {
                "chainName": widget.chainName,
                "createType": WalletCreateType.singleCreate.typeName
              });
            },
          ),
          SizedBox(height: 15.h),
          _buildFuncItem(
            icon: const IconFont(IconFont.iconDrqianbao),
            title: Text(I18nKeys.importSingleWallet),
            onTap: () => setState(() => _isImportMode = true),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildImportMode() {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 14.sp,
        color: const Color(0xFF333333),
        fontWeight: FontWeight.bold,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _fixCount = 0;
                    _isFixMode = false;
                    _isImportMode = false;
                  });
                },
                child: const Icon(Icons.arrow_back),
              ),
              const Expanded(child: SizedBox.shrink()),
              InkWell(
                onTap: () {
                  _fixCount++;
                  if (_fixCount >= 3) {
                    setState(() {
                      _isFixMode = true;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 32, right: 32, top: 12, bottom: 12),
                  child: Text(I18nKeys.pleaseSelectTheImportMethod,
                      style: TextStyle(fontSize: 13.sp)),
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
              const SizedBox(width: 24),
            ],
          ),
          const SizedBox(height: 25),
          _buildFuncItem(
            icon: const IconFont(IconFont.iconZhujici),
            title: Text(I18nKeys.backupMnemonics),
            subtitle: Text(I18nKeys.mnemonicWordsNotes),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.WALLET_IMPORT, parameters: {
                "importType": WalletImportType.menmonic.typeName,
                "chainName": widget.chainName
              });
            },
          ),
          _isFixMode ? SizedBox(height: 15.h) : SizedBox(height: 0.h),
          _isFixMode
              ? _buildFuncItem(
                  icon: const IconFont(IconFont.iconZhujici),
                  title: Text(I18nKeys.importFixTitle,
                    style: const TextStyle(
                      color: Color(0x88FF0000),
                    ),
                  ),
                  warnMode: true,
                  subtitle: Text(I18nKeys.importFixDesc),
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.WALLET_IMPORT, parameters: {
                      "importType": WalletImportType.menmonic.typeName,
                      "chainName": widget.chainName,
                      "fixMode": 'fixMode'
                    });
                  },
                )
              : Container(),
          SizedBox(height: 15.h),
          _buildFuncItem(
            icon: const IconFont(IconFont.iconSiyao),
            title: Text(I18nKeys.privateKey),
            subtitle: Text(I18nKeys.importWalletByEnteringPlaintextPrivateKey),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.WALLET_IMPORT, parameters: {
                "importType": WalletImportType.privatyKey.typeName,
                "chainName": widget.chainName
              });
            },
          ),
          SizedBox(height: 15.h),
          _buildFuncItem(
            icon: const IconFont(IconFont.iconKeystore),
            title: const Text('Keystore'),
            subtitle: Text(
              I18nKeys.addWalletByEnteringKeystoreFile,
              maxLines: 2,
            ),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.WALLET_IMPORT, parameters: {
                "importType": WalletImportType.keyStore.typeName,
                "chainName": widget.chainName
              });
            },
          ),
          SizedBox(height: 96.h),
        ],
      ),
    );
  }

  Widget _buildFuncItem({
    required Widget icon,
    required Widget title,
    Widget? subtitle,
    bool warnMode = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Colors.black.withOpacity(0.03),
        ),
        child: Row(
          children: [
            Container(
                width: 50.w,
                height: 50.w,
                padding: EdgeInsets.all(10.w),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'packages/flutter_wallet_assets/assets/images/property/ov_white.png'),
                  ),
                ),
                child: icon),
            SizedBox(width: 15.w),
            subtitle == null
                ? Expanded(child: title)
                : Expanded(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
                      const SizedBox(height: 5),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: warnMode
                              ? const Color(0x88FF0000)
                              : const Color(0xFF666666),
                        ),
                        child: subtitle,
                      )
                    ],
                  )),
            subtitle == null
                ? const SizedBox(
                    width: 10,
                  )
                : const SizedBox(),
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'packages/flutter_wallet_assets/assets/images/property/ov_white.png'),
                ),
              ),
              child: Icon(
                Icons.arrow_forward_outlined,
                size: 17,
                color: warnMode
                    ? const Color(0x88FF0000)
                    : const Color(0x88CCCCCC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
