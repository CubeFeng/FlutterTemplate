import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/widgets/load_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

import 'package:flutter/services.dart';

///价格输入框和数量输入框的限制
class PrecisionLimitFormatter extends TextInputFormatter {
  final int _scale;

  PrecisionLimitFormatter(this._scale);

  RegExp exp = RegExp("[0-9.]");
  static const String POINTER = ".";
  static const String DOUBLE_ZERO = "00";

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    ///输入完全删除
    if (newValue.text.isEmpty) {
      return TextEditingValue();
    }

    ///只允许输入小数
    if (!exp.hasMatch(newValue.text.substring(newValue.text.length - 1))) {
      return oldValue;
    }

    ///包含小数点的情况
    if (newValue.text.contains(POINTER)) {
      ///包含多个小数
      if (newValue.text.indexOf(POINTER) !=
          newValue.text.lastIndexOf(POINTER)) {
        return oldValue;
      }
      String input = newValue.text;
      int index = input.indexOf(POINTER);

      ///小数点后位数
      int lengthAfterPointer = input.substring(index, input.length).length - 1;

      ///小数位大于精度
      if (lengthAfterPointer > _scale) {
        return oldValue;
      }
    } else if (newValue.text.startsWith(POINTER) ||
        newValue.text.startsWith(DOUBLE_ZERO)) {
      ///不包含小数点,不能以“00”开头
      return oldValue;
    }
    return newValue;
  }
}

class EditTextField extends StatelessWidget {
  final String labelText;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? style;
  final int? line;
  final TextInputFormatter? inputFormatter;

  const EditTextField({
    Key? key,
    required this.labelText,
    this.controller,
    this.focusNode,
    this.style,
    this.inputFormatter,
    this.line,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _InternalTextField(
      label: labelText,
      controller: controller,
      focusNode: focusNode,
      style: style,
      inputFormatter: inputFormatter,
      line: line,
    );
  }
}

class _InternalTextField extends StatefulWidget {
  final String label;
  final int? line;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? style;
  final TextInputFormatter? inputFormatter;

  const _InternalTextField({
    Key? key,
    required this.label,
    this.controller,
    this.focusNode,
    this.style,
    this.inputFormatter,
    this.line,
  }) : super(key: key);

  @override
  _InternalTextFieldState createState() => _InternalTextFieldState();
}

class _InternalTextFieldState extends State<_InternalTextField> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    widget.controller!.addListener(() {
      if (visible) {
        if (widget.controller!.text == '') {
          setState(() => visible = false);
        }
      } else {
        if (widget.controller!.text != '') {
          setState(() => visible = true);
        }
      }
    });
    return TextField(
      style: widget.style,
      controller: widget.controller,
      maxLines: widget.line ?? 1,
      focusNode: widget.focusNode,
      inputFormatters:
          widget.inputFormatter == null ? [] : [widget.inputFormatter!],
      //只允许输入数字
      obscureText: false,
      decoration: visible
          ? InputDecoration(
              contentPadding: const EdgeInsets.only(top: 5),
              isCollapsed: true,
              hintText: widget.label,
              hintStyle:
                  const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
              border: InputBorder.none,
              suffixIcon: GestureDetector(
                onTap: () => setState(() => widget.controller!.text = ''),
                child: WalletLoadAssetImage(
                  'property/icon_delete',
                  width: 14.r,
                  height: 14.r,
                ),
              ),
              suffixIconConstraints: const BoxConstraints(
                maxHeight: 14,
              ),
            )
          : InputDecoration(
              contentPadding: const EdgeInsets.only(top: 5),
              isCollapsed: true,
              hintText: widget.label,
              hintStyle:
                  const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
              border: InputBorder.none,
            ),
    );
  }
}
