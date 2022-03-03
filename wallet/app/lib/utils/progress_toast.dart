import 'package:flutter_base_kit/flutter_base_kit.dart';

class ProgressToastUtils {
  ProgressToastUtils._();

  /// toast cancel function
  static ToastCancelFunc? _toastCancelFun;

  static void progress(int progress) {
    if (progress < 100 && _toastCancelFun == null) {
      _toastCancelFun = Toast.showLoading();
    } else {
      if (_toastCancelFun != null) _toastCancelFun!();
      _toastCancelFun = null;
    }
  }
}
