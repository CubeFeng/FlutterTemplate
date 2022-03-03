part of 'uni_modals.dart';

/// 单一文本输入
class _SingleTextFieldModal extends StatefulWidget {
  final Widget title;
  final Function(String) onConfirm;
  final VoidCallback? onCancel;
  final Widget? confirm;
  final Widget? cancel;
  final String? initialText;
  final String? hintText;
  final bool? obscureText;

  const _SingleTextFieldModal({
    Key? key,
    required this.title,
    required this.onConfirm,
    this.confirm,
    this.cancel,
    this.onCancel,
    this.initialText,
    this.hintText,
    this.obscureText,
  }) : super(key: key);

  @override
  _SingleTextFieldModalState createState() => _SingleTextFieldModalState();
}

class _SingleTextFieldModalState extends State<_SingleTextFieldModal>
    with WidgetsBindingObserver {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _controller.addListener(() => setState(() {}));
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      setState(() {
        _controller.text = widget.initialText ?? '';
      });
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

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
                  GestureDetector(
                    onTap: () => widget.onCancel ?? Get.back(),
                    child: const Padding(
                      padding: EdgeInsets.all(7.5),
                      child: Icon(
                        Icons.clear,
                        color: Color(0xFF999999),
                      ),
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
                        controller: _controller,
                        focusNode: _focusNode,
                        maxLength: 20,
                        obscureText: widget.obscureText ?? false,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF333333),
                        ),
                        decoration: InputDecoration(
                            counter: const SizedBox.shrink(),
                            border: InputBorder.none,
                            hintText: widget.hintText,
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFFCCCCCC),
                            )),
                      ),
                    ),
                    _controller.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () => setState(() => _controller.text = ''),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.clear,
                                size: 14,
                                color: Color(0xFFCCCCCC),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25.h),
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
                    onPressed: _controller.text.isEmpty
                        ? null
                        : () => widget.onConfirm(_controller.text),
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
