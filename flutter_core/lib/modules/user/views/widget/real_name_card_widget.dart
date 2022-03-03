// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/real_name_message_controlller.dart';
import 'package:flutter_ucore/modules/user/views/widget/upload_image_fail_widget.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';

//实名认证证件照片采集
class RealNameCardWidget extends GetView<RealNameMessageController> {
  const RealNameCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 16,
        ),
        color: Colours.primary_bg,
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  I18nKeys.please_upload_your_id_photo,
                  style: TextStyle(
                    color: Colours.primary_text,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Stack(
                        children: [
                          Visibility(
                            //没有图片的时候
                            child: Stack(children: [
                              LoadAssetImage(
                                'realname/icon_card_fanmian',
                                fit: BoxFit.fill,
                                height: 100 * (1.sw - 47) / 2 / 164,
                                width: (1.sw - 47) / 2,
                              ),
                              Container(
                                height: 100 * (1.sw - 47) / 2 / 164,
                                width: (1.sw - 47) / 2,
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    LoadAssetImage(
                                      'realname/icon_click',
                                      fit: BoxFit.fill,
                                      height: 22,
                                      width: 22,
                                    ),
                                    Gaps.vGap8,
                                    Text(
                                      controller.isIdCard == 1
                                          ? I18nKeys.click_to_shoot_personal_information
                                          : I18nKeys.shoot_personal_information_avatar,
                                      style: TextStyle(
                                        color: Colours.text_gray,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            visible: controller.leftPhotoType.value == 0,
                          ),
                          Visibility(
                            //有图片的时候
                            child: Stack(children: [
                              Image.file(
                                controller.leftPhotoFile.value,
                                fit: BoxFit.fill,
                                height: 100 * (1.sw - 47) / 2 / 164,
                                width: (1.sw - 47) / 2,
                              ),
                              Visibility(
                                //图片上传失败
                                child: Container(
                                  height: 100 * (1.sw - 47) / 2 / 164,
                                  width: (1.sw - 47) / 2,
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      UploadImageFailView(),
                                      Gaps.vGap8,
                                      Text(
                                        I18nKeys.upload_failed_please_upload_again,
                                        style: TextStyle(
                                          color: Colours.primary_bg,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                visible: controller.leftPhotoType.value == 2,
                              ),
                              Visibility(
                                //图片上传中
                                child: Container(
                                  height: 100 * (1.sw - 47) / 2 / 164,
                                  width: (1.sw - 47) / 2,
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 20,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LoadAssetImage(
                                        'realname/icon_card_loading',
                                        fit: BoxFit.fill,
                                        height: 20,
                                        width: 20,
                                      ),
                                      Gaps.vGap8,
                                      Text(
                                        I18nKeys.uploading,
                                        style: TextStyle(
                                          color: Colours.primary_bg,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                visible: controller.leftPhotoType.value == 1,
                              ),
                              Visibility(
                                //图片上传成功
                                child: Container(
                                  height: 100 * (1.sw - 47) / 2 / 164,
                                  width: (1.sw - 47) / 2,
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LoadAssetImage(
                                        'realname/icon_card_again',
                                        fit: BoxFit.fill,
                                        height: 22,
                                        width: 22,
                                      ),
                                    ],
                                  ),
                                ),
                                visible: controller.leftPhotoType.value == 3,
                              ),
                            ]),
                            visible: controller.leftPhotoType.value != 0,
                          ),
                        ],
                      ),
                      onTap: () => {
                        FocusScope.of(context).requestFocus(FocusNode()),
                        // //点击拍摄上传/正面
                        if (controller.isIdCard == 1)
                          {
                            controller.getIDCardMessage(),
                          }
                        else
                          {
                            controller.getOtherIDCardMessage(true),
                          }
                      },
                    ),
                    InkWell(
                      child: Stack(
                        children: [
                          Visibility(
                            //没有图片的时候
                            child: Stack(children: [
                              LoadAssetImage(
                                'realname/icon_card_zhengmian',
                                fit: BoxFit.fill,
                                height: 100 * (1.sw - 47) / 2 / 164,
                                width: (1.sw - 47) / 2,
                              ),
                              Container(
                                height: 100 * (1.sw - 47) / 2 / 164,
                                width: (1.sw - 47) / 2,
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    LoadAssetImage(
                                      'realname/icon_click',
                                      fit: BoxFit.fill,
                                      height: 22,
                                      width: 22,
                                    ),
                                    Gaps.vGap8,
                                    Text(
                                      controller.isIdCard == 1
                                          ? I18nKeys.click_to_shoot_the_national_emblem
                                          : I18nKeys.shoot_other_information,
                                      style: TextStyle(
                                        color: Colours.text_gray,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            visible: controller.rightPhotoType.value == 0,
                          ),
                          Visibility(
                            //有图片的时候
                            child: Stack(children: [
                              Image.file(
                                controller.rightPhotoFile.value,
                                fit: BoxFit.fill,
                                height: 100 * (1.sw - 47) / 2 / 164,
                                width: (1.sw - 47) / 2,
                              ),
                              Visibility(
                                //图片上传失败
                                child: Container(
                                  height: 100 * (1.sw - 47) / 2 / 164,
                                  width: (1.sw - 47) / 2,
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      UploadImageFailView(),
                                      Gaps.vGap8,
                                      Text(
                                        I18nKeys.upload_failed_please_upload_again,
                                        style: TextStyle(
                                          color: Colours.primary_bg,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                visible: controller.rightPhotoType.value == 2,
                              ),
                              Visibility(
                                //图片上传中
                                child: Container(
                                  height: 100 * (1.sw - 47) / 2 / 164,
                                  width: (1.sw - 47) / 2,
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LoadAssetImage(
                                        'realname/icon_card_loading',
                                        fit: BoxFit.fill,
                                        height: 20,
                                        width: 20,
                                      ),
                                      Gaps.vGap8,
                                      Text(
                                        I18nKeys.uploading,
                                        style: TextStyle(
                                          color: Colours.primary_bg,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                visible: controller.rightPhotoType.value == 1,
                              ),
                              Visibility(
                                //图片上传成功
                                child: Container(
                                  height: 100 * (1.sw - 47) / 2 / 164,
                                  width: (1.sw - 47) / 2,
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LoadAssetImage(
                                        'realname/icon_card_again',
                                        fit: BoxFit.fill,
                                        height: 22,
                                        width: 22,
                                      ),
                                    ],
                                  ),
                                ),
                                visible: controller.rightPhotoType.value == 3,
                              ),
                            ]),
                            visible: controller.rightPhotoType.value != 0,
                          ),
                        ],
                      ),
                      onTap: () => {
                        FocusScope.of(context).requestFocus(FocusNode()),
                        // 点击拍摄上传/反
                        if (controller.isIdCard == 1)
                          {
                            controller.getIDCardMessage(),
                          }
                        else
                          {
                            controller.getOtherIDCardMessage(false),
                          }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16),
                child: Visibility(
                  visible: controller.hasCardPhoto.value,
                  child: Text(
                    I18nKeys.identity_photo_cannot_be_empty,
                    style: TextStyle(
                      color: Colours.brand,
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
