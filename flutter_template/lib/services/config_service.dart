import 'package:flutter_base_kit/common/app_env.dart';
import 'package:get/get.dart';

class ConfigService extends GetxService {
  static ConfigService get service => Get.find();

  late String _appId;
  late String _appSecret;

  String get appId => _appId;

  String get appSecret => _appSecret;

  @override
  void onInit() {
    var config = _appConfigMap[AppEnv.currentEnv().name];
    _appId = config!['appId'] ?? '';
    _appSecret = config['appSecret'] ?? '';
    super.onInit();
  }
}

final _appConfigMap = {
  'dev': {
    'appId': 'c43a9954-6c31-4126-be12-7c9637b50e40',
    'appSecret': 'b5ab307d-b05a-473d-82eb-07718d6c3146',
  },
  'test': {
    'appId': '6b26a453-d5ec-476f-ab86-25a5b7a5f095',
    'appSecret': '40f4b9f0-231f-4b8d-850f-43a44ac8970d',
  },
  'pre': {
    'appId': '6cd305e6-a2e4-4d7f-9ea9-143f6960f052',
    'appSecret': 'f5c740c7-1a4b-49e9-971b-af640028d5bb',
  },
  'prod': {
    'appId': '14debbea-bb62-4481-ad3b-6c044ca01337',
    'appSecret': '8cdccb08-747e-4804-9e9f-9285e637aa3a',
  },
  'custom': {
    'appId': '',
    'appSecret': '',
  },
};
