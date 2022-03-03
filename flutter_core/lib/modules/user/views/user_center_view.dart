import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/user_center_controller.dart';
import 'package:flutter_ucore/modules/user/views/widget/text_button_updown.dart';
import 'package:flutter_ucore/modules/user/views/widget/user_center_cell.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/widgets/ucore_adapt_status_bar.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';

class UserCenterView extends GetView<UserCenterController> {
  @override
  Widget build(BuildContext context) {
    return UCoreAdaptStatusBar(
      child: Scaffold(
        appBar: UCoreAppBar(
          elevation: 0,
        ),
        body: Container(
          color: Colours.divider,
          height: 1.sh,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics()
                .applyTo(AlwaysScrollableScrollPhysics()),
            child: Column(
              children: [
                Obx(() {
                  // final userModel = AuthService.to.userModel;
                  return GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.USER_EDIT_PROFILE);
                      },
                      child: Container(
                        color: Colors.white,
                        child: ListTile(
                          leading: Container(
                            height: 58,
                            width: 58,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(29.0),
                            ),
                            child: LoadImage(
                              controller.iconPath.value,
                              holderImg: "drawer/icon_user_header",
                            ),
                          ),
                          title: Text(
                            controller.nickName.value,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                                color: Colours.primary_text),
                          ),
                          subtitle: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                LoadAssetImage('user/icon_uesr_editor'),
                                Gaps.hGap4,
                                Text(
                                  I18nKeys.edit_profile,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colours.secondary_text),
                                )
                              ],
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.USER_EDIT_PROFILE);
                            },
                            child: Container(
                              color: Colors.transparent,
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 29),
                              child: LoadAssetImage("common/icon_arrow_right"),
                            ),
                          ),
                        ),
                      ));
                }),
                Obx(
                  () => Container(
                    width: 1.sw,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage('assets/images/user/user_center_bg.png'),
                        fit: BoxFit.fitWidth,
                      ),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextButtonUpDown(
                            subCount: controller.readCount.value,
                            title: I18nKeys.check_history,
                            iconPath: 'user/icon_uesr_history',
                            onTap: () async {
                              await Get.toNamed(Routes.USER_READ_HISTORY);
                              controller.queryUserRssAdvisoryNum();
                            },
                          ),
                        ),
                        Gaps.hGap10,
                        Expanded(
                          flex: 1,
                          child: TextButtonUpDown(
                            subCount: controller.rssCount.value,
                            title: I18nKeys.subscribe_topic,
                            iconPath: 'user/icon_uesr_subscribe',
                            onTap: () async {
                              await Get.toNamed(Routes.USER_MY_SUBSCRIPTIONS);
                              controller.queryUserRssAdvisoryNum();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                UserCenterCell(
                  iconPath: 'user/icon_user_binding',
                  title: I18nKeys.my_binding,
                  onTap: () {
                    Get.toNamed(Routes.USER_MY_BINDING);
                  },
                ),
                Obx(() => UserCenterCell(
                      iconPath: 'user/icon_user_authorization',
                      title:
                          '${I18nKeys.my_authorization}${controller.authCount.value}',
                      onTap: () {
                        Get.toNamed(Routes.USER_MY_AUTH);
                      },
                    )),
                Gaps.vGap8,
                UserCenterCell(
                  iconPath: 'user/icon_change_password',
                  title: I18nKeys.modify_login_password,
                  onTap: () {
                    Get.toNamed(Routes.USER_MODIFY_PWD);
                  },
                ),
                Gaps.vGap8,
                UserCenterCell(
                  iconPath: 'user/icon_user_exit',
                  title: I18nKeys.logout,
                  onTap: () {
                    // controller.logout();
                    controller.showLogoutMode(context, () {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
