import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/models/user/oauth_app_info_model.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_plus.dart';
import 'package:get/get.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyAuthorizationController extends GetxController {
  static const OAUTH_APP_LIST_ID = 0x01;

  final oauthAppList = <OauthAppInfoModel>[];

  late UCoreListViewPlusController listViewController;

  @override
  void onInit() async {
    super.onInit();
    listViewController = UCoreListViewPlusController(
      initialRefresh: true,
      initialRefreshStatus: RefreshStatus.refreshing,
    );
  }

  @override
  void onClose() {
    listViewController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async {
    final response = await UserApi.myAuthAppList();
    if (response.code == 0) {
      final records = response.data ?? [];
      oauthAppList.clear();
      oauthAppList.addAll(records);
      listViewController.refreshCompleted(resetFooterState: true);
      listViewController.loadNoData();
    } else {
      listViewController.refreshFailed();
    }
    update([OAUTH_APP_LIST_ID]);
  }
}
