import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: constant_identifier_names
enum QiMnemonicChipStyle { Selected, UnSelected, Normal }

/// 助记词
class QiMnemonicChip extends StatelessWidget {
  /// 助记词
  final String text;

  /// 顺序号
  final int? serial;

  /// 点击
  final VoidCallback? onTap;

  /// 掩藏
  final bool? masked;

  /// 样式
  final QiMnemonicChipStyle style;

  /// 宽度
  final double width;

  /// 高度
  final double height;

  const QiMnemonicChip({
    Key? key,
    required this.text,
    this.serial,
    this.onTap,
    this.masked,
    this.style = QiMnemonicChipStyle.Normal,
    this.width = 108,
    this.height = 44,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color _chipColor;
    switch (style) {
      case QiMnemonicChipStyle.Selected:
        _chipColor = const Color(0xFF2750EB).withOpacity(0.1);
        break;
      case QiMnemonicChipStyle.UnSelected:
        _chipColor = const Color(0xFFF8F8F8);
        break;
      case QiMnemonicChipStyle.Normal:
        _chipColor = const Color(0xFF2750EB).withOpacity(0.05);
        break;
    }
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.all(Radius.circular(6.r)),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: _chipColor,
              borderRadius: BorderRadius.all(Radius.circular(6.r)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Visibility(
              visible: masked != true,
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(color: const Color(0xFF161A27), fontSize: 17.sp),
                ),
              ),
            ),
          ),
        ),
        serial == null
            ? const SizedBox.shrink()
            : Positioned(
                top: 3,
                right: 6,
                child: Text(
                  serial.toString(),
                  style: TextStyle(color: const Color(0x5A161A27), fontSize: 10.sp),
                ),
              )
      ],
    );
  }
}
