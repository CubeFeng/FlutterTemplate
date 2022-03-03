import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';

/// 异常反馈
/// 点击上报异常按钮返回选中异常类型
class FeedbackModal extends StatefulWidget {
  const FeedbackModal({Key? key}) : super(key: key);

  @override
  _FeedbackModalState createState() => _FeedbackModalState();
}

class _FeedbackModalState extends State<FeedbackModal> {
  int _type = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 377,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gaps.vGap24,
          Text(I18nKeys.reason_for_abnormal_function, style: Get.textTheme.headline6!.copyWith(fontSize: 18)),
          Gaps.vGap16,
          DefaultTextStyle(
            style: Get.textTheme.headline6!.copyWith(fontSize: 14),
            child: Column(
              children: [
                _buildItemWidget(
                  title: I18nKeys.page_can_not_display,
                  checked: _type == 1,
                  onTap: () => setState(() => _type = 1),
                ),
                Divider(height: 1),
                _buildItemWidget(
                  title: I18nKeys.content_infringement,
                  checked: _type == 2,
                  onTap: () => setState(() => _type = 2),
                ),
                Divider(height: 1),
                _buildItemWidget(
                  title: I18nKeys.fake_news,
                  checked: _type == 3,
                  onTap: () => setState(() => _type = 3),
                ),
              ],
            ),
          ),
          Container(height: 10, color: Get.isDarkMode ? Colours.dark_divider : Colours.divider),
          Gaps.vGap16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: UCoreButton(
              onPressed: () => Get.back(result: _type),
              text: I18nKeys.report_unusual_status,
            ),
          ),
          Gaps.vGap8,
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: ButtonStyle(splashFactory: NoSplash.splashFactory),
              onPressed: () => Get.back(),
              child: Text(
                I18nKeys.cancel,
                style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemWidget({required String title, required bool checked, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 51,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 20, height: 20),
              Text(title, style: Get.textTheme.headline6!.copyWith(fontSize: 14)),
              SizedBox(
                width: 20,
                height: 20,
                child: checked ? LoadAssetImage("drawer/icon_choose_language") : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
