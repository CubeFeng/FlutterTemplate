import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/models/wallet_importtype_model.dart';
import 'package:flutter_wallet/modules/wallet/create/controllers/wallet_create_controller.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet/widgets/uni_coin_create_progress.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

///
class WalletCreateView extends GetView<WalletCreateController> {
  const WalletCreateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletCreateController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          // appBar: const QiAppBar(
          //   leading: Text(""),
          //   title: Text(''),
          //   // title: controller.importType != WalletImportType.hdCreat
          //   //     ? Text('导入${QiRpcService().coinType.chainName()}钱包')
          //   //     : const Text('创建钱包'),
          // ),
          body: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
            child: Column(
              children: [
                const SizedBox(height: 45),
                _buildTopViewWidget(controller.chainName, controller.textTitle,
                    controller.createType == WalletCreateType.singleImport),
                const SizedBox(height: 25),
                const SizedBox(
                  height: 180,
                  width: 285,
                  child: WalletLoadAssetImage(
                    "wallet/icon_wallet_creat",
                    format: ImageFormat.gif,
                  ),
                ),

                SizedBox(height: 20.sp),
                Obx(
                  () => Text(controller.subTitle.value),
                ),
                SizedBox(height: 20.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: controller.itemList.map((itemModel) {
                    return _buildGridItemView(itemModel);
                  }).toList(),
                ),
                // const Expanded(child: SizedBox()),
                SizedBox(height: 100.sp),
                controller.complete
                    ? SizedBox(
                        width: 140,
                        height: 40,
                        child: UniButton(
                          style: UniButtonStyle.Primary,
                          onPressed: controller.doneAction,
                          child: Text(I18nKeys.finish),
                        ),
                      )
                    : const Text(""),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopViewWidget(
      String chainName, String title, bool singleImport) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        margin: EdgeInsets.only(top: 15.h),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: singleImport
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: WalletLoadAssetImage(
                        "property/icon_coin_${chainName.toLowerCase()}", fit: BoxFit.fitHeight),
                  ),
                  SizedBox(width: 5.sp),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              )
            : Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ));
  }

  Widget _buildGridItemView(WalletItemModel model) {
    if (model.status == '0') {
      return SizedBox(
        width: 58,
        height: 58,
        child: Center(
          child: UniCoinCreateProgress(
            radius: 40.r,
            padding: 8.r,
            child: WalletLoadAssetImage(model.iconPath, fit: BoxFit.fitHeight),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 58,
        height: 58,
        child: Center(
          child: SizedBox(
            height: 48,
            width: 48,
            child: Stack(
              children: [
                Align(
                  child: SizedBox(
                    width: 32.r,
                    height: 32.r,
                    child: WalletLoadAssetImage(model.status == "1"
                        ? model.iconPath
                        : "${model.iconPath}_gray", fit: BoxFit.fitHeight,),
                  ),
                ),
                Positioned(
                  right: 0.r,
                  bottom: 5.r,
                  child: SizedBox(
                    width: 10.r,
                    height: 10.r,
                    child: WalletLoadAssetImage(
                      model.status == "1"
                          ? "common/icon_success"
                          : "common/icon_failure",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
