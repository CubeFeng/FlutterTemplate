import 'package:flutter/material.dart';
import 'package:flutter_wallet/modules/ucore/home/ucore_home_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:get/get.dart';
import 'ucore_home_list_view.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

class UCHomePage extends GetView {
  // const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UCHomePageController> (builder: (controller){
      return Scaffold(
        appBar: const QiAppBar(
          title: Text('Home',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          actions: <Widget>[
            // IconButton(
            //   // icon: Icon(Icons.add_circle),
            //   icon: const WalletLoadAssetImage('property/icon_set'),
            //   onPressed: () {
            //     // Get.toNamed(Routes.UCORE_RSS_NEWS);
            //   },
            // ),
          ],
        ),
        body: UCHomeListView(),
      );
    });
  }
}
