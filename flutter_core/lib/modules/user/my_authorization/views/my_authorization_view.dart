import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/user/my_authorization/controllers/my_authorization_controller.dart';
import 'package:flutter_ucore/modules/user/my_authorization/views/widgets/my_authorization_cell.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/widgets/ucore_adapt_status_bar.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:flutter_ucore/widgets/ucore_list_view_plus.dart';

class MyAuthorizationView extends GetView<MyAuthorizationController> {
  @override
  Widget build(BuildContext context) {
    return UCoreAdaptStatusBar(
      child: Scaffold(
        appBar: UCoreAppBar(
          title: Text(I18nKeys.my_authorization),
        ),
        body: Container(
          width: double.infinity,
          color: Get.isDarkMode ? Colours.dark_secondary_bg : Colours.secondary_bg,
          child: Scrollbar(
            child: GetBuilder<MyAuthorizationController>(
              id: MyAuthorizationController.OAUTH_APP_LIST_ID,
              autoRemove: false,
              builder: (controller) {
                return UCoreListViewPlus(
                  controller: controller.listViewController,
                  onRefresh: controller.onRefresh,
                  enableRefresh: true,
                  enableLoadMore: false,
                  itemBuilder: (context, index) {
                    return MyAuthorizationCell(
                      model: controller.oauthAppList[index],
                      onPressed: () {},
                    );
                  },
                  separatorBuilder: (context, index) => Divider(indent: 16, endIndent: 16),
                  itemCount: controller.oauthAppList.length,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
