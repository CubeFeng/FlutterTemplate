import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/models/user/oauth_app_info_model.dart';
import 'package:flutter_ucore/theme/colors.dart';

class MyAuthorizationCell extends StatelessWidget {
  final OauthAppInfoModel model;
  final VoidCallback? onPressed;

  const MyAuthorizationCell({required this.model, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.primary_bg,
      alignment: Alignment.center,
      // padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      child: ListTile(
        leading: Container(
          height: 48,
          width: 48,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.blue, //test
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: LoadImage(model.appHeader ?? ''),
        ),
        title: Text(
          model.appName ?? '',
          style: TextStyle(fontSize: 16, color: Colours.primary_text),
        ),
        subtitle: Text(
          model.lastModifiedAt ?? '',
          style: TextStyle(fontSize: 12, color: Colours.tertiary_text),
        ),
        // trailing: SizedBox(
        //     width: 58.sp,
        //     height: 30.sp,
        //     child: UCoreButton.outline(
        //       onPressed: onPressed,
        //       text: I18nKeys.open,
        //     )),
      ),
    );
  }
}
