part of 'uni_modals.dart';

/// 未设置密码提示
class _ImportModal extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const _ImportModal({
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
        height: LocalService.to.languageCode == 'jp' ? 438.h : 388.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 34.h),
            WalletLoadAssetImage(
              'property/icon_lock_big',
              width: 80.w,
              height: 65.h,
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: DefaultTextStyle(
                  style: TextStyle(
                    color: const Color(0xFF333333),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                  child: Text(
                    I18nKeys.databaseUpdateTip,
                    textAlign: TextAlign.center,
                  )),
            ),
            const Expanded(child: SizedBox.shrink()),
            SizedBox(
              height: 40.h,
              width: 188.w,
              child: UniButton(
                style: UniButtonStyle.Primary,
                onPressed: onConfirm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    I18nKeys.importRightNow,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 40.h,
              width: 188.w,
              child: UniButton(
                style: UniButtonStyle.Danger,
                onPressed: onCancel,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    I18nKeys.clearData,
                    textAlign: TextAlign.center,
                  ),
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
