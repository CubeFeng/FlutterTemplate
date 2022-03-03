import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/settings/system/controller/system_options_controller.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:get/get.dart';

class SystemOptionsView extends StatelessWidget {
  final controller = Get.put(SystemOptionsController());

  SystemOptionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (controller) {
          return Scaffold(
            appBar: QiAppBar(
              title: Text(I18nKeys.sysSetting),
            ),
            body: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildOption(
                  I18nKeys.currencyUnit,
                  LocalService.to.currencyObservable.value,
                  OptionType.Currency,
                ),
                _buildDivider(),
                _buildOption(
                  I18nKeys.languages,
                  LocalService.to.languageText,
                  OptionType.Language,
                ),
                _buildDivider(),
                _buildOption(
                  I18nKeys.switchNode,
                  '',
                  OptionType.Node,
                )
              ],
            ),
          );
        });
  }

  Widget _buildOption(String title, String subTitle, OptionType optionType) {
    return InkWell(
      onTap: () {
        controller.showOptionListModal(optionType);
      },
      child: Container(
        height: 55.h,
        padding: const EdgeInsets.only(left: 17, right: 17),
        child: Row(
          children: [
            Text(title,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xff333333),
                  fontWeight: FontWeight.bold,
                )),
            const Expanded(child: SizedBox.shrink()),
            Text(subTitle,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xff333333).withOpacity(0.8),
                )),
            SizedBox(width: 5.w),
            Icon(
              Icons.arrow_forward_ios,
              size: 12.sp,
              color: const Color(0xFFCCCCCC),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.only(left: 15.w, right: 15.w),
      child: Divider(
        height: 1.h,
        color: const Color(0xff5E6992).withOpacity(0.1),
      ),
    );
  }
}
