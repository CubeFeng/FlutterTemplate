part of 'uni_modals.dart';

/// 验证安全密码
class _VerifySecurityPasswordModal extends StatefulWidget {
  final Widget title;
  final Function(String) onConfirm;
  final VoidCallback? onCancel;
  final Widget? confirm;
  final Widget? cancel;
  final String? initialText;
  final String? hintText;

  const _VerifySecurityPasswordModal({
    Key? key,
    required this.title,
    required this.onConfirm,
    this.confirm,
    this.cancel,
    this.onCancel,
    this.initialText,
    this.hintText,
  }) : super(key: key);

  @override
  _VerifySecurityPasswordModalState createState() =>
      _VerifySecurityPasswordModalState();
}

class _VerifySecurityPasswordModalState
    extends State<_VerifySecurityPasswordModal> with WidgetsBindingObserver {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
    WidgetsBinding.instance?.addObserver(this);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      focusNode.requestFocus();
      setState(() {
        controller.text = widget.initialText ?? '';
      });
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
  var _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(bottom: Get.safetyBottomBarHeight),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.r),
            topRight: Radius.circular(15.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultTextStyle(
                    style: TextStyle(
                      color: const Color(0xFF333333),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    child: widget.title,
                  ),
                  IconButton(
                    onPressed: () => widget.onCancel ?? Get.back(),
                    icon: const Icon(
                      Icons.clear,
                      color: Color(0xFF999999),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        obscureText: _obscureText,
                        cursorColor: const Color(0xFF2750EB),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF333333),
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.hintText,
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFFCCCCCC),
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _obscureText = !_obscureText),
                      child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFFCCCCCC),
                        size: 18,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),
            GestureDetector(
              onTap: () => UniModals.showSingleActionPromptModal(
                icon: WalletLoadAssetImage('property/icon_lock_big', width: 80.w, height: 65.h,),
                title: Text(I18nKeys.whatIfIForgotMyPassword),
                message: Text(I18nKeys.walletPwdSecNotes),
                action: Text(I18nKeys.ok),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${I18nKeys.forgotPwd}？',
                    style: TextStyle(
                      color: const Color(0xFF333333),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50.h,
                  width: 165.w,
                  child: UniButton(
                    style: UniButtonStyle.PrimaryLight,
                    onPressed: widget.onCancel ?? () => Get.back(),
                    child: widget.cancel ?? Text(I18nKeys.cancel),
                  ),
                ),
                SizedBox(width: 15.w),
                SizedBox(
                  height: 50.h,
                  width: 165.w,
                  child: UniButton(
                    style: UniButtonStyle.Primary,
                    onPressed: controller.text.length<6
                        ? null
                        : () => widget.onConfirm(controller.text),
                    child: widget.confirm ?? Text(I18nKeys.confirm),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.h),
          ],
        ),
      ),
    );
  }
}
