import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/models/wallet_importtype_model.dart';
import 'package:flutter_wallet/modules/wallet/import/controllers/wallet_import_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/utils/app_utils.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/qi_mnemonic_chip.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

///
class WalletImportView extends GetView<WalletImportController> {
  const WalletImportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletImportController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: QiAppBar(
            title: Text(controller.titleStr),
            action: GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(
                    right: 18.sp, top: 10.sp, bottom: 10.sp, left: 18.sp),
                child: const WalletLoadAssetImage('common/scan_qrcode'),
              ),
              onTap: () async {
                AppUtils.hideKeyboard();
                // 扫码
                final result = await Get.toNamed(Routes.SCAN_CODE);
                controller.inputController.text = result;
              },
            ),
          ),
          body: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                  12.w, 25.w, 12.w, Get.safetyBottomBarHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        controller.importType == WalletImportType.menmonic
                            ? _mnemonicWordView(controller)
                            : const SizedBox.shrink(),
                        controller.importType == WalletImportType.privatyKey
                            ? _privateKeyView(controller)
                            : const SizedBox.shrink(),
                        controller.importType == WalletImportType.keyStore
                            ? _keyStoreView(controller)
                            : const SizedBox.shrink(),
                        const Expanded(child: SizedBox(height: 50)),
                      ],
                    ),
                  ),
                  _bottomView(controller),

                  // Obx(
                  //         () => controller.showBottomWidgetStatus.value?_BottomView(controller):const Text("")
                  // ),

                  const SizedBox(height: 20)
                ],
              )),
        );
      },
    );
  }
}

///私钥导入
Widget _privateKeyView(WalletImportController controller) {
  print("buidle _privateKeyView");
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _topTitleWidget(I18nRawKeys.pleaseEnterThePrivateKeyAddressOfWallet
          .trPlaceholder([controller.chainName])),
      SizedBox(
        height: 15.h,
      ),
      TextField(
        maxLines: 5,
        //文字大小、颜色
        style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
            fontWeight: FontWeight.w500),

        decoration: _inputDecoration(I18nKeys.pleaseEnterThePrivateKey),
        controller: controller.inputController,
        // keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.done,
        cursorColor: const Color(0xFF2750EB),
      ),
    ],
  );
}

///助记词导入
Widget _mnemonicWordView(WalletImportController controller) {
  print("buidle _mnemonicWordView");
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _topTitleWidget(
          I18nRawKeys.pleaseEnterAMnemonicOfEnglishWords.trPlaceholder(['12'])),
      SizedBox(
        height: 15.h,
      ),
      TextField(
          maxLines: 5,
          //文字大小、颜色
          style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w500),
          decoration: _inputDecoration(I18nRawKeys
              .pleaseEnterMnemonicWordsSeparatedBySpaces
              .trPlaceholder(['12'])),
          controller: controller.inputController,
          // keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          cursorColor: const Color(0xFF2750EB),
          focusNode: controller.inputFocusNode,
          onChanged: (text) {
            controller.findWordsList();
          }),
      SizedBox(
        height: 15.h,
      ),
      Wrap(
        spacing: 11.0, // 主轴(水平)方向间距
        runSpacing: 6.0, // 纵轴（垂直）方向间距
        alignment: WrapAlignment.start, //沿主轴方向居中
        children: controller.searchWordList.mapIndexed((index, word) {
          return QiMnemonicChip(
            text: word,
            onTap: () {
              controller.selectedWordAction(index);
            },
          );
        }).toList(),
      ),
    ],
  );
}

///keystore导入
Widget _keyStoreView(WalletImportController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _topTitleWidget(I18nRawKeys.pleaseEnterTheKeystoreFileContentOfWallet
          .trPlaceholder([controller.chainName])),
      const SizedBox(
        height: 10,
      ),
      TextField(
        maxLines: 5,
        //文字大小、颜色
        style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
            fontWeight: FontWeight.w500),

        decoration: _inputDecoration("keyStore${I18nKeys.fileContent}"),
        controller: controller.inputController,
        // keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.done,
        cursorColor: const Color(0xFF2750EB),
        focusNode: controller.inputFocusNode,
      ),
      const SizedBox(
        height: 25,
      ),
      Text(I18nKeys.pleaseEnterTheKeystorePassword,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black87)),
      const SizedBox(
          height: 10,
      ),
      Obx(() => TextField(
        //文字大小、颜色
        style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
        decoration: InputDecoration(
          hintText: I18nKeys.pwd,
          border: _outlineInputBorder,
          focusedBorder: _outlineInputBorder,
          enabledBorder: _outlineInputBorder,
          fillColor: const Color(0xFFF8F8F8),
          //背景颜色，必须结合filled: true,才有效
          filled: true,
          suffixIcon: GestureDetector(
            onTap: controller.eyeAction,
            child: Icon(
              controller.obscureText.value
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: const Color(0xFFCCCCCC),
              size: 18,
            ),
          ),
        ),
        controller: controller.passwordController,
        keyboardType: TextInputType.multiline,
        obscureText: controller.obscureText.value,
        cursorColor: const Color(0xFF2750EB),
        focusNode: controller.passwordFocusNode,
      )
      ),
    ],
  );
}

Widget _bottomView(WalletImportController controller) {
  print("buidle _BottomView");
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Obx(
        () => GestureDetector(
          onTap: controller.clickAgremmentButton,
          child: WalletLoadAssetImage(
            controller.agreementBtnStatus.value
                ? "common/icon_gouxuan"
                : "common/icon_weigouxuan",
            height: 30,
            width: 30,
          ),
        ),
      ),
      // SizedBox(width: 5,),
      Expanded(
        child: Text.rich(
            TextSpan(children: [
              TextSpan(
                text: I18nKeys.iHaveReadAndAgree,
                style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
              TextSpan(
                  text: "《${I18nKeys.serviceAndPrivacyTerms}》",
                  style:
                      const TextStyle(color: Color(0xFF2750EB), fontSize: 12),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.toNamed(Routes.DAPPS_Web_BANNER, parameters: {
                        'url': LocalService.to.servicePrivacyPolicy
                      });
                    }),
            ]),
            maxLines: 2),
      ),

      // const Expanded(child: SizedBox()),

      Obx(
        () => SizedBox(
          width: 80.w,
          height: 43.h,
          child: UniButton(
              onPressed: controller.nextBtnStatus.value
                  ? controller.creatWalletAction
                  : null,
              child: const Icon(Icons.keyboard_arrow_right),
              style: UniButtonStyle.Primary),
        ),
      )
    ],
  );
}

Widget _topTitleWidget(String title) {
  return Text(title,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF999999)));
}

InputDecoration _inputDecoration(text) {
  return InputDecoration(
    hintText: text,
    border: _outlineInputBorder,
    focusedBorder: _outlineInputBorder,
    enabledBorder: _outlineInputBorder,
    fillColor: const Color(0xFFF8F8F8),
    //背景颜色，必须结合filled: true,才有效
    filled: true,
  );
}

OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
  gapPadding: 0,
  borderSide: const BorderSide(
    color: Color(0xFFF8F8F8),
    width: 1,
  ),
  borderRadius: BorderRadius.circular(10),
);
