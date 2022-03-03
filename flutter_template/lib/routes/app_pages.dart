

import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_template/modules/dashboard_binding.dart';
import 'package:flutter_template/modules/dashboard_view.dart';

part  'app_routes.dart';

class AppPages{
  AppPages._();

  static const String INITIAL = Routes.HOME;

  static final routes = [
    GetPage<dynamic> (
      name: INITIAL,
      page: ()=>DashboardView(),
      binding: DashboardBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true
    ),
  ];
}