import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/routes/app_pages.dart';

T _runBlock<T>(T Function() fn) => fn();

class EmbedHelper {
  EmbedHelper._();

  static late final Map<String, dynamic> _forwardParameters = _runBlock(() {
    try {
      final _forward = Uri.tryParse(
        ui.window.defaultRouteName,
      )?.queryParameters['_forward'];
      if (_forward is String) {
        final forwardParameters = jsonDecode(
          utf8.decode(base64Url.decode(_forward)),
        );
        print('===============Embed.forwardParameters: $forwardParameters');
        return forwardParameters;
      }
    } on Exception {
      return {};
    }
    return {};
  });

  /// 是否为嵌入式启动
  static bool get isEmbedLaunch => _forwardParameters.isNotEmpty;

  /// 是否为启动首页
  static bool get isLaunchedHome => getForwardParameter('route') == Routes.HOME;

  /// 是否为启动DApp
  static bool get isLaunchedDApp =>
      getForwardParameter('route') == Routes.DAPPS_BROWSER;

  /// 获取嵌入式启动参数
  static dynamic getForwardParameter(String key) => _forwardParameters[key];

  /// 获取嵌入式启动地区参数
  static Locale? get embedLaunchLocale => _runBlock(() {
        final _locale = getForwardParameter('_locale');
        if (_locale is String) {
          final tuple = _locale.split("_");
          if (tuple.length == 1) {
            return Locale(tuple.first);
          } else if (tuple.length == 2) {
            return Locale(tuple.first, tuple.last);
          }
        }
        return null;
      });

  static String get backText =>
      EmbedHelper.getForwardParameter('_backText') ?? I18nKeys.back;
}
