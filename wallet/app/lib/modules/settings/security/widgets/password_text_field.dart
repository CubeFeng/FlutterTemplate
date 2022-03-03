import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordTextField extends StatelessWidget {
  final Widget label;
  final Widget? floatingLabel;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const PasswordTextField({
    Key? key,
    required this.label,
    this.floatingLabel,
    this.controller,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3.w),
            color: const Color(0xFF000000).withOpacity(0.08),
            blurRadius: 5.w,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15.w),
        child: _InternalTextField(
          label: label,
          floatingLabel: floatingLabel ?? label,
          controller: controller ?? TextEditingController(),
          focusNode: focusNode ?? FocusNode(),
        ),
      ),
    );
  }
}

class _InternalTextField extends StatefulWidget {
  final Widget label;
  final Widget floatingLabel;
  final TextEditingController controller;
  final FocusNode focusNode;

  const _InternalTextField({
    Key? key,
    required this.label,
    required this.floatingLabel,
    required this.controller,
    required this.focusNode,
  }) : super(key: key);

  @override
  _InternalTextFieldState createState() => _InternalTextFieldState();
}

class _InternalTextFieldState extends State<_InternalTextField> {
  var _obscureText = true;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      cursorColor: const Color(0xFF2750EB),
      decoration: InputDecoration(
        label: widget.focusNode.hasFocus || widget.controller.text.isNotEmpty ? widget.floatingLabel : widget.label,
        floatingLabelStyle: const TextStyle(color: Color(0xFF666666)),
        labelStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
        border: InputBorder.none,
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _obscureText = !_obscureText),
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFFCCCCCC),
            size: 18,
          ),
        ),
      ),
    );
  }
}
