import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_list.dart';
import 'package:flutter_wallet/modules/wallet/create/controllers/mnemonic_controller.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/qi_mnemonic_chip.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';

///
class MnemonicVerifyView extends GetView<MnemonicController> {
  const MnemonicVerifyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.shuffleMnemonicList();
    return Scaffold(
      appBar: QiAppBar(
        title: Text(I18nKeys.verificationMnemonics),
        elevation: 0.2,
      ),
      body: GetBuilder<MnemonicController>(
        id: MnemonicController.VERIFY_VIEW_ID,
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 10, left: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${I18nKeys.makeSureYouHaveBackedUpYourMnemonicsPleaseVerifyTheFollowingQuestions}:",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF999999),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: const Color(0xFF000000).withOpacity(0.08), blurRadius: 2.w)],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular((15.r)),
                  ),
                  child: Column(
                    children: [
                      Gaps.vGap15,
                      ...controller.verifyTopThreePositionList.mapIndexed((index, position) => Padding(
                            padding: EdgeInsets.only(
                              left: 16.w,
                              right: 16.w,
                              bottom: 15.h,
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text(I18nRawKeys.pleaseSelectTheWord.trPlaceholder(['$position']))),
                                Obx(
                                  () {
                                    final mnemonic = controller.selectedMnemonicList.getOr(index, '');
                                    return QiMnemonicChip(
                                      text: mnemonic,
                                      onTap: () {
                                        controller.setVerifyIndex(index);
                                        if (mnemonic != '') {
                                          controller.unsetMnemonic(index);
                                        }
                                      },
                                      style: index == controller.verifyIndex
                                          ? QiMnemonicChipStyle.Selected
                                          : QiMnemonicChipStyle.UnSelected,
                                    );
                                  },
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              Wrap(
                spacing: 11.0, // 主轴(水平)方向间距
                runSpacing: 6.0, // 纵轴（垂直）方向间距
                alignment: WrapAlignment.center, //沿主轴方向居中
                children: controller.verifyMnemonicList.map((word) {
                  return QiMnemonicChip(
                    text: word,
                    masked: controller.selectedMnemonicList.contains(word),
                    onTap: controller.selectedMnemonicList.contains(word)
                        ? null
                        : () => controller.setMnemonic(controller.verifyIndex, word),
                  );
                }).toList(),
              ),
              const Expanded(child: SizedBox.shrink()),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 16, bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 80.w,
                      height: 43.h,
                      child: UniButton(
                        style: UniButtonStyle.Primary,
                        onPressed: controller.canComplete ? () => controller.completeVerify() : null,
                        child: const Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
