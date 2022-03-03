import 'package:flutter/material.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/my_binding_controller.dart';
import 'package:flutter_ucore/modules/user/views/widget/my_binding_item_widget.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:get/get.dart';

class MyBindingView extends GetView<MyBindingController> {
  const MyBindingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UCoreAppBar(
          title: Text(I18nKeys.my_binding),
        ),
        body: ListView.separated(
          physics: BouncingScrollPhysics().applyTo(AlwaysScrollableScrollPhysics()),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Obx(() {
                return InkWell(
                  onTap: () {
                    if ((controller.userStateModel.value.email ?? '').isEmpty) {
                      //没有绑定邮箱
                      Get.toNamed(
                        Routes.USER_BINDING_EMAIL,
                      );
                    }
                  },
                  child: MyBingdingItemWidget(
                    icon: 'login/icon_register_mail',
                    title: I18nKeys.email_binding,
                    desc: (controller.userStateModel.value.email ?? '').isEmpty
                        ? I18nKeys.immediately_verify
                        : (controller.userStateModel.value.email ?? ''),
                    isBinding: (controller.userStateModel.value.email ?? '').isEmpty,
                  ),
                );
              });
            }
            if (index == 1) {
              return Obx(() {
                return InkWell(
                    onTap: () {
                      if (controller.userStateModel.value.status != 1 && controller.userStateModel.value.status != 0) {
                        //没有实名认证
                        Get.toNamed(
                          Routes.USER_REALNAME_CHOOSE_CARD,
                        );
                      }
                    },
                    child: MyBingdingItemWidget(
                      icon: 'realname/icon_card_cn',
                      title: I18nKeys.id_binding,
                      desc: getIdStatus(controller.userStateModel.value.status),
                      isBinding:
                          !(controller.userStateModel.value.status == 0 || controller.userStateModel.value.status == 1),
                    ));
              });
            }
            if (index == 2) {
              return Obx(() {
                return InkWell(
                  onTap: () {
                    if (controller.userStateModel.value.isFace == 0) {
                      //没有绑定人脸
                      controller.addFace();
                    }
                  },
                  child: MyBingdingItemWidget(
                    icon: 'login/icon_register_face',
                    title: I18nKeys.face_id_binding,
                    desc:
                        controller.userStateModel.value.isFace == 0 ? I18nKeys.immediately_verify : I18nKeys.has_bound,
                    isBinding: controller.userStateModel.value.isFace == 0,
                  ),
                );
              });
            }
            return Container();
          },
          separatorBuilder: (context, index) => Divider(
            indent: 16,
            endIndent: 16,
          ),
          itemCount: 3,
        ));
  }

  String getIdStatus(int? status) {
    if (status == 0) {
      //待审核
      return I18nKeys.pending_verification;
    } else if (status == 1) {
      //已实名
      return I18nKeys.has_completed_kyc_procedure;
    } else if (status == 2) {
      //审核失败
      return I18nKeys.verification_failed;
    } else if (status == 3) {
      //审核驳回
      return I18nKeys.verification_rejected;
    } else if (status == 4) {
      //取消认证
      return I18nKeys.withdraw_authentication;
    } else {
      return I18nKeys.immediately_verify;
    }
  }
}
