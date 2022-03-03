import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/json_partner/json_partner.dart';
import 'package:flutter_wallet/models/ucore_newsitem_model.dart';
import 'package:flutter_wallet/widgets/u_list_view.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:get/get.dart';

class UCHomeNewsListController extends GetxController {
  final List<UCNewsItemModel> newsList = [];

  final reController = UListViewController.initialRefresh();

  int _page = 1;

  @override
  void onInit() {
    super.onInit();

    print("UCHomeNewsListController");
  }

  @override
  void onClose() {
    super.onClose();
    reController.dispose();
  }

  @override
  void onReady() async {
    super.onReady();
    reController.refreshCompleted(resetFooterState: true);
  }

  void onRefresh() async {
    print("start request : ++++ ");

    if(_page < 15){
      _page ++;
    }else{
      _page = 1;
    }

    newsList.clear();

    final response = await queryAdvisoryList(
      page: _page,
      // rssIds: LocalService.to.subscribedRssIds,
    );

    newsList.addAll(response);
    reController.refreshCompleted();
    reController.loadNoData();

    update();
  }

  void onLoading() async {
    final response = await queryAdvisoryList(page: _page);
    reController.refreshCompleted();
    reController.loadNoData();
  }

  Future<List<UCNewsItemModel>> queryAdvisoryList({
    int? page,
  }) async {

    final String jsonString = await WalletAssets.loadString('assets/ucoredata/${_page.toString()}.json');
    final dynamic jsonObj = json.decode(jsonString);


    return JsonPartner.fromJsonAsT<List<UCNewsItemModel>>(jsonObj["data"]["records"]);

    // String deviceId;
    // try {
    //   deviceId = await FlutterDeviceUdid.udid;
    // } catch (e) {
    //   deviceId = const Uuid().v4();
    // }
    //
    // print("request result : ++++ $deviceId");
    //
    // reController.refreshCompleted();
    // ResponseModel<String> result = await HttpService.service.http
    //     .post<String>(
    //     "http://ucore-app-pre.aitdcoin.com/api/advisory/v1/userApp/queryAdvisoryList",
    //   data: {
    //     "current": 1,
    //     "size": 10,
    //     "device": device ?? deviceId,
    //     "rssIds": rssIds ?? [],
    //   }
    // );
    //
    // print("request result : ++++ $result");
  }

}
