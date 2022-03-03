import 'dart:io';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/controllers/real_name_message_controlller.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';

//实名认证数据采集，活体信息
class RealNameCardFaceWidget extends GetView<RealNameMessageController> {
  const RealNameCardFaceWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colours.primary_bg,
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //活体采样
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              I18nKeys.in_vivo_sampling,
                              style: TextStyle(
                                color: Colours.primary_text,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            child: InkWell(
                              child: Text(
                                I18nKeys.view_sample,
                                style: const TextStyle(
                                  color: Colours.brand,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                              onTap: () => {
                                Get.toNamed(
                                  Routes.USER_LIVINGBODY_EXAMPLE_VIEW,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.vGap16,
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Visibility(
                                child: ClickToGetLivingSampling(livingSamplingPressed: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  controller.getLivingSamplingMessage();
                                }),
                                visible: !controller.hasLivingSamplingFile.value,
                              ),
                              Visibility(
                                child: ClickToGetLivingSamplingTwo(
                                  livingSamplingPressed: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    controller.getLivingSamplingMessage();
                                  },
                                  imageFile: controller.livingSamplingFileOne.value,
                                ),
                                visible: controller.hasLivingSamplingFile.value,
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Visibility(
                                child: ClickToGetLivingSampling(livingSamplingPressed: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  controller.getLivingSamplingMessage();
                                }),
                                visible: !controller.hasLivingSamplingFile.value,
                              ),
                              Visibility(
                                child: ClickToGetLivingSamplingTwo(
                                  livingSamplingPressed: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    controller.getLivingSamplingMessage();
                                  },
                                  imageFile: controller.livingSamplingFileTwo.value,
                                ),
                                visible: controller.hasLivingSamplingFile.value,
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Visibility(
                                child: ClickToGetLivingSampling(livingSamplingPressed: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  controller.getLivingSamplingMessage();
                                }),
                                visible: !controller.hasLivingSamplingFile.value,
                              ),
                              Visibility(
                                child: ClickToGetLivingSamplingTwo(
                                  livingSamplingPressed: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    controller.getLivingSamplingMessage();
                                  },
                                  imageFile: controller.livingSamplingFileThree.value,
                                ),
                                visible: controller.hasLivingSamplingFile.value,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.vGap8,
              Container(
                padding: const EdgeInsets.only(
                  left: 16,
                ),
                child: Visibility(
                  visible: controller.hasFacePhoto.value,
                  child: Text(
                    I18nKeys.in_vivo_sampling_cannot_be_empty,
                    style: TextStyle(
                      color: Colours.brand,
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Gaps.vGap16,
              Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 36),
                  child: UCoreButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      controller.nextBtnClick();
                    },
                    text: I18nKeys.next_step,
                    minHeight: 44,
                  )),
              Gaps.vGap32,
            ],
          );
        }));
  }
}

class ClickToGetLivingSampling extends StatelessWidget {
  const ClickToGetLivingSampling({
    Key? key,
    this.livingSamplingPressed,
  }) : super(key: key);

  final VoidCallback? livingSamplingPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Center(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              LoadAssetImage(
                'realname/icon_quyang',
                fit: BoxFit.fill,
                height: 112 * (1.sw - 72) / 3 / 101,
                width: (1.sw - 72) / 3,
              ),
              Container(
                width: (1.sw - 72) / 3,
                child: Text(
                  I18nKeys.click_sampling,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colours.brand,
                    fontSize: 11,
                    decoration: TextDecoration.none,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        onTap: livingSamplingPressed,
      ),
    );
  }
}

class ClickToGetLivingSamplingTwo extends StatelessWidget {
  const ClickToGetLivingSamplingTwo({
    Key? key,
    this.livingSamplingPressed,
    this.imageFile,
  }) : super(key: key);

  final VoidCallback? livingSamplingPressed;
  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Image.file(
          imageFile ?? File(''),
          fit: BoxFit.cover,
          height: 101 * (1.sw - 72) / 3 / 112,
          width: (1.sw - 72) / 3,
        ),
        onTap: livingSamplingPressed,
      ),
    );
  }
}
