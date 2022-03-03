import 'package:flutter/foundation.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/common/constants.dart';
import 'package:flutter_ucore/models/user_model.dart';
// import 'package:get/get.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final RxBool _isLoggedIn = false.obs;

  RxBool get isLogin => _isLoggedIn;

  bool get isLoggedInValue => _isLoggedIn.value;

  Rx<UserModel> _userModel = UserModel().obs;

  UserModel? get userModel => _userModel.value;

  String? get accessToken => _userModel.value.token;

  String? get refreshToken => _userModel.value.refreshToken;

  void loginWithPassword() {}

  @override
  void onInit() {
    super.onInit();

    _loadUser();
    if (kReleaseMode) {
      injectSentryUserInfo();
    }
  }

  Future<void> injectSentryUserInfo() async {
    isLogin.listen((bool _isLogin) {
      if (_isLogin) {
        NeSentry.cleanUser();
      } else {
        NeSentry.setUpUser(userModel?.userId ?? 'undefine', userName: userModel?.nickname ?? 'nickName');
        if (userModel?.email != null) {
          NeSentry.addTag('email', userModel!.email!);
        }
      }
    });
  }

  /// 用户登录
  Future<void> updateUser(UserModel user) async {
    _userModel.value = user;
    NeSentry.setUpUser('${user.userId}', userName: user.mobile, email: user.email);
    await updateToken(user.token!, user.refreshToken!, user.expireTime!);
    _isLoggedIn.value = true;
  }

  /// 加载本地用户数据
  void _loadUser() {
    final userMap = StorageUtils.sp.read<Map>(Constants.appUserCacheKey);
    if (userMap != null) {
      final UserModel? user = UserModel().fromJson(userMap as Map<String, dynamic>);
      if (user != null) {
        if (user.userId != 0) {
          _isLoggedIn.value = true;
          _userModel.value = user;
          NeSentry.setUpUser('${user.userId}', userName: user.mobile, email: user.email);
        }
      }
    }
  }

  /// 更新用户 Token
  Future<void> updateToken(
    String token,
    String refreshToken,
    int expireTime,
  ) async {
    _userModel.value
      ..token = token
      ..refreshToken = refreshToken
      ..expireTime = DateTime.now().millisecondsSinceEpoch ~/ 1000 + expireTime; // 当前时间+有效期

    /// 写入
    await StorageUtils.sp.write(Constants.appUserCacheKey, _userModel.toJson());
  }

  /// 移除用户
  Future<void> logout() async {
    _userModel.value = UserModel();
    await StorageUtils.sp.delete(Constants.appUserCacheKey);
    // StorageUtils.sp.delete(Constants.accessToken);
    // StorageUtils.sp.delete(Constants.refreshToken);
    NeSentry.cleanUser();
    _isLoggedIn.value = false;
  }
}
