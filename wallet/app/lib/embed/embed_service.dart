import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/embed/embed_channels.dart';
import 'package:flutter_wallet/embed/embed_helper.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/property/controllers/property_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/security_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/widgets/modals/switch_wallet_modal.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';

class EmbedService extends GetxService {
  static EmbedService get to => Get.find();

  /// 尝试转发嵌入式路由
  bool tryEmbedForward() {
    final route = EmbedHelper.getForwardParameter('route');
    switch (route) {
      case Routes.HOME:
        _forwardHomePage(route: route);
        break;
      case Routes.DAPPS_BROWSER:
        final chain = EmbedHelper.getForwardParameter('chain') as String;
        final url = EmbedHelper.getForwardParameter('url') as String;
        _forwardDAppBrowserPage(route: route, chain: chain, url: url);
        break;
      default:
        break;
    }
    return true;
  }

  /// 路由到首页
  Future<void> _forwardHomePage({required String route}) async {
    // 嵌入式启动的第一个界面就是`HomePage`，所以不需要再跳转页面了
    EmbedChannels.bridge.onFlutterEngineReady();
  }

  /// 路由到DApp页面
  Future<void> _forwardDAppBrowserPage({
    required String route,
    required String chain,
    required String url,
  }) async {
    /// 执行
    Future<void> didExecute() async {
      //region 判断是否设置安全密码
      if (!SecurityService.to.hasSecurityPassword) {
        // 设置密码
        UniModals.showNotSetPasswordPromptModal(
          barrierDismissible: false,
          onCancel: () => SystemNavigator.pop(),
          onBackPress: () async {
            await SystemNavigator.pop();
            return true;
          },
          onConfirm: () async {
            Get.back();
            await Get.toNamed(Routes.SECURITY_SETUP_PASSWORD);
            didExecute();
          },
        );
        return;
      }
      //endregion

      //region 判断是否有创建钱包
      if (WalletService.to.currentCoin == null) {
        // 还没添加过钱包，弹窗提示
        UniModals.showGeneralSingleActionPromptModal(
          barrierDismissible: false,
          message: Text(
            I18nRawKeys.dapp_addWallet_tip.trPlaceholder([chain]),
            textAlign: TextAlign.center,
          ),
          actionTitle: I18nKeys.addWallet,
          image: const WalletLoadAssetImage("user/icon_dapp_tip"),
          onCancel: () => SystemNavigator.pop(),
          onBackPress: () async {
            await SystemNavigator.pop();
            return true;
          },
          onConfirm: () async {
            Get.back();
            await Get.toNamed(Routes.WALLET_MANAGE);
            didExecute();
          },
        );
        return;
      }
      //endregion

      // region检查当前链
      await Get.find<PropertyController>()
          .onAddressSelect(WalletService.to.currentCoin!);
      if (QiRpcService().coinType.chainName() != chain) {
        // 切换链
        UniModals.showGeneralSingleActionPromptModal(
            barrierDismissible: false,
            message: Text(
              I18nRawKeys.dapp_switchWallet_tip.trPlaceholder([chain]),
              textAlign: TextAlign.center,
            ),
            actionTitle: I18nKeys.switchWallet,
            image: const WalletLoadAssetImage("user/icon_dapp_tip"),
            onCancel: () => SystemNavigator.pop(),
            onBackPress: () async {
              await SystemNavigator.pop();
              return true;
            },
            onConfirm: () async {
              Get.back();
              await Get.bottomSheet(
                SwitchWalletModal(
                  onSelectedWalletCallback: (coin) async {
                    await Get.find<PropertyController>().onAddressSelect(coin);
                    Get.back();
                  },
                ),
                isScrollControlled: true,
              );
              didExecute();
            });
        return;
      }
      //endregion

      // 跳转页面
      Get.toNamed(route, arguments: {'url': url, 'launchMode': 'embed'});
    }

    await didExecute();
    EmbedChannels.bridge.onFlutterEngineReady();
  }
}
