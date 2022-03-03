import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';

class RegisterMode extends StatelessWidget {
  final VoidCallback? onMail;
  final VoidCallback? onFace;

  const RegisterMode({this.onMail, this.onFace});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Container(
            height: 64,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              I18nKeys.registration_method,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colours.text),
            ),
          ),
          Container(height: 0.5, color: Colours.line),
          Gaps.vGap13,
          InkWell(
            onTap: onMail,
            highlightColor: Colours.bg_gray,
            splashColor: Colors.transparent,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 30, right: 10),
              child: Row(
                children: [
                  LoadAssetImage('login/icon_register_mail'),
                  Gaps.hGap5,
                  Text(
                    I18nKeys.email_captcha_registration,
                    style: TextStyle(fontSize: 14, color: Colours.secondary_text),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: onFace,
            highlightColor: Colours.bg_gray,
            splashColor: Colors.transparent,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 30, right: 10),
              child: Row(
                children: [
                  LoadAssetImage('login/icon_register_face'),
                  Gaps.hGap5,
                  Text(
                    I18nKeys.face_id_registration,
                    style: TextStyle(fontSize: 14, color: Colours.secondary_text),
                  )
                ],
              ),
            ),
          ),
          Gaps.vGap13,
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 48,
                alignment: Alignment.center,
                color: Colours.brand.withOpacity(0.25),
                child: Text(
                  I18nKeys.cancel,
                  style: TextStyle(fontSize: 14, color: Colours.brand),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
