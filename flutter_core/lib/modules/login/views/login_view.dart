import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/login/controllers/login_controller.dart';
import 'package:flutter_ucore/modules/login/views/widgets/login_text_field.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/theme/text_style.dart';
import 'package:flutter_ucore/utils/app_utils.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';
import 'package:flutter_ucore/widgets/ucore_scroll_view.dart';
// import 'package:get/get.dart';

enum LineType { Left, Right }

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        id: LoginController.LOGIN_LANGUAGE_ID,
        init: controller,
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: UCoreAppBar(
              elevation: 0,
              leading: Navigator.canPop(context)
                  ? Builder(
                      builder: (context) => IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.clear,
                          color: Get.isDarkMode ? Colors.white : Colors.black38,
                        ),
                      ),
                    )
                  : null,
              action: Padding(
                padding: EdgeInsets.only(right: 24.sp),
                child: TextButton(
                  style: ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.SETTINGS_LANGUAGE);
                  },
                  child: Text(
                    I18nKeys.change_language,
                    style: TextStyles.text,
                  ),
                ),
              ),
            ),
            body: UCoreScrollView(
              padding: EdgeInsets.all(32.0.sp),
              // tapOutsideToDismiss: true,
              keyboardConfig: AppUtils.getKeyboardActionsConfig(
                  context, [controller.userNameFocusNode, controller.passwordFocusNode]),
              children: _buildBody(context),
              bottomButton: _bottomWidget(),
            ),
          );
        });
  }

  Widget _bottomWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 74),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _line(LineType.Left),
          Text(I18nKeys.link_future, style: TextStyles.text.copyWith(color: Colours.text_gray_c)),
          _line(LineType.Right),
        ],
      ),
    );
  }

  Widget _line(LineType type) {
    final colors = const [const Color(0xFFCCCCCC), const Color(0x00CCCCCC)];
    return Expanded(
      child: Container(
        height: 1.5,
        margin: EdgeInsets.only(left: type == LineType.Right ? 10 : 0, right: type == LineType.Left ? 10 : 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: type == LineType.Right ? colors : colors.reversed.toList(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBody(BuildContext context) {
    return [
      DefaultTextStyle(
          style: TextStyles.textSize20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(I18nKeys.hello_with_comma),
              Gaps.vGap5,
              Text(I18nKeys.welcome_to_login_ucore),
            ],
          )),
      Gaps.vGap18,
      LoginTextField(
        controller: controller.userNameController,
        focusNode: controller.userNameFocusNode,
        labelText: I18nKeys.username_or_email,
        maxLength: 32,
        // autoFocus: true,
      ),
      LoginTextField(
        controller: controller.passwordController,
        focusNode: controller.passwordFocusNode,
        labelText: I18nKeys.password,
        isInputPwd: true,
        maxLength: 20,
      ),
      Gaps.vGap42,
      Obx(
        () => UCoreButton(
          onPressed: controller.loginButtonStatus.value ? controller.toLogin : null,
          text: I18nKeys.login,
        ),
      ),
      Gaps.vGap24,
      UCoreButton.outline(
        onPressed: () {
          controller.fetchIsHaveFace(true);
        },
        text: I18nKeys.face_id_login,
      ),
      Gaps.vGap24,
      DefaultTextStyle(
          style: TextStyles.text,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                child: Text(I18nKeys.to_register),
                onTap: () {
                  controller.showRegisterMode(context, () {
                    controller.fetchIsHaveFace(false);
                  });
                },
              ),
              InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                child: Text(I18nKeys.forget_password),
                onTap: () {
                  Get.toNamed(Routes.USER_RESET_PASSWORD);
                },
              ),
            ],
          )),
    ];
  }
}
