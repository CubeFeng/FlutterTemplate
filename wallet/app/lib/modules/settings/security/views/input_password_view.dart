import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';

class InputPassword extends StatelessWidget {
  const InputPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: QiAppBar(
        centerTitle: true,
        title: Text(I18nKeys.changeSecPwd),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Positioned(
              top: 65.h,
              left: 15.w,
              child: Text(
                I18nKeys.enterSafePwd,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xff161A27),
                ),
              ),
            ),
            Positioned(
              left: 15.w,
              right: 15.w,
              top: 102.h,
              child: SizedBox(
                height: 47,
                child: TextField(
                  autofocus: true,
                  controller: controller,
                  obscureText: true,
                  cursorColor: const Color(0xFF2750EB),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
