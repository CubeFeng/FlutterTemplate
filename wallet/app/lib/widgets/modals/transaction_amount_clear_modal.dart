part of 'uni_modals.dart';

/// 未设置密码提示
class _AmountClearModal extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const _AmountClearModal({
    Key? key,
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 333.w,
        height: 376.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 32.h),
            WalletLoadAssetImage(
              'property/icon_warn_big',
              width: 80.w,
              height: 65.h,
            ),
            SizedBox(height: 20.h),
            DefaultTextStyle(
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
                child: Text(I18nKeys.turnOut)),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.only(left: 32.w, right: 32.w),
              child: DefaultTextStyle(
                  style: TextStyle(
                    color: const Color(0xFF666666),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                  child: Text(I18nKeys.miningLaborFeeNotes)),
            ),
            const Expanded(child: SizedBox.shrink()),
            SizedBox(
              height: 40.h,
              child: UniButton(
                style: UniButtonStyle.PrimaryLight,
                onPressed: onConfirm,
                child: Text(I18nKeys.iKnow),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
