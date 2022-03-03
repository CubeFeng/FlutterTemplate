part of 'uni_modals.dart';

/// 单一动作提示
class _SingleActionPromptModal extends StatelessWidget {
  final Widget icon;
  final Widget title;
  final Widget message;
  final Widget action;
  final UniButtonStyle actionStyle;
  final bool? showCloseIcon;
  final VoidCallback? onAction;
  final bool? cancelable;
  final double? width;

  const _SingleActionPromptModal({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    required this.action,
    required this.actionStyle,
    this.showCloseIcon,
    this.onAction,
    this.width,
    this.cancelable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: cancelable == true ? null : () async => false,
      child: Align(
        alignment: const Alignment(0, 0.1),
        child: Container(
          width: width ?? 268.w,
          // height: 376.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30.r)),
          ),
          child: Stack(
            children: [
              showCloseIcon == true
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Icon(
                            Icons.clear,
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30),
                    SizedBox(width: 112.w, height: 89.h, child: icon),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DefaultTextStyle(
                          style: TextStyle(
                            color: const Color(0xFF333333),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                          child: title),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: const Color(0xFF666666),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.start,
                        child: message,
                      ),
                    ),
                    const SizedBox(height: 25),
                    // const Expanded(child: SizedBox.shrink()),
                    SizedBox(
                      height: 40.h,
                      child: UniButton(
                        style: actionStyle,
                        onPressed: onAction ?? () => Get.back(),
                        child: action,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
