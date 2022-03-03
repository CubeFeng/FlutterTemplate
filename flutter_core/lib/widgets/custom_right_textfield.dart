import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomRightTextField extends StatefulWidget {
  const CustomRightTextField({
    Key? key,
    required this.controller,
    this.title,
    this.keyboardType = TextInputType.text,
    this.hintText,
    required this.focusNode,
    this.textAlign = TextAlign.right,
    this.max = 10000000000000000000,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String? title;
  final String? hintText; //占位文字
  final TextInputType keyboardType;
  final FocusNode focusNode;
  final TextAlign textAlign;
  final double max;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  @override
  _CustomRightTextFieldState createState() => _CustomRightTextFieldState();
}

class _CustomRightTextFieldState extends State<CustomRightTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: TextField(
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      obscureText: widget.obscureText,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      cursorColor: Colours.brand,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: Colours.primary_text,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colours.primary_bg,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colours.text_gray_c,
          fontSize: 14,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      textAlign: widget.textAlign,
      focusNode: widget.focusNode,
    ));
  }
}
