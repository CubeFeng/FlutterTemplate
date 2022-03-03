import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/models/wallet_importtype_model.dart';
import 'package:flutter_wallet/modules/settings/controllers/my_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/security_service.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

class MyView extends GetView<MyController> {
  MyView({Key? key}) : super(key: key);

  final _controller = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) {
        return Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: 222.h,
                child: Stack(
                  children: [
                    WalletLoadAssetImage('my/top_bar_bg',
                        width: 1.sw, fit: BoxFit.fitWidth),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.h,
                          vertical: 11.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              I18nKeys.mySettings,
                              style: const TextStyle(
                                fontSize: 21,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: _controller.goMessageListPage,
                              child: Stack(
                                children: [
                                  const Positioned(
                                      child:
                                          WalletLoadAssetImage('my/ic_bell')),
                                  Obx(() => _controller.unreadMessage.value
                                      ? Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 6.w),
                                            width: 6,
                                            height: 6,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFFFD6E61),
                                            ),
                                          ))
                                      : const SizedBox()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.h,
                      left: 0.h,
                      right: 0.h,
                      child: _buildMiddleCardContent(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                margin: EdgeInsets.all(15.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3.h),
                      color: const Color(0xFF000000).withOpacity(0.08),
                      blurRadius: 5.w,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _RightArrowCell(
                      icon: const WalletLoadAssetImage('my/ic_connect'),
                      title: Text(I18nKeys.connectWallet),
                      onTap: () => Get.toNamed(Routes.Dapp_Wallet_Connect_History),
                    ),
                    Container(
                        height: 0.5, color: Colors.black.withOpacity(0.08)),
                    _RightArrowCell(
                      icon: const WalletLoadAssetImage('my/ic_security'),
                      title: Text(I18nKeys.securityCenter),
                      onTap: () => _checkHasSecurityPassword(
                            () => Get.toNamed(Routes.SETTINGS_SECURITY),
                      ),
                    ),
                    Container(
                        height: 0.5, color: Colors.black.withOpacity(0.08)),
                    _RightArrowCell(
                      icon: const WalletLoadAssetImage('my/ic_settings'),
                      title: Text(I18nKeys.sysSetting),
                      onTap: () => Get.toNamed(Routes.SETTINGS_OPTIONS),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3.h),
                      color: const Color(0xFF000000).withOpacity(0.08),
                      blurRadius: 5.h,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _RightArrowCell(
                      icon: const WalletLoadAssetImage('my/ic_about'),
                      title: Text(I18nKeys.aboutUs),
                      onTap: () => Get.toNamed(Routes.SETTINGS_ABOUT),
                    ),
                    Container(
                        height: 0.5, color: Colors.black.withOpacity(0.08)),
                    _RightArrowCell(
                      icon: const WalletLoadAssetImage('my/ic_share'),
                      title: Text(I18nKeys.myShareInvitation),
                      onTap: () => Get.toNamed(Routes.SETTINGS_SHARE),
                      // onTap: () => Toast.show(I18nKeys.theFunctionIsNotOpenYet),

                      // onTap:() => Get.toNamed(Routes.WALLET_IMPORT, parameters: {
                      //   "importType": WalletImportType.menmonic.typeName,
                      //   "chainName": "ETH"
                      // }),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _checkHasSecurityPassword(VoidCallback then) {
    if (!SecurityService.to.hasSecurityPassword) {
      // 设置密码
      UniModals.showNotSetPasswordPromptModal(onConfirm: () {
        Get.back();
        Get.toNamed(Routes.SECURITY_SETUP_PASSWORD);
      });
    } else {
      then();
    }
  }

  Widget _buildMiddleCardContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3.w),
            color: const Color(0xFF000000).withOpacity(0.08),
            blurRadius: 5.w,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Get.toNamed(Routes.WALLET_MANAGE),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const WalletLoadAssetImage('my/ic_wallet_mgr'),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          I18nKeys.managemer,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 0.6,
                height: 60,
                margin: const EdgeInsets.only(right: 10.0),
                color: Colors.black.withOpacity(0.08),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => Get.toNamed(Routes.SETTINGS_ADDRESS),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const WalletLoadAssetImage('my/ic_address_mgr'),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(I18nKeys.addressManagemer, maxLines: 2))
                    ],
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

class _RightArrowCell extends StatelessWidget {
  final Widget icon;
  final Widget title;
  final VoidCallback? onTap;

  const _RightArrowCell({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 17.h),
        child: Row(
          children: [
            SizedBox(width: 19.r, height: 19.r, child: icon),
            SizedBox(width: 10.h),
            DefaultTextStyle(
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              child: title,
            ),
            const Expanded(child: SizedBox.shrink()),
            const Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Color(0xFFCCCCCC),
            )
          ],
        ),
      ),
    );
  }
}
