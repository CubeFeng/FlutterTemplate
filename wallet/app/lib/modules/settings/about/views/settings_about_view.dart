import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/home/controllers/home_controller.dart';
import 'package:flutter_wallet/modules/settings/controllers/my_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/u_circle_dot.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

class SettingsAboutView extends StatelessWidget {
  SettingsAboutView({Key? key}) : super(key: key);

  final _myController = Get.find<MyController>();
  final _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QiAppBar(title: Text(I18nKeys.aboutUs)),
      body: Column(
        children: [
          SizedBox(height: 40.h),
          const SizedBox(
              width: 112,
              height: 89,
              child: WalletLoadImage("settings/about_wallet")),
          SizedBox(height: 10.h),
          Text(
            'AITD Wallet',
            style: TextStyle(
              fontSize: 18.sp,
              color: const Color(0xFF333333),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            _myController.appVersion,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF999999),
            ),
          ),
          SizedBox(height: 30.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildItem(
                  title: Text(I18nKeys.myVersionUpdate),
                  subtitle: _homeController.needUpdateVersion
                      ? Expanded(
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            UCircleDot(
                                size: 6.r,
                                color:const Color(0xFFEB4C4C).withOpacity(0.8)),
                            const SizedBox(width: 5,),
                            Text("V${_homeController.appInfoModel.versionNo!}"),
                          ],
                        ))
                      : Text(I18nKeys.myVersionLatest),
                  onTap: () {
                    if (_homeController.needUpdateVersion) {
                      Get.find<HomeController>().checkUpdate(forceShow: true);
                    }
                  },
                ),
                const Divider(height: 1, color: Color(0xFFF5F5F5)),
                // _buildItem(title: Text(I18nKeys.serviceClause)),
                // const Divider(height: 1, color: Color(0xFFF5F5F5)),
                _buildItem(
                    title: Text(I18nKeys.serviceClause),
                    onTap: () {
                      Get.toNamed(Routes.DAPPS_Web_BANNER, parameters: {
                        "url": LocalService.to.servicePrivacyPolicy
                      });
                    }),
                const Divider(height: 1, color: Color(0xFFF5F5F5)),
                _buildItem(
                    title: Text(I18nKeys.website),
                    subtitle: const Text('www.aitd.io'),
                    onTap: () {
                      Get.toNamed(Routes.DAPPS_Web_BANNER,
                          parameters: {"url": "https://www.aitd.io"});
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required Widget title,
    Widget? subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
        child: Row(
          children: [
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF333333),
                fontWeight: FontWeight.bold,
              ),
              child: title,
            ),
            const Expanded(child: SizedBox.shrink()),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF999999),
              ),
              child: subtitle ?? const SizedBox.shrink(),
            ),
            SizedBox(width: 5.w),
            Icon(
              Icons.arrow_forward_ios,
              size: 12.sp,
              color: const Color(0xFFCCCCCC),
            )
          ],
        ),
      ),
    );
  }
}
