import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

class UCoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? action;
  final List<Widget>? actions;
  final Widget? title;
  final double? elevation;
  final PreferredSizeWidget? bottom;

  Size get preferredSize => Size.fromHeight(53.0);

  const UCoreAppBar({Key? key, this.leading, this.action, this.actions, this.title, this.elevation = 0.5, this.bottom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? DefaultTextStyle(
              style: Get.theme.textTheme.headline6!.copyWith(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: title!,
            )
          : title,
      actions: actions == null ? (action == null ? null : [action!]) : actions,
      bottom: bottom,
      leading: leading == null
          ? Navigator.canPop(context)
              ? IconButton(
                  onPressed: () => Get.back(),
                  icon: LoadAssetImage(
                    "common/icon_arrow_left",
                    color: Get.isDarkMode ? Colors.white : null,
                  ),
                )
              : null
          : leading,
      elevation: elevation,
    );
  }
}
