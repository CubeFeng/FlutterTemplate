part of 'uni_modals.dart';

/// 单一动作提示
class _GeneralBaseActionPromptModal extends StatelessWidget {
  final Widget? image;
  final VoidCallback? onCancel;
  final double? height;
  final double? width;
  final String? actionTitle;
  final Widget message;
  final VoidCallback onConfirm;

  const _GeneralBaseActionPromptModal({
    Key? key,
    this.height,
    this.width,
    this.image,
    this.onCancel,
    this.actionTitle,
    required this.message,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: width ?? 260.w,
        height: height ?? 278.w,
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
                  padding: EdgeInsets.only(top: 14.w, right: 19.w),
                  child: const Icon(Icons.clear, color: Color(0xFF333333)),
                ),
                onTap: onCancel ?? () => Get.back(),
              ),
            ),
            SizedBox(height: 14.w),
            image ??
                SizedBox(width: 80.w, height: 65.w, child: const Placeholder()),
            SizedBox(height: 15.w),
            DefaultTextStyle(
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                  ),
                  child: message,
                )),
            const Expanded(child: SizedBox.shrink()),
            UniButton(
              style: UniButtonStyle.Primary,
              onPressed: onConfirm,
              child: Text(actionTitle ?? I18nKeys.toSetting),
            ),
            SizedBox(height: 30.w),
          ],
        ),
      ),
    );
  }
}
