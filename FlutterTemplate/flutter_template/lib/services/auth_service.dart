import 'package:get/get.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final RxBool isLoggedIn = false.obs;

  bool get isLoggedInValue => isLoggedIn.value;

  void login() {
    isLoggedIn.value = true;
  }

  void loggout() {
    isLoggedIn.value = false;
  }
}
