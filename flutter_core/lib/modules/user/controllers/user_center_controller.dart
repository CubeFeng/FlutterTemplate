import 'package:flutter/material.dart';
import 'package:flutter_base_kit/widgets/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_ucore/apis/news_apis.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/models/news/read_and_rss_num_model.dart';
import 'package:flutter_ucore/modules/login/views/widgets/logout_mode_widget.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:get/get.dart';

class UserCenterController extends GetxController {
  final readCount = 0.obs; //阅读数量
  final rssCount = 0.obs; //订阅数量

  final authCount = ''.obs; //授权数量

  final iconPath = ''.obs; //头像地址
  final nickName = ''.obs; //昵称

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();

    refresh();
    queryUserRssAdvisoryNum();
  }

  void refresh() {
    final userModel = AuthService.to.userModel;
    iconPath.value = userModel?.headImg ?? '';
    nickName.value = userModel?.nickname ?? (userModel?.userSn ?? '');
  }

  /// 查询用户阅读数和订阅数
  void queryUserRssAdvisoryNum() async {
    final result = await NewsApi.queryUserRssAdvisoryNum();

    if (result.code == 0 && result.data != null) {
      ReadAndRssNumModel model = result.data as ReadAndRssNumModel;
      readCount.value = model.readHistoryNum ?? 0;
      rssCount.value = model.rssNum ?? 0;
    }
  }

  ///注册方式
  void showLogoutMode(BuildContext context, GestureTapCallback tapCallback) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Container(
            height: 198,
            width: 1.sw * 0.872,
            decoration: BoxDecoration(
              color: Colours.primary_bg,
              borderRadius: BorderRadius.circular(8.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: LogoutMode(
              onCancel: () {
                Navigator.pop(context);
              },
              onSure: () {
                Navigator.pop(context);
                logout();
              },
            ),
          ),
        );
      },
    );
  }

  ///退出登录
  Future<void> logout() async {
    Toast.showLoading();
    final result = await UserApi.userLoginOut();
    Toast.hideLoading();

    if (result.code == 0 && (result.data ?? false)) {
      AuthService.to.logout();
      Get.back();
    } else {
      Toast.show(result.message ?? '');
    }
  }
}
