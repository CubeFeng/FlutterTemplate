import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';

/// 上传图片视频弹窗
/// [onChangePressed] 回调事件
typedef getUploadVideoPhoneDialogContestCallback = void Function(BuildContext dialogContext);

void showUploadVideoPhoneDialog(
  BuildContext context, {
  required getUploadVideoPhoneDialogContestCallback onPressed,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      onPressed(dialogContext);
      return WillPopScope(child: UploadVideoPhoneDialog(), onWillPop: () => Future.value(false));
    },
  );
}

class UploadVideoPhoneDialog extends StatefulWidget {
  @override
  _UploadVideoPhoneDialogState createState() => _UploadVideoPhoneDialogState();
}

class _UploadVideoPhoneDialogState extends State<UploadVideoPhoneDialog> {
  int _count = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    initTimer();
  }

  void initTimer() {
    // 一直轮播的定时器
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_count < 80 && _count >= 0) {
        _count += Random().nextInt(15);
      } else if (_count <= 98 && _count >= 80) {
        _count += 1;
      }
      if (_count == 100) {
        Navigator.pop(context);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // 页面销毁时一定要 cancel 掉定时器，不然会一直执行
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.all(0.0),
          child: const LoadAssetImage(
            'realname/icon_upload_bg',
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gaps.vGap32,
              Text(
                I18nKeys.information_global_data_center,
                style: const TextStyle(
                  color: Colours.primary_bg,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Gaps.vGap10,
              Text(
                I18nKeys.it_is_expected_to_take_1_minute,
                style: const TextStyle(
                  color: Colours.primary_bg,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              Gaps.vGap24,
              // Stack(children: [
              Container(
                width: 150,
                height: 150,
                child: Stack(children: [
                  Container(
                    width: 150,
                    height: 150,
                    child: _circularProgressIndicator(),
                  ),
                  Center(
                    child: Text(
                      '$_count',
                      style: const TextStyle(
                        color: Colours.primary_bg,
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                      ),
                    ),
                  )
                ]),
              ),

              Gaps.vGap24,
              Text(
                I18nRawKeys.sync_progress_value.trPlaceholder([_count.toString()]),
                style: const TextStyle(
                  color: Colours.primary_bg,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              Gaps.vGap32,
              Text(
                I18nKeys.closing_the_page_will_interrupt_authentication,
                style: const TextStyle(
                  color: Colours.primary_bg,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  CircularProgressIndicator _circularProgressIndicator() {
    return CircularProgressIndicator(
      value: _count / 100.0, // 当前进度
      strokeWidth: 10, // 最小宽度
      backgroundColor: Colours.brand, // 进度条背景色
      valueColor: const AlwaysStoppedAnimation<Color>(Colours.primary_bg), // 进度条当前进度颜色
    );
  }
}
