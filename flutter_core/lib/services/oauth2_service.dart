import 'dart:async';
import 'dart:convert';

import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/modules/oauth2/models/oauth2_model.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/config_service.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:uni_links/uni_links.dart';

class OAuth2Service extends GetxService {
  static OAuth2Service get to => Get.find();

  StreamSubscription? _sub;

  void startInterceptOAuth2() {
    getInitialUri().then((value) {
      if (value != null) {
        _handleUri(value, true);
      }
    });
    _sub = uriLinkStream.listen((event) {
      if (event != null) {
        _handleUri(event, false);
      }
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void _handleUri(Uri uri, bool initial) {
    logger.d("uri=>$uri, initial=$initial");
    final uriStr = uri.toString();
    final AppDic = uriStr.substring(
      uriStr.indexOf("AppDic=") + "AppDic=".length,
    );
    logger.d("AppDic=>$AppDic");
    final data = EncryptUtils.aesDecrypt(AppDic, ConfigService.to.oauth2Key);
    final params = jsonDecode(data) as Map<String, dynamic>;
    final action = params["action"] ?? "OAUTH2";
    final urlSchemes = params["urlSchemes"] ?? "";

    if ("OAUTH2" == action) {
      // OAuth2授权登录
      logger.d("================OAuth2授权登录");
      final AppID = params["AppID"] ?? "";
      final bundleId = params["bundleId"] ?? "";
      final appSecret = params["appSecret"] ?? "";
      final language =
          params["language"] ?? LocalService.to.language.toString();
      Get.toNamed(
        Routes.OAUTH2,
        arguments: OAuth2Model(
          appId: AppID,
          bundleId: bundleId,
          appSecret: appSecret,
          urlSchemes: urlSchemes,
          language: language,
          state: RandomUtils.alphanumeric(length: 16),
        ),
      );
    } else if ("REAL_NAME_AUTH" == action) {
      // 实名认证
      logger.d("================实名认证");
      final userId = params["userId"] ?? "";
      Get.toNamed(
        Routes.USER_REALNAME_CHOOSE_CARD,
        parameters: {"thirdAppUrlSchemes": urlSchemes, "userId": userId},
      );
    }
  }
}
