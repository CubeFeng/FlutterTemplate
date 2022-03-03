import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_action_sheet/flutter_action_sheet.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:fk_photos/fk_photos.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';

class FeedbackController extends GetxController {
  final mobileOrEmailController = TextEditingController();
  final contentController = TextEditingController();
  final mobileOrEmailFocusNode = FocusNode();
  final contentFocusNode = FocusNode();

  final image = File('').obs;

  final type = 0.obs;
  final typeList = [];
//final userModel = AuthService.to.userModel;
  /// 上传的图片地址
  String? imageUrl;

  @override
  void onInit() {
    super.onInit();
    typeList.addAll([
      I18nKeys.other,
      I18nKeys.layout_optimization,
      I18nKeys.new_added_functions,
      I18nKeys.theme_origin_is_not_sufficient,
    ]);
  }

  @override
  void onReady() async {
    super.onReady();
    final userModel = AuthService.to.userModel;
    mobileOrEmailController.text = userModel?.email ?? '';
  }

  Future<void> onSelectedPhoto(File file) async {
    Toast.showLoading();
    final String fileBase64 = await file.toBase64();
    final res = await UserApi.rssFileUpload(
        md5: '', suffixName: 'jpg', fileBase64: fileBase64);
    if (res.data == null) {
      Toast.showError(I18nKeys.picture_upload_failed_please_try_again);
      return;
    }
    image.value = file;
    imageUrl = res.data;
    Toast.hideLoading();
    logger.d(res.toString());
  }

  void selectPhotoPicker() {
    showSelectPhotoPicker(Get.context!,takePicText: I18nKeys.camera,albumText: I18nKeys.choose_from_the_album,cancelText: I18nKeys.cancel, onCameraCallback: (asset) async {
      if (asset != null) {
        final File file = (await asset.compress())!;
        await onSelectedPhoto(file);
      }
    }, onAlbumCallback: (assetList) async {
      if (assetList != null) {
        final File file = (await assetList.first.compress())!;
        await onSelectedPhoto(file);
      }
    });
  }

  void selectType() {
    showActionSheet(
        enableDrag: false,
        context: Get.context!,
        actionSheetBar: ActionSheetBar(I18nKeys.suggested_types,
            showAction: false, doneAction: (List<int> data) {
          // Get.back();
        }),
        selections: typeList.map((e) {
          return ActionSheetSelectItem(e,
              isSelected: typeList.indexOf(e) == type.value);
        }).toList(),
        selectWidgetBuilder: (context, index, selected) {
          return InkWell(
            onTap: () {
              type.value = index;
              Get.back();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gaps.hGap24,
                  Expanded(
                    child: Text(
                      typeList[index],
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(Icons.check,
                      color: selected ? Color(0xFFFF9544) : Colors.transparent)
                ],
              ),
            ),
          );
        },
        bottomAction: BottomCancelActon(I18nKeys.cancel));
  }

  void showSuccessPage() {
    showGeneralDialog(
      context: Get.context!,
      barrierLabel: I18nKeys.hello,
      barrierDismissible: true,
      // transitionDuration: Duration(milliseconds: 1000), //这个是时间
      barrierColor: Colors.white,
      // 添加这个属性是颜色
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return Scaffold(
          appBar: UCoreAppBar(
            leading: IconButton(
              icon: Icon(Icons.close),
              color: Get.isDarkMode ? Colors.white : Colors.grey,
              onPressed: () {
                Get.until((dynamic route) {
                  return route.settings.name == Routes.HOME;
                });
              },
            ),
            elevation: 0,
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 120.sp),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LoadAssetImage('drawer/icon_advice_success'),
                  Gaps.vGap34,
                  Text(
                    I18nKeys.suggestions_have_been_received,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> onSubmit() async {
    if (mobileOrEmailController.text.isEmpty) {
      Toast.showError(I18nKeys.please_enter_contact_information);
      return;
    }
    if (contentController.text.isEmpty) {
      Toast.showError(I18nKeys.please_enter_the_content);
      return;
    }
    Toast.showLoading();
    final res = await UserApi.suggestSubmit(
        content: contentController.text,
        contactDetails: mobileOrEmailController.text,
        image: imageUrl,
        type: type.value);
    Toast.hideLoading();
    if (res.data == true) {
      showSuccessPage();
    }
  }
}
