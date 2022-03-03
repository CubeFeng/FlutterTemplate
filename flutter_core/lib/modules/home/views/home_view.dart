import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/home/controllers/home_controller.dart';
import 'package:flutter_ucore/modules/home/views/widgets/home_drawer.dart';
import 'package:flutter_ucore/modules/home/views/widgets/home_news_list_view.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/message_service.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        id: HomeController.THEME_ID,
        builder: (controller) {
          return Scaffold(
            appBar: UCoreAppBar(
              leading: Builder(
                builder: (context) => Obx(() {
                  return Badge(
                      elevation: 0,
                      padding: const EdgeInsets.all(3.5),
                      showBadge: MessageService.service.unReadMessageCount > 0,
                      position: BadgePosition.topEnd(top: 12, end: 12),
                      badgeContent: const SizedBox(),
                      child: IconButton(
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          icon: LoadAssetImage("home/icon_home_menu"),
                          color: Get.isDarkMode ? Colors.white : null));
                }),
              ),
              title: Text(I18nKeys.ucore),
              action: IconButton(
                onPressed: () => Get.toNamed(Routes.RSS_CENTER),
                icon: LoadAssetImage("home/icon_home_add"),
              ),
            ),
            drawer: HomeDrawer(),
            body: HomeNewsListView(),
          );
        });
  }
}
