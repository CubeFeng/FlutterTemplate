part of 'uni_modals.dart';

/// 验证安全密码
class SolanaInputModal extends StatefulWidget {
  final Widget title;
  final Function(String, String) onConfirm;
  final VoidCallback? onCancel;
  final Widget? confirm;
  final Widget? cancel;
  final String? initialText;
  final bool? showSecond;

  const SolanaInputModal({
    Key? key,
    required this.title,
    required this.onConfirm,
    this.confirm,
    this.cancel,
    this.onCancel,
    this.initialText,
    this.showSecond = false,
  }) : super(key: key);

  @override
  _SolanaInputModalState createState() => _SolanaInputModalState();
}

class _SolanaInputModalState extends State<SolanaInputModal>
    with WidgetsBindingObserver {
  final controller = TextEditingController();
  final controller2 = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
    controller2.addListener(() => setState(() {}));
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
                        cursorColor: const Color(0xFF2750EB),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF333333),
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '请输入合约地址',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFFCCCCCC),
                            )),
                      ),
                    ),
                    controller.text == ''
                        ? Container()
                        : GestureDetector(
                            onTap: () => setState(() => controller.text = ''),
                            child: const Icon(
                              Icons.close,
                              color: Color(0xFFCCCCCC),
                              size: 18,
                            ),
                          )
                  ],
                ),
              ),
            ),
            widget.showSecond == true
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
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
                              controller: controller2,
                              cursorColor: const Color(0xFF2750EB),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF333333),
                              ),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '请输入代币地址',
                                  hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color(0xFFCCCCCC),
                                  )),
                            ),
                          ),
                          controller2.text == ''
                              ? Container()
                              : GestureDetector(
                                  onTap: () =>
                                      setState(() => controller2.text = ''),
                                  child: const Icon(
                                    Icons.close,
                                    color: Color(0xFFCCCCCC),
                                    size: 18,
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                : Container(),
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
                    onPressed: controller.text.length < 6
                        ? null
                        : () => widget.onConfirm(controller.text, controller2.text),
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
