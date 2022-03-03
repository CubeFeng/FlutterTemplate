import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/icon_font.g.dart';

class QiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? action;
  final List<Widget>? actions;
  final Widget? title;
  final bool? centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight((45.h + 0.5).ceilToDouble());

  const QiAppBar({
    Key? key,
    this.leading,
    this.action,
    this.actions,
    this.title,
    this.centerTitle,
    this.elevation,
    this.backgroundColor,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      centerTitle: centerTitle ?? false,
      title: title != null
          ? DefaultTextStyle(
              style: Get.theme.textTheme.headline6!.copyWith(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: title!,
            )
          : title,
      actions: actions ?? (action == null ? null : [action!]),
      leading: leading ??
          (Navigator.canPop(context)
              ? IconButton(
                  onPressed: () => Get.back(),
                  icon: const IconFont(
                    IconFont.iconFanhui,
                    size: 16,
                    color: '#333333',
                  ),
                )
              : null),
      elevation: elevation,
      titleSpacing: 0,
      bottom: bottom,
    );
  }
}
