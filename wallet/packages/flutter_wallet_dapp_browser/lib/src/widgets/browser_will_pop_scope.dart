import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class BrowserWillPopScope extends StatefulWidget {
  final WidgetBuilder builder;
  final Future<bool> Function() canPop;
  final WillPopCallback willPopCallback;

  const BrowserWillPopScope({Key? key, required this.builder, required this.canPop, required this.willPopCallback})
      : super(key: key);

  @override
  _BrowserWillPopScopeState createState() => _BrowserWillPopScopeState();
}

class _BrowserWillPopScopeState extends State<BrowserWillPopScope> {
  bool _hasScopedWillPopCallback = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      _checkWillPop();
    }
  }

  void _checkWillPop() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (await widget.canPop()) {
        if (!_hasScopedWillPopCallback) {
          _hasScopedWillPopCallback = true;
          ModalRoute.of(context)?.addScopedWillPopCallback(widget.willPopCallback);
        }
      } else {
        if (_hasScopedWillPopCallback) {
          _hasScopedWillPopCallback = false;
          ModalRoute.of(context)?.removeScopedWillPopCallback(widget.willPopCallback);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return WillPopScope(child: widget.builder(context), onWillPop: widget.willPopCallback);
    }
    return widget.builder(context);
  }
}
