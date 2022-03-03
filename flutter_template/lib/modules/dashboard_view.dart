import 'package:flutter_template/generated/i18n_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_template/modules/dashboard_controller.dart';
import 'package:get/get.dart';

class DashboardView extends GetView<DashboardController>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18nKeys.home),
      ),
      body: Center(
        child: Obx(
            ()=> Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'DashboardView is Working',
                  style: TextStyle(fontSize: 20),
                ),
                Text('Time：${controller.now.value.toString()}'),
                ElevatedButton(onPressed: (){
                  Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                }, child: Text('请求接口'))
              ],
            )
        ),
      ),
    );
  }
}