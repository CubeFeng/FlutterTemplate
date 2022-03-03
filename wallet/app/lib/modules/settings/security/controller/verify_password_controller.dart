import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyPasswordController extends GetxController {
  late final passwordController = TextEditingController();
  late final passwordFocusNode = FocusNode();

  final _canComplete = false.obs;

  /// 是否可完成
  bool get canComplete => _canComplete.value;

  @override
  void onReady() {
    super.onReady();
    passwordFocusNode.requestFocus();
    passwordController.addListener(() {
      _canComplete.value = passwordController.text.length >= 6;
    });
  }
}
