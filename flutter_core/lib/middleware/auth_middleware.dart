import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class EnsureAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return AuthService.to.isLoggedInValue || route == Routes.USER_LOGIN ? null : RouteSettings(name: Routes.USER_LOGIN);
  }
}
