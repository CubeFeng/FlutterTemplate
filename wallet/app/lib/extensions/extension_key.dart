import 'package:flutter/material.dart';

extension GlobakKeyExtensions on GlobalKey {
  /// RenderBox尺寸
  Size? get boxSize {
    final renderObj = currentContext?.findRenderObject();
    if (renderObj is RenderBox && renderObj.hasSize) {
      return renderObj.size;
    }
    return null;
  }
}
