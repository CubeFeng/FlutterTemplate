import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/generated/icon_font.g.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

class NoWalletView extends StatelessWidget {
  final VoidCallback onTapCreateWallet;

  const NoWalletView({
    Key? key,
    required this.onTapCreateWallet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 165.w, left: 15.w, right: 15.w),
      child: Column(
        children: [
          WalletLoadAssetImage('property/img_wallet_empty', width: 251.w, height: 151.w,),
          SizedBox(height: 16.h),
          Text(
            I18nKeys.decentralizedMultiChainWallet,
            textAlign: TextAlign.center,
            style: TextStyle(color: const Color(0xFF333333), fontSize: 23.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 17.h),
          Text(
            I18nKeys.aSetOfMnemonicsManagesAllAssets,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF999999),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 60.h),
          SizedBox(
            height: 40.h,
            child: UniButton(
              style: UniButtonStyle.Primary,
              onPressed: onTapCreateWallet,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Text(I18nKeys.addWallet),
              ),
            ),
          )
        ],
      ),
    );
  }
}
