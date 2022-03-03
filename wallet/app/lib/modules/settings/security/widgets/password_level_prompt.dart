import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';

// ignore: constant_identifier_names
enum PasswordLevel { Low, Medium, High }

class PasswordLevelPrompt extends StatelessWidget {
  final PasswordLevel level;

  const PasswordLevelPrompt({Key? key, required this.level}) : super(key: key);

  Widget _buildRateBox({required Color color}) {
    return Container(
      width: 39.w,
      height: 12.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> rateBoxs;
    final String rateText;
    switch (level) {
      case PasswordLevel.Low:
        rateBoxs = [
          _buildRateBox(color: const Color(0xFFF14F4F)),
          SizedBox(width: 5.w),
          _buildRateBox(color: const Color(0xFFCCCCCC)),
          SizedBox(width: 5.w),
          _buildRateBox(color: const Color(0xFFCCCCCC)),
        ];
        rateText = I18nKeys.low;
        break;
      case PasswordLevel.Medium:
        rateBoxs = [
          _buildRateBox(color: const Color(0xFFF3B22E)),
          SizedBox(width: 5.w),
          _buildRateBox(color: const Color(0xFFF3B22E)),
          SizedBox(width: 5.w),
          _buildRateBox(color: const Color(0xFFCCCCCC)),
        ];
        rateText = I18nKeys.middle;
        break;
      case PasswordLevel.High:
        rateBoxs = [
          _buildRateBox(color: const Color(0xFF42C53E)),
          SizedBox(width: 5.w),
          _buildRateBox(color: const Color(0xFF42C53E)),
          SizedBox(width: 5.w),
          _buildRateBox(color: const Color(0xFF42C53E)),
        ];
        rateText = I18nKeys.strong;
        break;
    }
    return Row(
      children: [
        ...rateBoxs,
        SizedBox(width: 10.w),
        Text(
          rateText,
          style: TextStyle(
            color: const Color(0xFF666666),
            fontSize: 11.sp,
          ),
        )
      ],
    );
  }
}
