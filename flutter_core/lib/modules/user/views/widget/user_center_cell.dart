// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';

class UserCenterCell extends StatelessWidget {
  final VoidCallback? onTap;
  final String iconPath;
  final String title;

  const UserCenterCell({
    this.onTap,
    required this.iconPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      color: Colors.white,
      child: ListTile(
          onTap: onTap,
          minLeadingWidth: 6,
          leading: LoadAssetImage(iconPath),
          title: Text(title, style: TextStyle(fontSize: 15, color: Colours.text)),
          trailing: LoadAssetImage("common/icon_arrow_right")),
    );
  }
}

class MyBindingCell extends StatelessWidget {
  final VoidCallback? onTap;
  final String iconPath;
  final String title;
  final String actionTitle;
  final bool enable;

  const MyBindingCell({
    this.onTap,
    required this.iconPath,
    required this.title,
    required this.actionTitle,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enable ? onTap : null,
      child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 61,
                child: Row(
                  children: [
                    LoadAssetImage(
                      iconPath,
                      width: 22,
                      height: 22,
                    ),
                    Gaps.hGap8,
                    Text(title, style: TextStyle(fontSize: 15, color: Colours.text)),
                    Expanded(child: SizedBox()),
                    Text(
                      actionTitle,
                      style: TextStyle(
                          fontSize: 12, color: enable ? Colours.brand : Colours.tertiary_text),
                    ),
                    LoadAssetImage("common/icon_arrow_right")
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Colours.divider,
              )
            ],
          )),
    );
  }
}
