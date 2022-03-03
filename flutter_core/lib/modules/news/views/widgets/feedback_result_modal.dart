import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';

/// 异常反馈结果
/// 点击上报异常按钮返回true
class FeedbackResultModal extends StatelessWidget {
  const FeedbackResultModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 286,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          LoadAssetImage("news/icon_news_success"),
          Gaps.vGap16,
          Text(I18nKeys.report_successfully, style: Get.textTheme.headline6!.copyWith(fontSize: 18)),
          Gaps.vGap10,
          Text(
            I18nKeys.about_to_return_to_information_checklist_confirmation,
            style: Get.textTheme.caption!.copyWith(fontSize: 14),
          ),
          Gaps.vGap50,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: UCoreButton(
              onPressed: () => Get.back(result: true),
              text: I18nKeys.confirm,
            ),
          ),
        ],
      ),
    );
  }
}
