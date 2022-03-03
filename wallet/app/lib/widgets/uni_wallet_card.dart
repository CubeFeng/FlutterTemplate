import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

/// 应用内钱包卡片
class UniWalletCard extends StatelessWidget {
  final Widget name;
  final Widget balance;
  final String address;
  final String shadowIcon;
  final bool? hdWallet;
  final bool? selected;
  final List<Color> colors;
  final Widget? menuButton;

  const UniWalletCard({
    Key? key,
    required this.name,
    required this.balance,
    required this.address,
    this.hdWallet,
    this.colors = const [Color(0xFFFF9546), Color(0xFFF5812A)],
    this.shadowIcon = 'property/shadow_aitd',
    this.selected,
    this.menuButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(13.r),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3.w),
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 5.w,
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: WalletLoadAssetImage(
                  shadowIcon,
                  width: 88.w,
                  height: 88.h,
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(15),
            child: selected == true && menuButton == null
                ? Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.check_circle,
                      color: colors[1],
                      size: 15,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          menuButton != null
              ? Align(
                  alignment: Alignment.topRight,
                  child: menuButton!,
                )
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 216),
                          child: name),
                      SizedBox(width: 1.w),
                      hdWallet == true
                          ? const _HdBadge()
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: address));
                    Get.showTopBanner(I18nKeys.copySuc);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 7.5, bottom: 2),
                    width: 188,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                          child: Text(address.safeText),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.copy,
                          color: Colors.white.withOpacity(0.6),
                          size: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 7.5),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Row(
                    children: [
                      Text('${I18nKeys.balance}: '),
                      DefaultTextStyle(
                        style: const TextStyle(fontSize: 17),
                        child: balance,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _HdBadge extends StatelessWidget {
  const _HdBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.r),
        border: Border.all(
          style: BorderStyle.solid,
          color: Colors.white,
          width: 0.8,
        ),
      ),
      child: Text(
        'HD',
        style: TextStyle(fontSize: 8.sp),
      ),
    );
  }
}

extension _AddressExt on String {
  String get safeText {
    if (length >= 25) {
      final first = substring(0, 13);
      final last = substring(length - 8);
      return first + '...' + last;
    } else {
      return this;
    }
  }
}
