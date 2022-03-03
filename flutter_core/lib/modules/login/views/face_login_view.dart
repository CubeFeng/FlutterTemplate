import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/login/controllers/face_login_controller.dart';
import 'package:flutter_ucore/modules/login/controllers/login_controller.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';

import 'package:flutter_ucore/widgets/account_textfield.dart';

import 'package:flutter_ucore/widgets/ucore_adapt_status_bar.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';

class FaceLoginView extends GetView<FaceLoginController> {
  final LoginController loginCon = Get.find();
  @override
  Widget build(BuildContext context) {
    return UCoreAdaptStatusBar(
      child: Scaffold(
        appBar: UCoreAppBar(
          title: Text(I18nKeys.face_login),
        ),
        body: Container(
          color: Colors.white,
          height: 1.sh,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Gaps.vGap32,
              Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(60.0),
                    border: Border.all(color: Colours.brand, width: 3.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.file(
                      loginCon.livingResult.image!,
                      fit: BoxFit.cover,
                    ),
                  )),
              Gaps.vGap20,
              AccountTextField(
                leftWidget: LoadAssetImage('login/icon_account'),
                controller: controller.userNameController,
                focusNode: controller.userNameNode,
                hintText: I18nKeys.please_enter_the_associated_account,
                // labelText: I18nKeys.email_address,
              ),
              const Expanded(child: SizedBox()),
              Obx(
                () => UCoreButton(
                  onPressed: controller.loginButtonStatus.value
                      ? controller.toLogin
                      : null,
                  text: I18nKeys.login,
                ),
              ),
              Gaps.vGap32,
            ],
          ),
        ),
      ),
    );
  }
}
