import 'dart:async';

import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/news_apis.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:get/get.dart';

class TaskService extends GetxService {
  StreamSubscription? _loginSub;

  @override
  void onInit() {
    super.onInit();
    _loginSub = AuthService.to.isLogin.stream.listen((event) async {
      if (event == true) {
        // 登录同步用户订阅
        final localRssIds = LocalService.to.subscribedRssIds;
        await NewsApi.recordUserRssSource(rssIds: localRssIds);
        final response = await NewsApi.queryRssListCurrent(
          page: 0,
          pageSize: 9999,
          rssIds: localRssIds,
        );
        if (response.code == 0) {
          final rssIds = <int>[];
          response.data?.records?.forEach((e) {
            if (e.rssId != null) rssIds.add(e.rssId!);
          });
          LocalService.to.subscribedRssIds = rssIds;
        }
      } else {
        // 清除本地订阅记录
        LocalService.to.subscribedRssIds = [];
      }
    });
  }

  @override
  void onClose() {
    _loginSub?.cancel();
    super.onClose();
  }
}
