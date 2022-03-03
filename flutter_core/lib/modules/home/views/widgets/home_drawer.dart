import 'package:badges/badges.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/app_service.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:flutter_ucore/services/message_service.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Get.theme.scaffoldBackgroundColor,
        child: SafeArea(
          child: Scrollbar(
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: ClipPath(
                      clipper: TrianglePath(),
                      child: Container(
                        height: 276,
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0, 1),
                            end: Alignment(1, 0),
                            colors: [Color(0x33FFBD4B), Color(0x0DFFBD4B)],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildListView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView(
      physics: BouncingScrollPhysics().applyTo(AlwaysScrollableScrollPhysics()),
      children: [
        SizedBox(height: 24),
        Obx(() {
          final userModel = AuthService.to.userModel;
          return _MenuHeadItem(
            nickName: userModel?.nickname ?? I18nKeys.not_logged_in,
            avatar: userModel?.headImg ?? 'drawer/icon_user_header',
            onTap: () {
              Get.back();
              Get.toNamed(Routes.USER_CENTER);
            },
          );
        }),
        SizedBox(height: 15),
        // 站内信
        _MenuFuncItem(
          leading: LoadAssetImage(
            "drawer/icon_drawer_message",
            color: Get.isDarkMode ? Colors.white : null,
          ),
          title: Text(I18nKeys.station_letter),
          trailing: Obx(() {
            int unReadMessageCount = MessageService.service.unReadMessageCount;
            return Badge(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 2.5, bottom: 2.5),
              elevation: 0,
              showBadge: MessageService.service.unReadMessageCount > 0,
              shape: BadgeShape.square,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              badgeContent: Text(
                unReadMessageCount >= 99 ? '99+' : unReadMessageCount.toString(),
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            );
          }),
          onTap: () {
            Get.back();
            Get.toNamed(Routes.USER_MESSAGE);
          },
        ),
        // 帮助中心
        _MenuFuncItem(
          leading: LoadAssetImage(
            "drawer/icon_drawer_help",
            color: Get.isDarkMode ? Colors.white : null,
          ),
          title: Text(I18nKeys.help_center),
          onTap: () {
            Get.back();
            Get.toNamed(Routes.HELP_CENTER);
          },
        ),
        // 当前版本
        Obx(() {
          final appInfoModel = AppService.to.appInfoModel;
          return _MenuFuncItem(
            leading: LoadAssetImage(
              "drawer/icon_drawer_version",
              color: Get.isDarkMode ? Colors.white : null,
            ),
            title: Text(I18nRawKeys.current_version_.trPlaceholder([appInfoModel?.version ?? ""])),
            // trailing: UCoreRedDot(),
            onTap: () {
              if (DeviceUtils.isAndroid) {
                Get.back();
                AppService.service.checkVersion(showTips: true, showLoading: true);
              }
            },
          );
        }),
        // 多语言
        _MenuFuncItem(
          leading: LoadAssetImage(
            "drawer/icon_drawer_language",
            color: Get.isDarkMode ? Colors.white : null,
          ),
          title: Text(I18nKeys.multi_language),
          trailing: Text(
            LocalService.to.languageText,
            style: TextStyle(
              color: Get.isDarkMode ? Colours.dark_tertiary_text : Colours.tertiary_text,
              fontSize: 12,
            ),
          ),
          onTap: () {
            Get.back();
            Get.toNamed(Routes.SETTINGS_LANGUAGE);
          },
        ),
        // 外观设置

        // _MenuFuncItem(
        //   leading: LoadAssetImage(
        //     "drawer/icon_theme_color",
        //     color: Get.isDarkMode ? Colors.white : null,
        //   ),
        //   title: Text(I18nKeys.theme_settings),
        //   onTap: () {
        //     Get.back();
        //     Get.toNamed(Routes.SETTINGS_THEME);
        //   },
        // ),

        // 提建议
        _MenuFuncItem(
          leading: LoadAssetImage(
            "drawer/icon_drawer_advice",
            color: Get.isDarkMode ? Colors.white : null,
          ),
          title: Text(I18nKeys.suggest),
          onTap: () {
            Get.back();
            Get.toNamed(Routes.FEED_BACK);
          },
        ),
        SizedBox(height: 24),
        Obx(
          () => AuthService.to.isLoggedInValue
              ? Gaps.empty
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: UCoreButton(
                      onPressed: () {
                        Get.back();
                        Get.toNamed(Routes.USER_LOGIN, arguments: '1');
                      },
                      text: I18nKeys.register),
                ),
        )
      ],
    );
  }
}

class TrianglePath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, size.height / 2)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _MenuHeadItem extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String avatar;
  final String nickName;

  const _MenuHeadItem({Key? key, this.onTap, required this.avatar, required this.nickName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 17, right: 17, top: 12, bottom: 12),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                height: 42,
                width: 42,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(21.0),
                ),
                child: LoadImage(
                  avatar,
                  holderImg: "drawer/icon_user_header",
                ),
              ),
            ),
            SizedBox(width: 16),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nickName, style: Get.theme.textTheme.headline6!.copyWith(fontSize: 16)),
                  Text(I18nKeys.personal_center, style: Get.textTheme.caption!.copyWith(fontSize: 12)),
                ],
              ),
            ),
            Expanded(child: Container()),
            SizedBox(width: 20, height: 20, child: LoadAssetImage("common/icon_arrow_right"))
          ],
        ),
      ),
    );
  }
}

class _MenuFuncItem extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final GestureTapCallback? onTap;

  const _MenuFuncItem({Key? key, this.leading, this.title, this.trailing, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        child: Row(
          children: [
            SizedBox(width: 18, height: 18, child: leading ?? Container()),
            SizedBox(width: 8),
            DefaultTextStyle(style: Get.textTheme.headline6!.copyWith(fontSize: 15), child: title ?? Container()),
            Expanded(child: Container()),
            trailing ?? Container(),
            SizedBox(width: 20, height: 20, child: LoadAssetImage("common/icon_arrow_right"))
          ],
        ),
      ),
    );
  }
}
