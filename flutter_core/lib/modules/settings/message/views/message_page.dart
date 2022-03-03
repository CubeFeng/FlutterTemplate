import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/database/entity/message_entity.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/modules/settings/message/controllers/message_controller.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/theme/text_style.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';
import 'package:intl/intl.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UCoreAppBar(
        title: Text(I18nKeys.station_letter),
        action: Padding(
          padding: EdgeInsets.only(right: 10),
          child: TextButton(
            onPressed: () async {
              await controller.setAllMessageIsRead();
            },
            child: Text(I18nKeys.all_read, style: TextStyles.text),
            style: ButtonStyle(splashFactory: NoSplash.splashFactory),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.messages.length == 0) {
          return Center(
            child: Column(
              children: [
                const SizedBox(height: 94),
                LoadAssetImage("load/icon_load_nodata"),
                Gaps.hGap8,
                Text(
                  I18nKeys.no_data,
                  style: TextStyle(
                    fontSize: 12,
                    color: Get.isDarkMode ? Colours.dark_tertiary_text : Colours.tertiary_text,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          separatorBuilder: (context, int) {
            return Gaps.hhLine();
          },
          itemBuilder: (context, index) {
            final MessageEntity messageEntity = controller.messages[index];
            return ListTile(
              leading: ClipRRect(
                child: SizedBox(
                  height: 42.sp,
                  width: 42.sp,
                  child: LoadImage(messageEntity.icon),
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              title: Text(
                messageEntity.vo.title,
                style: TextStyles.textBold14,
              ),
              subtitle: Text(
                DateFormat('yyyy-MM-dd HH:MM').format(messageEntity.createTime),
                style: TextStyles.textGray12,
              ),
              trailing: Badge(
                elevation: 0,
                padding: const EdgeInsets.all(3.5),
                showBadge: !messageEntity.isRead,
                position: BadgePosition.topEnd(top: 12, end: 12),
                badgeContent: const SizedBox(),
              ),
              onTap: () async {
                await controller.setMessageIsRead(messageEntity);
                Get.toNamed(Routes.USER_MESSAGE_DETAIL, arguments: messageEntity.vo);
              },
            );
          },
          itemCount: controller.messages.length,
        );
      }),
    );
  }
}
