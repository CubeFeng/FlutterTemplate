import 'package:flutter/material.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';

class LogoutMode extends StatelessWidget {
  final VoidCallback? onSure;
  final VoidCallback? onCancel;

  const LogoutMode({this.onSure, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Container(
            height: 54,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 24, left: 25),
            child: Text(
              I18nKeys.logout_Tips,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colours.text),
            ),
          ),
          Container(
            height: 70,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Text(
              I18nKeys.sure_logout,
              style: TextStyle(fontSize: 14, color: Colours.secondary_text),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            // mainAxisSize: MainAxisSize.max,
            children: [
              UCoreButton.outline(
                minHeight: 44,
                minWidth: 130,
                onPressed: onCancel,
                text: I18nKeys.cancel,
              ),
              UCoreButton(
                minHeight: 44,
                minWidth: 130,
                onPressed: onSure,
                text: I18nKeys.confirm,
              ),
            ],
          )
        ],
      ),
    );
  }
}
