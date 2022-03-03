import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

///
class TransactionNftResultView extends StatelessWidget {
  const TransactionNftResultView({Key? key}) : super(key: key);

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
            SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: WalletLoadImage(Get.parameters['image']!))),
            Gaps.vGap15,
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Get.parameters['tokenName']!,
                    style: TextStyle(
                      color: const Color(0xFF333333),
                      fontSize: 21.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Gaps.hGap5,
                  // Container(
                  //   height: 16.h,
                  //   padding: const EdgeInsets.only(left: 6, right: 6),
                  //   decoration: BoxDecoration(
                  //       color: const Color(0xFF2750EB).withOpacity(0.1),
                  //       borderRadius: BorderRadius.circular(11)),
                  //   child: Center(
                  //     child: Text(
                  //       "#" + Get.parameters['tokenId']!,
                  //       style: TextStyle(
                  //           color: const Color(0xFF2750EB).withOpacity(0.5),
                  //           fontSize: 11,
                  //           fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
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
                style: TextStyle(
                    color: const Color(0xFF999999),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Gaps.vGap10,
            Text(
              I18nKeys.committed,
              style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold),
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
                  child: Text(I18nKeys.backHome,
                      style: TextStyle(fontSize: 15.sp)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
