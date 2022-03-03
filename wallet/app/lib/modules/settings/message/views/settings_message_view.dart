import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/models/app_message_model.dart';
import 'package:flutter_wallet/modules/settings/message/controller/settings_message_controller.dart';
import 'package:flutter_wallet/modules/settings/message/controller/settings_message_controller.dart';
import 'package:flutter_wallet/modules/settings/message/controller/settings_message_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/u_list_view.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:get/get.dart';

class SettingsMessageView extends StatelessWidget {
  final _controller = Get.put(SettingsMessageController());

  SettingsMessageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: _controller,
        builder: (controller) {
          return Scaffold(
            appBar: QiAppBar(
              title: Text(I18nKeys.mailList),
              action: messageList.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(right: 6.w),
                      child: TextButton(
                        onPressed: _controller.readAllAction,
                        child: Text(
                          I18nKeys.mail_allRead,
                          style: const TextStyle(
                            color: Color(0xFF384A8B),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
              // body:
              body:  messageList.isNotEmpty? _buildMessageList()
                  : _buildEmpty(),
          );
        });
  }

  Widget _buildMessageList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        AppMessageModel model =  messageList[index];
        // print("AppMessageModel content ${model.id}");
        return _buildMessage(model);
      },
      itemCount: messageList.length,
    );
  }

  Widget _buildMessage(AppMessageModel model) {
    String iconPath = "my/icon_message_notice";
    if (model.type == "1") {
      iconPath = "my/icon_message_update";
    } else if (model.type == "2") {
      iconPath = "my/icon_message_activity";
    } else {
      iconPath = "my/icon_message_notice";
    }
    return GestureDetector(
      onTap: () {
        _controller.goMessageDetail(model);
      },
      child: Column(
        children: [
          SizedBox(height: 8.h),
          Text(
            model.updateTime!,
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
          ),
          SizedBox(height: 10.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 3.w),
                  color: const Color(0xFF000000).withOpacity(0.08),
                  blurRadius: 5.w,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 45,
                        height: 45,
                        //icon_message_activity //icon_message_update
                        child: WalletLoadAssetImage(iconPath),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: Align(
                            alignment: const Alignment(-1, -0.5),
                            child: Text(
                              model.title!,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 14.sp,
                                overflow: TextOverflow.ellipsis,
                                color: Color(model.status == "0"
                                    ? 0xFF333333
                                    : 0xFF999999),
                              ),
                            ),
                          ),
                        ),
                      ),
                      model.status == "0"
                          ? Container(
                              margin: EdgeInsets.only(left: 6.w),
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFD6E61),
                              ),
                            )
                          : const SizedBox.shrink(),
                      SizedBox(width: 10.w),
                    ],
                  ),
                ),
                Divider(
                    height: 1,
                    color: const Color(0xFF000000).withOpacity(0.02)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          I18nKeys.learnMore,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF999999),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Color(0xFFCCCCCC),
                      ),
                      SizedBox(width: 10.w),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 17.h),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 100.h),
          SizedBox(
              width: 112.w,
              height: 89.h,
              child: const WalletLoadAssetImage("my/icon_message_empty")),
          SizedBox(height: 15.h),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF666666),
            ),
            child: Text(I18nKeys.noContent),
          )
        ],
      ),
    );
  }
}
