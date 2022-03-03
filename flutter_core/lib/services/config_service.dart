import 'dart:io';

// import 'package:flutter_base_kit/common/app_env.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
// import 'package:get/get.dart';

class ConfigService extends GetxService {
  static ConfigService get to => Get.find();

  static ConfigService get service => Get.find();

  late String _appId;
  late String _appSecret;
  late String _rsaPublicKey;
  late String _helpAppId;

  String get appId => _appId;

  String get appSecret => _appSecret;

  String get rsaPublicKey => _rsaPublicKey;

  String get helpAppId => _helpAppId;

  String get oauth2Key => "nyBMCBG9PSaDJL1U";

  ///imo注册使用的key和bundle绑定的
  /// Android:F6E5BD400EA5B26D
  /// iOS:35D517B31059545D
  /// todo 临时使用 //Ucore的ImoSDK@"35D517B31059545D"  交易所的ImoSDK：23C76322BD3A348F
  String get imoKey => Platform.isAndroid ? 'F6E5BD400EA5B26D' : '35D517B31059545D';

  @override
  void onInit() {
    var config = _appConfigMap[AppEnv.currentEnv().name];
    _appId = config!['appId'] ?? '';
    _appSecret = config['appSecret'] ?? '';
    _rsaPublicKey = config['rasPublicKey'] ?? '';
    _helpAppId = config['helpAppId'] ?? '';
    super.onInit();
  }
}

final _appConfigMap = {
  'dev': {
    'appId': 'c43a9954-6c31-4126-be12-7c9637b50e40',
    'appSecret': 'b5ab307d-b05a-473d-82eb-07718d6c3146',
    'rasPublicKey': '''-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDF16jloymRmQJv5KlJm1UQkOAp
cNsgbWD++OE39S1AiNpNME/sY/QmDg2VDtPyX9l9KdFVOdUEyYDE2rPCm78ndFih
Zu8M9EftsZQqldaAWF2HkEWrbMfyI7B9mmdioFXWzYUDHhEUsYJkPNKDSF8rxcMp
Vs0TxCBJyT+ulubh/QIDAQAB
-----END PUBLIC KEY-----
''',
    'helpAppId': '1e51zl',
  },
  'test': {
    'appId': '6b26a453-d5ec-476f-ab86-25a5b7a5f095',
    'appSecret': '40f4b9f0-231f-4b8d-850f-43a44ac8970d',
    'rasPublicKey': '''-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDF16jloymRmQJv5KlJm1UQkOAp
cNsgbWD++OE39S1AiNpNME/sY/QmDg2VDtPyX9l9KdFVOdUEyYDE2rPCm78ndFih
Zu8M9EftsZQqldaAWF2HkEWrbMfyI7B9mmdioFXWzYUDHhEUsYJkPNKDSF8rxcMp
Vs0TxCBJyT+ulubh/QIDAQAB
-----END PUBLIC KEY-----
''',
    'helpAppId': '1e51zl',
  },
  'pre': {
    'appId': '6cd305e6-a2e4-4d7f-9ea9-143f6960f052',
    'appSecret': 'f5c740c7-1a4b-49e9-971b-af640028d5bb',
    'rasPublicKey': '''-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDF16jloymRmQJv5KlJm1UQkOAp
cNsgbWD++OE39S1AiNpNME/sY/QmDg2VDtPyX9l9KdFVOdUEyYDE2rPCm78ndFih
Zu8M9EftsZQqldaAWF2HkEWrbMfyI7B9mmdioFXWzYUDHhEUsYJkPNKDSF8rxcMp
Vs0TxCBJyT+ulubh/QIDAQAB
-----END PUBLIC KEY-----
''',
    'helpAppId': '1e51zl',
  },
  'prod': {
    'appId': '14debbea-bb62-4481-ad3b-6c044ca01337',
    'appSecret': '8cdccb08-747e-4804-9e9f-9285e637aa3a',
    'rasPublicKey': '''-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDQbZMHws73No751KoEbTIDTg85
IUO0SgtAf16GjNdI0l/Ff97y0ySuLFNej8VFMkF5PURgk2rVbOg80adUSNICJ4GY
htMXsQfb8y9c+heA1r/pAA4y2mmhAMGIS5p+Q4hMN0jKvAdnOAxe1Lg+iFnw0D4P
Yf16qk8wdmBfJtmyvwIDAQAB
-----END PUBLIC KEY-----
''',
    'helpAppId': '1e51zl',
  },
  'custom': {
    'appId': '',
    'appSecret': '',
  },
};
