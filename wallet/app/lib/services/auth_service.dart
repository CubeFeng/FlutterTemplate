import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final RxBool _isLoggedIn = false.obs;

  RxBool get isLogin => _isLoggedIn;

  bool get isLoggedInValue => _isLoggedIn.value;

}
