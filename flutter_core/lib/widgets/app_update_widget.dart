import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/dimens.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/theme/text_style.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateWidget extends StatelessWidget {
  const AppUpdateWidget({Key? key, required this.desc, required this.downloadUrl, required this.forced})
      : super(key: key);

  final String desc;
  final String downloadUrl;
  final bool forced;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: Get.height - (Get.height / 10),
              ),
              child: Center(
                  child: SizedBox(
                width: Get.width * .8,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 110),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 65, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Flexible(
                            child: SingleChildScrollView(
                                child: Column(
                              children: [
                                Text(desc, style: TextStyles.text),
                              ],
                            )),
                          ),
                          Gaps.vGap15,
                          _buildButton(Get.context!, forced, downloadUrl),
                        ],
                      ),
                    ),
                    LoadAssetImage('drawer/icon_new_version'),
                    Positioned(
                      child: Text(I18nKeys.find_new_version,
                          textAlign: TextAlign.center, style: TextStyles.textBold24.copyWith(color: Colors.white)),
                      top: 85,
                      left: 0,
                      right: 0,
                    ),
                  ],
                ),
              )),
            )),
        onWillPop: () async => false);
  }

  Widget _buildButton(BuildContext context, bool force, String downloadUrl) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Row(
      mainAxisAlignment: force ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
      children: <Widget>[
        if (!force) ...{
          SizedBox(
            width: 110.0,
            height: 36.0,
            child: UCoreButton(
              text: I18nKeys.do_not_update,
              fontSize: Dimens.font_sp16,
              textColor: primaryColor,
              disabledTextColor: Colors.white,
              disabledBackgroundColor: Colours.text_gray_c,
              radius: 18.0,
              side: BorderSide(
                color: primaryColor,
                width: 0.8,
              ),
              backgroundColor: Colors.transparent,
              onPressed: () {
                Get.back();
              },
            ),
          ),
        },
        SizedBox(
          width: force ? 110 * 2 : 110.0,
          height: 36.0,
          child: UCoreButton(
            text: I18nKeys.update,
            fontSize: Dimens.font_sp16,
            onPressed: () async {
              if (await canLaunch(downloadUrl)) {
                await launch(downloadUrl, forceSafariVC: false);
              } else {
                Clipboard.setData(ClipboardData(text: downloadUrl));
                Toast.showError('接已复制到剪切板, 请打开系统浏览器粘贴访问!'); //链接已复制到剪切板, 请打开系统浏览器粘贴访问!
              }
            },
            textColor: Colors.white,
            backgroundColor: primaryColor,
            disabledTextColor: Colors.white,
            disabledBackgroundColor: Colours.text_gray_c,
            radius: 18.0,
          ),
        )
      ],
    );
  }
}
