import 'package:flutter/material.dart';

@immutable
class OAuth2Model {
  final String appId;
  final String bundleId;
  final String appSecret;
  final String urlSchemes;
  final String language;
  final String state;

  const OAuth2Model({
    required this.appId,
    required this.bundleId,
    required this.appSecret,
    required this.urlSchemes,
    required this.language,
    required this.state,
  });
}
