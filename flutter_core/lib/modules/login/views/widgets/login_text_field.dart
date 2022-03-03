// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/theme/gaps.dart';

/// 登录模块的输入框封装
class LoginTextField extends StatefulWidget {
  const LoginTextField({
    Key? key,
    required this.controller,
    this.maxLength = 16,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.labelText = '',
    this.hintText = '',
    this.focusNode,
    this.isInputPwd = false,
    this.keyName,
  }) : super(key: key);

  final TextEditingController controller;
  final int maxLength;
  final bool autoFocus;
  final TextInputType keyboardType;
  final String hintText;
  final String labelText;
  final FocusNode? focusNode;
  final bool isInputPwd;

  /// 用于集成测试寻找widget
  final String? keyName;

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  /// 清除按钮是否显示
  final _clearButtonEnable = false.obs;

  /// 密码小眼睛
  final _pwdVisible = false.obs;

  @override
  void initState() {
    /// 监听输入改变
    widget.controller.addListener(isEmpty);
    widget.focusNode?.addListener(isEmpty);
    _pwdVisible.value = widget.isInputPwd;
    super.initState();
  }

  void isEmpty() {
    final bool isNotEmpty = widget.controller.text.isNotEmpty;
    _clearButtonEnable.value = isNotEmpty && widget.focusNode?.hasFocus == true;
  }

  @override
  void dispose() {
    widget.controller.removeListener(isEmpty);
    widget.focusNode?.removeListener(isEmpty);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    Widget clearButton = Semantics(
      label: I18nKeys.clear,
      hint: I18nKeys.clear_input_box,
      child: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Icon(
            Icons.cancel,
            color: Colors.grey,
            size: 18.sp,
          ),
        ),
        onTap: () => widget.controller.text = '',
      ),
    );

    late Widget pwdVisible;
    if (widget.isInputPwd) {
      pwdVisible = Semantics(
        label: I18nKeys.password_visible_switch,
        hint: I18nKeys.is_the_password_visible,
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Obx(() {
              return Icon(
                _pwdVisible.value ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
                size: 18.sp,
              );
            }),
          ),
          onTap: () => _pwdVisible.value = !_pwdVisible.value,
        ),
      );
    }

    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Obx(() {
          return TextField(
            focusNode: widget.focusNode,
            maxLength: widget.maxLength,
            obscureText: _pwdVisible.value,
            autofocus: widget.autoFocus,
            controller: widget.controller,
            textInputAction: TextInputAction.done,
            keyboardType: widget.keyboardType,
            // 数字、手机号限制格式为0到9， 密码限制不包含汉字
            inputFormatters: (widget.keyboardType == TextInputType.number ||
                    widget.keyboardType == TextInputType.phone)
                ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
                : [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))],
            decoration: InputDecoration(
              // contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              hintText: widget.hintText,
              labelText: widget.labelText,
              labelStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              counterText: '',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: themeData.primaryColor,
                  width: 0.8,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).dividerTheme.color!,
                  width: 0.8,
                ),
              ),
            ),
          );
          // if (DeviceUtils.isAndroid) {
          //   return Listener(
          //     onPointerDown: (e) => FocusScope.of(context).requestFocus(widget.focusNode),
          //     child: textField,
          //   );
          // }
          // return textField;
        }),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Obx(() {
              return Visibility(
                  visible: _clearButtonEnable.value, child: clearButton);
            }),
            if (widget.isInputPwd) Gaps.hGap15,
            if (widget.isInputPwd) pwdVisible,
          ],
        )
      ],
    );
  }
}
