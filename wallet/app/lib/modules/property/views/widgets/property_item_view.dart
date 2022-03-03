import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/services/local_service.dart';

class PropertyItemView extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final String coinName;
  final String coinAddress;
  final String coinAmount;
  final double? coinAmountCurrency;
  final bool selected;
  final bool show;
  final double margin;

  const PropertyItemView({
    Key? key,
    required this.icon,
    required this.onTap,
    required this.coinName,
    required this.coinAddress,
    required this.coinAmount,
    this.coinAmountCurrency,
    this.selected = false,
    this.margin = 15.0,
    this.show = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: selected
            ? BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              )
            : const BoxDecoration(),
        child: Container(
          margin: EdgeInsets.all(margin),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 43.w, height: 43.h, child: icon),
              SizedBox(width: 11.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coinName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      coinAddress,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF999999),
                      ),
                    )
                  ],
                ),
              ),
              coinAmountCurrency == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          !show?'******':coinAmount,
                          style: TextStyle(
                            fontFamily: 'DIN',
                            fontSize: 16.sp,
                            color: const Color(0xFF333333),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          !show?'******':coinAmount,
                          style: TextStyle(
                            fontFamily: 'Din',
                            fontSize: 17.sp,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          !show?'******':LocalService.to.currencySymbol +
                              coinAmountCurrency!.toStringAsFixed(2),
                          style: TextStyle(
                            fontFamily: 'DIN',
                            fontSize: 12.sp,
                            color: const Color(0xFF999999),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
