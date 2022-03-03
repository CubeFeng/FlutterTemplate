import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/edit_profile_controller.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/widgets/ucore_adapt_status_bar.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';

class EditProfileView extends GetView<EditProfileController> {
  @override
  Widget build(BuildContext context) {
    return UCoreAdaptStatusBar(
      child: Scaffold(
        appBar: UCoreAppBar(
          title: Text(I18nKeys.edit_profile),
        ),
        body: Container(
          color: Colours.divider,
          height: 1.sh,
          child: Obx(() => Column(
                children: [
                  Container(
                    height: 1,
                    color: Colours.divider,
                  ),
                  GestureDetector(
                    onTap: () {
                      //选择相册
                      controller.pick(context);
                    },
                    child: Container(
                      height: 74,
                      color: Colors.white,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            I18nKeys.portrait,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colours.text),
                          ),
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(21.0),
                            ),
                            child: LoadImage(
                              controller.iconPath.value,
                              holderImg: "drawer/icon_user_header",
                              height: 42,
                              width: 42,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Gaps.vGap8,
                  GestureDetector(
                    onTap: () {
                      //设置昵称
                      Get.toNamed(Routes.USER_SET_NICKNAME,
                          parameters: {'nickname': controller.nickname.value});
                    },
                    child: Container(
                      height: 53,
                      color: Colors.white,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          Text(
                            I18nKeys.nickname,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colours.text),
                          ),
                          Expanded(child: SizedBox()),
                          Text(
                            controller.nickname.value,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colours.tertiary_text),
                          ),
                          LoadAssetImage("common/icon_arrow_right")
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colours.divider,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                  ),
                  Container(
                    height: 53,
                    color: Colors.white,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ID',
                          style: TextStyle(
                              fontSize: 15, color: Colours.text),
                        ),
                        Text(
                          controller.id.value,
                          style: TextStyle(
                              fontSize: 13, color: Colours.text),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
