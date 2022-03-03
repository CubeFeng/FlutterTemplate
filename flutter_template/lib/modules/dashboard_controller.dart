import 'dart:async';

import 'package:flutter_template/services/http_service.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

class DashboardController extends GetxController {
  final Rx<DateTime> now = DateTime.now().obs;

  @override
  void onReady() {
    super.onReady();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      now.value = DateTime.now();
    });
  }

  void requestApi() async {
    // final httpClient = Get.find<HttpService>();
    final token = CancelToken();
    HttpService.service.http.get('', cancelToken: token);
    HttpService.service.http.get('', cancelToken: token);
    HttpService.service.http.get('', cancelToken: token);
    HttpService.service.http.get('', cancelToken: token);

    // final result = await ApiClient.http
    //     .get('https://enk3i2l0744i6ab.m.pipedream.net/'); // /api?version=v9&appid=23035354&appsecret=8YvlPNrz
    // print(result);
  }
}
