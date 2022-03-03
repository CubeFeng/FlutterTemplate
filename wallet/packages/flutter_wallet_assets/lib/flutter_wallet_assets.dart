library flutter_wallet_assets;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/utils/image_utils.dart';
import 'package:get/get.dart';

part '_image.dart';

extension WalletAssets on String {
  static const _prefix = 'packages/flutter_wallet_assets';

  /// 适配资源路径
  String get adaptAssetPath =>
      startsWith('packages/') ? this : '$_prefix/$this';

  static Future<String> loadString(String key, {bool cache = true}) =>
      rootBundle.loadString(key.adaptAssetPath, cache: cache);

  static Future<ByteData> load(String key) =>
      rootBundle.load(key.adaptAssetPath);
}
