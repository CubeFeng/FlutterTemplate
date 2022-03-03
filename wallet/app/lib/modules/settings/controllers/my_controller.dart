import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/apis/api_urls.dart';
import 'package:flutter_wallet/models/app_message_model.dart';
import 'package:flutter_wallet/modules/settings/message/controller/settings_message_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/app_service.dart';
import 'package:flutter_wallet/services/http_service.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:get/get.dart';

class MyController extends GetxController {
  late String appVersion;
  late String appBuildNumber;
  final unreadMessage = false.obs;

  void goMessageListPage(){
    Get.toNamed(Routes.SETTINGS_MESSAGE);
  }

  void _updatePage(){
    update();
    getMessageList();
  }

  @override
  void onInit() async {
    super.onInit();
    LocalService.to.currencyObservable.stream.listen((_) => update());
    LocalService.to.languageObservable.stream.listen((_) => _updatePage());

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version; //版本号
    String buildNumber = packageInfo.buildNumber;

    final appInfo = await AppService.service.info;
    appVersion = appInfo?.channelVersion ?? "0.0.0";
    // appVersion = version;
    appBuildNumber = buildNumber;

    getMessageList();

  }

  void getMessageList() async{
    ResponseModel<List<AppMessageModel>> resultList = await HttpService
        .service.http
        .get<List<AppMessageModel>>(ApiUrls.getMessageList);

    messageList = resultList.data!;

    updateUnreadMessageCount(resultList.data!);
  }

  void updateUnreadMessageCount(List<AppMessageModel> list){
    Map<String, dynamic>? msgMap = StorageUtils.sp.read<Map<String,dynamic>>('messageList');
    messageList = [];
    bool unread = false;
    for (AppMessageModel model in list){
      if(msgMap == null){
        unread = list.isNotEmpty;
        model.status = "0";
      }else{
        if (msgMap[model.id.toString()] == null){
          unread = true;
          model.status = "0";
        }
        else{
          model.status = "1";
        }
      }

      // print("站内信 标题 ${model.title}  ===== ${model.content}");

      if(model.content.isNotNullOrEmpty){
        // print("站内信 标题1 ${model.title}");
        messageList.add(model);
      }
    }

    unreadMessage.value = unread;
  }
}
