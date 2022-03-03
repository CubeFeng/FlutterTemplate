import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/dimens.dart';
import 'package:flutter_ucore/theme/gaps.dart';
// import 'package:flutter_ucore/utils/common_colors.dart';
import 'package:flutter_ucore/widgets/password_input_tips_widget.dart';

class AccountTextField extends StatefulWidget {
  const AccountTextField({
    Key? key,
    required this.controller,
    this.maxLength = 100,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.hintText = '',
    this.labelText = '',
    this.errorText = '',
    this.focusNode,
    this.isInputPwd = false,
    this.needCheckInput = false,
    this.showError = false,
    this.getVCode,
    this.rightBtn,
    this.leftWidget,
    this.keyName,
    // this.inputFormattersType = InputFormattersType.other,
    this.digit = 8,
    this.max = 10000000000000000000,
    this.itemBack,
    this.textFieldKey = '',
  }) : super(key: key);

  final TextEditingController controller;
  final int maxLength;
  final bool autoFocus;
  final TextInputType keyboardType;
  final String hintText; //占位
  final String labelText; //标签
  final String errorText; //错误提示
  final FocusNode? focusNode;
  final bool isInputPwd;
  final bool needCheckInput; //输入检查
  final bool showError; //显示错误提示

  final Widget? leftWidget;
  final Future<bool> Function()? getVCode;
  final Widget? rightBtn;
  // final InputFormattersType inputFormattersType;
  final int digit; //允许输入的小数位数， InputFormattersType 是 doubleNumber起作用
  final double max;

  final Function(String value)? itemBack;
  final String textFieldKey;

  /// 用于集成测试寻找widget
  final String? keyName;

  @override
  _AccountTextFieldState createState() => _AccountTextFieldState();
}

class _AccountTextFieldState extends State<AccountTextField> {
  bool _isShowPwd = false;
  bool _isShowDelete = false;
  bool _clickable = true;
  bool _isFocus = false;

  bool _isChecking = false;

  /// 倒计时秒数
  final int _second = 60;

  /// 当前秒数
  int _currentSecond = 0;
  StreamSubscription? _subscription;

  @override
  void initState() {
    /// 获取初始化值
    _isShowDelete = widget.controller.text.isEmpty;

    /// 监听输入改变
    widget.controller.addListener(isEmpty);

    widget.focusNode?.addListener(isFocus);

    super.initState();

    // @override
    // Widget build(BuildContext context) {
    //   return Container(

    //   );
    // }
  }

  void isFocus() {
    final bool isFocus;
    if (widget.focusNode == null) {
      isFocus = false;
    } else {
      isFocus = widget.focusNode!.hasFocus;
    }

    if (!isFocus) {
      _isChecking = false;
    }

    if (_isFocus != isFocus) {
      setState(() {
        _isFocus = isFocus;
      });
    }
  }

  void isEmpty() {
    final bool isEmpty = widget.controller.text.isEmpty;

    /// 状态不一样在刷新，避免重复不必要的setState
    if (isEmpty != _isShowDelete) {
      setState(() {
        _isShowDelete = isEmpty;
        _isChecking = widget.needCheckInput &&
            (_isChecking || widget.controller.text.length > 0);
      });
    } else {
      setState(() {
        _isChecking = widget.needCheckInput &&
            (_isChecking || widget.controller.text.length > 0);
      });
    }
  }

  Future _getVCode() async {
    if (widget.getVCode != null) {
      final bool isSuccess = await widget.getVCode!();
      if (isSuccess) {
        setState(() {
          _currentSecond = _second;
          _clickable = false;
        });
        _subscription =
            Stream.periodic(const Duration(seconds: 1), (int i) => i)
                .take(_second)
                .listen((int i) {
          setState(() {
            _currentSecond = _second - i - 1;
            _clickable = _currentSecond < 1;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    widget.controller.removeListener(isEmpty);
    widget.controller.removeListener(isFocus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool obscureText;
    if (widget.isInputPwd) {
      obscureText = !_isShowPwd;
    } else {
      obscureText = false;
    }

    final TextField textField = TextField(
      key: Key(widget.textFieldKey),
      style: TextStyle(
          fontSize: Dimens.font_sp15,
          fontWeight: FontWeight.bold,
          color: Colours.primary_text),
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      obscureText: obscureText,
      autofocus: widget.autoFocus,
      controller: widget.controller,
      cursorColor: Colours.brand,
      textInputAction: TextInputAction.done,
      keyboardType: widget.keyboardType,
      enableInteractiveSelection: true,
      inputFormatters: [
        FilteringTextInputFormatter(RegExp("[a-z0-9A-Z.@]"), allow: true)
      ],
      decoration: InputDecoration(
        prefixIcon: widget.leftWidget,
        prefixIconConstraints:
            const BoxConstraints(minWidth: 22, maxWidth: 52, minHeight: 25),
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
        hintText: widget.hintText,
        hintStyle: TextStyle(
            fontSize: Dimens.font_sp15,
            fontWeight: FontWeight.normal,
            color: Colours.tertiary_text),
        counterText: '',
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colours.brand,
            width: 0.5,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colours.tertiary_text,
            width: 0.5,
          ),
        ),
      ),
    );
    final Widget clear = Semantics(
      label: '清空',
      hint: '清空输入框',
      child: GestureDetector(
        child: LoadAssetImage(
          'user/icon_delect_all',
        ),
        onTap: () => widget.controller.text = '',
      ),
    );

    final Widget pwdVisible = Semantics(
      label: '密码可见开关',
      hint: '密码是否可见',
      child: GestureDetector(
        child: LoadAssetImage(
          _isShowPwd ? 'common/icon_eye_open' : 'common/icon_eye_close',
          key: Key('${widget.keyName}_showPwd'),
        ),
        onTap: () {
          setState(() {
            _isShowPwd = !_isShowPwd;
          });
        },
      ),
    );

    final Widget getVCodeButton = Theme(
        data: Theme.of(context).copyWith(
          buttonTheme: const ButtonThemeData(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 26.0,
            minWidth: 76.0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 16,
              width: 1,
              color: Colours.text_gray_c,
            ),
            Gaps.hGap1,
            TextButton(
              key: const Key('getVerificationCode'),
              onPressed: _clickable ? _getVCode : null,
              style: TextButton.styleFrom(
                  primary: _clickable ? Colours.brand : Colours.tertiary_text),
              child: Text(
                _clickable
                    ? I18nKeys.getting_captcha
                    : '$_currentSecond s', //todo，缺少国际化 x秒后重新发送
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(widget.labelText,
              style: TextStyle(
                  color: Colours.tertiary_text, fontSize: 12)), //todo 动画
        ),
        Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            textField,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (!_isShowDelete && _isFocus) clear else Gaps.empty,
                if (!widget.isInputPwd) Gaps.empty else Gaps.hGap15,
                if (!widget.isInputPwd) Gaps.empty else pwdVisible,
                if (widget.getVCode == null) Gaps.empty else Gaps.hGap15,
                if (widget.getVCode == null) Gaps.empty else getVCodeButton,
                if (widget.rightBtn == null) Gaps.empty else widget.rightBtn!,
              ],
            ),
          ],
        ),
        Gaps.vGap16,
        //错误提示
        Visibility(
          visible: widget.showError,
          child: Text(widget.errorText,
              style: TextStyle(color: Colours.text_red, fontSize: 12)), //,
        ),
        //输入检测提示
        Visibility(
          visible: _isChecking,
          child: PassWordInputTips(
            inputString: widget.controller.text,
            conform: (conform){

            },
          ), //,
        ),
      ],
    );
  }
}
