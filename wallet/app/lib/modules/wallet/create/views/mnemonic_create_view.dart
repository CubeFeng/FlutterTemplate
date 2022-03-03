import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/models/wallet_importtype_model.dart';
import 'package:flutter_wallet/modules/wallet/create/controllers/mnemonic_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/qi_mnemonic_chip.dart';
import 'package:flutter_wallet/widgets/u_circle_dot.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

///
class MnemonicCreateView extends GetView<MnemonicController> {
  const MnemonicCreateView({Key? key}) : super(key: key);

  Widget _buildPromptNotToScreenshot() {
    return Scaffold(
      appBar: QiAppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: WalletLoadAssetImage(
            'common/icon_close',
            color: Get.isDarkMode ? Colors.white : null,
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 112.h),
            WalletLoadAssetImage(
              'property/img_no_camera',
              width: 112.w,
              height: 89.h,
            ),
            SizedBox(height: 30.h),
            Text(
              I18nKeys.dontCapture,
              style: TextStyle(
                color: const Color(0xFF333333),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              I18nKeys.lossOfMnemonicsMeansLossOfProperty,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF666666),
                fontSize: 14.sp,
                height: 2,
              ),
            ),
            SizedBox(height: 114.h),
            SizedBox(
              height: 40.h,
              child: UniButton(
                style: UniButtonStyle.PrimaryLight,
                onPressed: () {
                  controller.isPromptNotToScreenshot.value = false;
                },
                child: Text(I18nKeys.iKnow),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBackupMnemonics(BuildContext context) {
    return Scaffold(
      appBar: QiAppBar(
        title: Text(I18nKeys.backUpAuxWord),
        elevation: 0.2,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 25, left: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  I18nKeys.auxiliaryWordsNextNotes,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF999999),
                  ),
                ),
              ),
            ),
            Wrap(
              spacing: 11.0, // 主轴(水平)方向间距
              runSpacing: 6.0, // 纵轴（垂直）方向间距
              alignment: WrapAlignment.center, //沿主轴方向居中
              children: controller.mnemonicList.mapIndexed((index, word) {
                return QiMnemonicChip(text: word, serial: index + 1);
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, right: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: controller.mnemonics));
                      Get.showTopBanner(I18nKeys.copySuc);
                    },
                    child: Text(
                      I18nKeys.copyAuxiliary,
                      style: const TextStyle(
                        color: Color(0xFF2750EB),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ),
            const Expanded(child: SizedBox.shrink()),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 16, bottom: 50),
              child: controller.createType == WalletCreateType.hdCreate?
              Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UCircleDot(
                        size: 4.r,
                        color: const Color(0xFF2750EB).withOpacity(0.8)),
                    SizedBox(width: 5.w),

                    Expanded(
                      child: GestureDetector(
                        onTap: () => UniModals.showSingleActionPromptModal(
                          icon: WalletLoadAssetImage(
                            'property/icon_hd_wallet',
                            width: 112.w,
                            height: 89.h,
                          ),
                          title: Text(I18nKeys.hdWallet),
                          message: Text(I18nKeys.hdWalletDesc),
                          action: Text(I18nKeys.ok),
                        ),
                        child: Text(
                          I18nKeys.wereAboutToCreateAnHdIdentityWalletForYou,
                          maxLines: 2,
                          style: TextStyle(
                            color: const Color(0xFF2750EB).withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                    // const Expanded(child: SizedBox.shrink()),
                    SizedBox(
                      width: 80.w,
                      height: 43.h,
                      child: UniButton(
                        style: UniButtonStyle.Primary,
                        onPressed: () =>
                            Get.toNamed(Routes.MNEMONIC_VERIFY, parameters: {
                              "createType": Get.parameters["createType"].toString()
                            }),
                        child: const Icon(Icons.keyboard_arrow_right),
                      ),
                    )
                  ],
                ): Row(
                    children: [
                      const Expanded(child: SizedBox.shrink()),
                      SizedBox(
                        width: 80.w,
                        height: 43.h,
                        child: UniButton(
                          style: UniButtonStyle.Primary,
                          onPressed: () =>
                              Get.toNamed(Routes.MNEMONIC_VERIFY, parameters: {
                                "createType": Get.parameters["createType"].toString()
                              }),
                          child: const Icon(Icons.keyboard_arrow_right),
                        ),
                      )
                    ],
                  )
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isPromptNotToScreenshot.value
          ? _buildPromptNotToScreenshot()
          : _buildBackupMnemonics(context);
    });
  }
}
