import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_wallet/apis/api_urls.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/models/app_message_model.dart';
import 'package:flutter_wallet/modules/settings/controllers/my_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/http_service.dart';
import 'package:flutter_wallet/widgets/modals/uni_modals.dart';
import 'package:flutter_wallet/widgets/u_list_view.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

late List<AppMessageModel> messageList = [];

class SettingsMessageController extends GetxController {

  void onTitleChanged(InAppWebViewController controller, String? title) async {
    // webTitle.value = title ?? '';
    print("onTitleChanged =======");
  }
  void onLoadStop(InAppWebViewController controller, Uri? uri) async {
    print("onLoadStop =======");
  }

  void onLoadError(InAppWebViewController controller, Uri? uri, int code, String message) {
    print("onLoadError =======");
  }


  void goMessageDetail(AppMessageModel model){

    if(model.status == "0"){
      Map<String, dynamic>? msgMap = StorageUtils.sp.read<Map<String,dynamic>>('messageList');
      model.status = "1";
      if(msgMap == null){

        msgMap = {};
        msgMap[model.id.toString()] = "1";
        print("_buildMessage 创建添加:$msgMap");
      }else{
        msgMap[model.id.toString()] = "1";
        print("_buildMessage 直接添加:$msgMap");
      }

      // CupertinoTimerPickerMode.ms
      StorageUtils.sp.write('messageList', msgMap);
      update();

      final myController = Get.find<MyController>();
      myController.updateUnreadMessageCount(messageList);
    }
    Get.toNamed(Routes.SETTINGS_MESSAGE_DETAIL,parameters: {"content":model.content!,"title":model.title!,"time":model.updateTime!});
  }

  void readAllAction(){

    UniModals.showSingleActionPromptModal(
        icon: const WalletLoadImage("my/icon_clean_message"),
        title: Text(I18nKeys.clearUnread),
        showCloseIcon: true,
        message: Text(I18nKeys.areYouSureYouWantToMarkAllUnreadAsRead),
        action: InkWell(
            child: Text(I18nKeys.eliminate)),
        onAction:() async {
          Get.back();
          cleanUnreadMessage();
        },
        actionStyle: UniButtonStyle.Primary);

  }

  void cleanUnreadMessage(){
    Map<String, dynamic>? msgMap = StorageUtils.sp.read<Map<String,dynamic>>('messageList');
    for (AppMessageModel model in messageList){
      model.status = "1";
      if(msgMap == null){
        msgMap = {};
        msgMap[model.id.toString()] = "1";
        // print("_buildMessage 创建添加:$msgMap");
      }else{
        msgMap[model.id.toString()] = "1";
        // print("_buildMessage 直接添加:$msgMap");
      }
    }
    StorageUtils.sp.write('messageList', msgMap);
    update();

    final myController = Get.find<MyController>();
    myController.updateUnreadMessageCount(messageList);
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    final myController = Get.find<MyController>();
    myController.getMessageList();
    update();
  }

}
