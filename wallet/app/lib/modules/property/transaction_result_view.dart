import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

///
class TransactionResultView extends StatelessWidget {
  const TransactionResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Column(
          children: [
            const SizedBox(
              height: 86,
            ),
            const WalletLoadAssetImage(
              'property/icon_transaction_out',
              width: 50,
              height: 50,
            ),
            Gaps.vGap15,
            Text(
              I18nKeys.transferTo,
              style: TextStyle(
                color: const Color(0xFF999999),
                fontSize: 13.sp,
              ),
            ),
            Gaps.vGap5,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 68),
              child: Text(
                Get.parameters['address']!,
                textAlign: TextAlign.center,
                style: TextStyle(color: const Color(0xFF999999), fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ),
            Gaps.vGap20,
            Text(
              Get.parameters['amount']!,
              style: TextStyle(color: const Color(0xFF333333), fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            Gaps.vGap5,
            Text(
              Get.parameters['amountCurrency']!,
              style: TextStyle(color: const Color(0xFF999999), fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
            Gaps.vGap10,
            Text(
              I18nKeys.committed,
              style: TextStyle(color: const Color(0xFF333333), fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 100,
            ),
            Center(
              child: SizedBox(
                height: 40.h,
                child: UniButton(
                  style: UniButtonStyle.PrimaryLight,
                  onPressed: () {
                    Get.until((route) => Get.currentRoute == Routes.HOME);
                  },
                  child: Text(I18nKeys.backHome, style: TextStyle(fontSize: 15.sp)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
