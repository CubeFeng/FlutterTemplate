
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextInputFormatter extends TextInputFormatter {
  MyTextInputFormatter({this.maxLength = 1000});

  /// 允许输入的最大值
  final int maxLength;

  /// 汉字，日文，韩文长度2，其它长度1
  bool _verifyMaxLimit(String value) {
    int length = 0;
    for (int i = 0; i < value.length; i++) {
      if (value.codeUnitAt(i) > 122) {
        ///没有输入上的表情符号也占有长度  codeUnit8205
        if (value.codeUnitAt(i) != 8205) {
          length = length + 2;
        }
      } else {
        length = length + 1;
      }
    }

    if (length <= maxLength) {
      return true;
    }

    return false;
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final String value = newValue.text;

    if (_verifyMaxLimit(value)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
