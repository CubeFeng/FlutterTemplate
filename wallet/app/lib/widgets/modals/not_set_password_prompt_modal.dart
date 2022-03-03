part of 'uni_modals.dart';

/// 未设置密码提示
class _NotSetPasswordPromptModal extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const _NotSetPasswordPromptModal({
    Key? key,
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 260.w,
        height: 256.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(top: 14.h, right: 19.w),
                  child: const Icon(Icons.clear, color: Color(0xFF333333)),
                ),
                onTap: onCancel ?? () => Get.back(),
              ),
            ),
            SizedBox(height: 14.h),
            WalletLoadAssetImage('property/icon_lock_big', width: 80.w, height: 65.h,),
            SizedBox(height: 15.h),
            DefaultTextStyle(
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
                child: Text(I18nKeys.dontSetWalletPwd, textAlign: TextAlign.center,)),
            const Expanded(child: SizedBox.shrink()),
            SizedBox(
              height: 40.h,
              child: UniButton(
                style: UniButtonStyle.Primary,
                onPressed: onConfirm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8),
                  child: Text(I18nKeys.toSetting),
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
