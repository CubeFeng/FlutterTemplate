import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';


class PassWordInputTips extends StatefulWidget {
  const PassWordInputTips({
    Key? key,
    required this.inputString,
    required this.conform,
  }) : super(key: key);

  final String inputString;
  final ValueChanged<bool> conform;

  @override
  _PassWordInputTipsState createState() => _PassWordInputTipsState();
}

class _PassWordInputTipsState extends State<PassWordInputTips> {

  bool _containNum = false;//包含数字
  bool _containUppercase = false;//包含大写字母
  bool _containLowercase = false;
  bool _lengthConform = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18nKeys.please_use,
            style: TextStyle(fontSize: 13, color: Colours.secondary_text),
          ),
          Gaps.vGap5,
          PassWordInputTipsItem(
            typeString: I18nKeys.at_least_one_capital_letter,
            isHave: getPassWordTips(type: 0),
          ),
          PassWordInputTipsItem(
            typeString: I18nKeys.at_least_one_lower_case_letter,
            isHave: getPassWordTips(type: 1),
          ),
          PassWordInputTipsItem(
            typeString: I18nKeys.at_least_one_digit,
            isHave: getPassWordTips(type: 2),
          ),
          PassWordInputTipsItem(
            typeString: I18nKeys.e_t_characters,
            isHave: getPassWordTips(type: 3),
          ),
        ],
      ),
    );
  }

  bool getPassWordTips({required int type}) {
    if (type == 0) {
      //至少1个大写字母
      _containUppercase = widget.inputString.contains(RegExp(r'[A-Z]'));
      conformCheck();
      return _containUppercase;
    } else if (type == 1) {
      //至少1个小写字母
      _containLowercase = widget.inputString.contains(RegExp(r'[a-z]'));
      conformCheck();
      return _containLowercase;
    } else if (type == 2) {
      //至少1个数字
      _containNum = widget.inputString.contains(RegExp(r'[0-9]'));
      conformCheck();
      return _containNum;
    } else if (type == 3) {
      //8-12个字
      _lengthConform = widget.inputString.length >= 8 && widget.inputString.length <= 12;
      conformCheck();
      return _lengthConform;
    }

    return true;
  }

  void conformCheck(){

    bool conform = _containLowercase && _containNum && _containUppercase && _lengthConform;
    widget.conform(conform);
  }

}

class PassWordInputTipsItem extends StatelessWidget {
  const PassWordInputTipsItem({
    Key? key,
    required this.typeString,
    required this.isHave,
  }) : super(key: key);
  final String typeString; //哪种类型
  final bool isHave; //是否是true

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          if (isHave)
            LoadAssetImage(
              'common/icon_input_right',
              width: 12,
              height: 12,
            )
          else
            Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.only(left: 4, right: 4),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(2)), color: Colours.tertiary_text),
            ),
          Gaps.hGap8,
          Text(
            typeString,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: isHave ? Colours.text_tips_green : Colours.secondary_text,
              fontSize: 12,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
