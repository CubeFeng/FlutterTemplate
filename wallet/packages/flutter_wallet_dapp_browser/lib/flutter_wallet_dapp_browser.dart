library flutter_wallet_dapp_browser;

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_wallet_dapp_browser/src/dapp_handler/dapps_navigation_action_handler_interceptor.dart';
import 'package:flutter_wallet_dapp_browser/src/dapps_browser_service.dart';
import 'package:flutter_wallet_dapp_browser/src/js_bridget/javascript_handler_manager.dart';
import 'package:flutter_wallet_dapp_browser/src/widgets/browser_will_pop_scope.dart';
import 'package:get/get.dart';
import 'src/js_bridget/javascript_handler_interceptor.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

import 'src/widgets/browser_app_bar.dart';
import 'src/utils/inject_javascript_config.dart';
import 'src/utils/dapp_user_script.dart';

export 'src/dapps_browser_service.dart';
export 'src/dapp_handler/dapps_navigation_action_handler_interceptor.dart';

part 'src/dapp_handler/dapps_javascript_handler_interceptor.dart';
part 'src/dapps_browser_binding.dart';
part 'src/dapps_browser_controller.dart';
part 'src/dapps_browser_page.dart';
