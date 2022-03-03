import 'package:flutter/services.dart';

class EmbedChannels {
  EmbedChannels._();

  static late final bridge = BridgeChannel();
}

class BridgeChannel {
  final _channel =
      const MethodChannel('cn.tqxd.wallet/bridge', JSONMethodCodec());

  void onFlutterEngineReady() => _channel.invokeMethod('onFlutterEngineReady');
}
