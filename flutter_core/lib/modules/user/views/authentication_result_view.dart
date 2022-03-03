import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/authentication_result_controller.dart';
import 'package:flutter_ucore/modules/user/controllers/my_binding_controller.dart';
import 'package:flutter_ucore/modules/user/controllers/real_name_message_controlller.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/widgets/ucore_adapt_status_bar.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthenticationResultView extends GetView<AuthenticationResultController> {
  final RealNameMessageController realNameMessageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return UCoreAdaptStatusBar(
      child: Scaffold(
        appBar: UCoreAppBar(
          leading: IconButton(
            onPressed: () {
              //返回到
              if (realNameMessageController.thirdAppUrlSchemes != null) {
                _backToThirdApp(
                  realNameMessageController.thirdAppUrlSchemes!,
                ).then((_) =>
                    Get.until((route) => Get.currentRoute == Routes.HOME));
              } else {
                Get.find<MyBindingController>().getUserBindingData();

                Get.until(
                  (route) => Get.currentRoute == Routes.USER_MY_BINDING,
                );
              }
            },
            icon: LoadAssetImage(
              "common/icon_arrow_left",
              color: Get.isDarkMode ? Colors.white : null,
            ),
          ),
          title: Text(I18nKeys.realname_authentication),
        ),
        body: Container(
          color: Colours.primary_bg,
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Gaps.vGap42,
              Gaps.vGap50,
              LoadAssetImage('load/icon_load_wait'),
              Gaps.vGap8,
              Text(
                I18nKeys.upload_succeeded_please_wait_for_approval,
                style: TextStyle(color: Colours.text, fontSize: 14),
              ),
              Gaps.vGap8,
              Text(
                I18nKeys.it_is_expected_to_be_completed_within_2_working_days,
                style: TextStyle(color: Colours.tertiary_text, fontSize: 12),
              ),
              Gaps.vGap42,
              Gaps.vGap50,
              UCoreButton(
                onPressed: () {
                  //返回到开始页
                  if (realNameMessageController.thirdAppUrlSchemes != null) {
                    _backToThirdApp(
                      realNameMessageController.thirdAppUrlSchemes!,
                    ).then((_) =>
                        Get.until((route) => Get.currentRoute == Routes.HOME));
                  } else {
                    Get.find<MyBindingController>().getUserBindingData();
                    Get.until(
                      (route) => Get.currentRoute == Routes.USER_MY_BINDING,
                    );
                  }
                },
                text: I18nKeys.completed,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _backToThirdApp(String urlSchemes) async {
    final url = urlSchemes.contains("://")
        ? "${urlSchemes}?Appback="
        : "${urlSchemes}://?Appback=";
    logger.d("launch url=$url");
    final isCanLaunch = await canLaunch(url);
    logger.d("isCanLaunch=$isCanLaunch");
    launch(url)
        .then((value) => logger.d("launch.result=$value"))
        .catchError((err) => logger.d("launch.err=$err"));
  }
}
