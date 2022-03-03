import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:get/get.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

export 'package:local_auth/auth_strings.dart';
export 'package:local_auth/local_auth.dart';

/// 安全服务
class SecurityService extends GetxService {
  static SecurityService get to => Get.find();

  //<editor-fold desc="安全密码">
  static const _prefix = "security.";

  /// 明文密码
  /// 使用 `md5(盐)` 作为key，明文密码作为data进行AES加密
  static const _keyCiphertextPassword = "${_prefix}ciphertextPassword";

  /// 加密数据段
  /// 使用 `md5(明文密码)` 作为key，盐作为data进行AES加密
  static const _keyCiphertext = "${_prefix}ciphertext";

  /// 盐
  /// `md5(当前时间戳)`
  static const _keySalt = "${_prefix}salt";

  /// Touch ID 、Face ID 支付key
  static const _keyPayBiometry = "${_prefix}payBiometry";

  /// Touch ID 、Face ID 登录key
  static const _keyLoginBiometry = "${_prefix}loginBiometry";

  /// todo: 使用加密存储器 `StorageUtils.ss`
  late final _store = StorageUtils.sp;

  ///删除钱包密码
  Future<bool> cleanPassword() async {
    return await (_store.delete(_keySalt) ?? Future.value(false)) &&
        await (_store.delete(_keyCiphertext) ?? Future.value(false)) &&
        await (_store.delete(_keyCiphertextPassword) ?? Future.value(false)) &&
        await (_store.delete(_keyPayBiometry) ?? Future.value(false)) &&
        await (_store.delete(_keyLoginBiometry) ?? Future.value(false));
  }

  /// 设置安全密码
  /// [password] 明文密码
  /// [original] 是否存储明文密码
  Future<bool> setSecurityPassword(
    String password, {
    bool original = false,
  }) async {
    if (password == '') throw Exception('password not empty');
    final salt = EncryptUtils.encryptMD5(
        DateTime.now().microsecondsSinceEpoch.toString());
    final ciphertext = EncryptUtils.aesEncrypt(
      salt,
      EncryptUtils.encryptMD5(password),
    );
    final ciphertextPassword = EncryptUtils.aesEncrypt(
      password,
      EncryptUtils.encryptMD5(salt),
    );
    return original
        ? await _store.write(_keySalt, salt) &&
            await _store.write(_keyCiphertext, ciphertext) &&
            await _store.write(_keyCiphertextPassword, ciphertextPassword)
        : await _store.write(_keySalt, salt) &&
            await _store.write(_keyCiphertext, ciphertext) &&
            await (_store.delete(_keyCiphertextPassword) ?? Future.value(true));
  }

  ///开启指纹后获取密码
  String getPassword() {
    final salt = _store.read(_keySalt, '');
    final ciphertextPassword = _store.read(_keyCiphertextPassword, '');
    return EncryptUtils.aesDecrypt(
      ciphertextPassword!,
      EncryptUtils.encryptMD5(salt!),
    );
  }

  /// 验证安全密码
  /// [password] 明文密码
  /// [original] 是否比较明文密码
  bool verifySecurityPassword(String password, {bool original = false}) {
    final salt = _store.read(_keySalt, '');
    final ciphertext = _store.read(_keyCiphertext, '');
    final ciphertextPassword = _store.read(_keyCiphertextPassword, '');
    if (original) {
      if (salt.isNullOrEmpty || ciphertextPassword.isNullOrEmpty) {
        return false;
      }
      final plaintextPassword = EncryptUtils.aesDecrypt(
        ciphertextPassword!,
        EncryptUtils.encryptMD5(salt!),
      );
      return plaintextPassword == password;
    } else {
      if (salt.isNullOrEmpty || ciphertext.isNullOrEmpty) {
        return false;
      }
      final ciphertextComputed = EncryptUtils.aesEncrypt(
        salt!,
        EncryptUtils.encryptMD5(password),
      );
      return ciphertextComputed == ciphertext;
    }
  }

  /// 是否已设置安全密码
  bool get hasSecurityPassword {
    final salt = _store.read(_keySalt, '');
    final ciphertext = _store.read(_keyCiphertext, '');
    if (salt.isNullOrEmpty || ciphertext.isNullOrEmpty) {
      return false;
    }
    return true;
  }

//</editor-fold>

  //<editor-fold desc="生物识别">
  late final localAuth = LocalAuthentication();

  /// 是否支持生物识别
  Future<bool> get canCheckBiometrics async {
    return (await localAuth.getAvailableBiometrics()).isNotEmpty;
  }

  /// 设备是否支持鉴权
  Future<bool> get isDeviceAuthSupported => localAuth.isDeviceSupported();

  /// 是否已设置Touch ID 、Face ID支付
  Future<bool> get isOpenBiometryPay async {
    //检查设置是否还支持生物识别
    bool support = (await SecurityService.to.canCheckBiometrics);

    if (!support) {
      return false;
    }

    final pay = _store.read(_keyPayBiometry, '');
    if (pay.isNullOrEmpty || pay.isNullOrEmpty) {
      return false;
    }
    return true;
  }

  /// 设置Touch ID 、Face ID支付
  Future<bool> setBiometryPay(bool save) async {
    if (save) {
      final timestamp = EncryptUtils.encryptMD5(
          DateTime.now().microsecondsSinceEpoch.toString());
      return await _store.write(_keyPayBiometry, timestamp);
    } else {
      return await (_store.delete(_keyPayBiometry) ?? Future.value(false));
    }
  }

  /// 是否已设置Touch ID 、Face ID登录
  Future<bool> get isOpenBiometryLogin async {
    //检查设置是否还支持生物识别
    bool support = (await SecurityService.to.canCheckBiometrics);

    if (!support) {
      return false;
    }

    final pay = _store.read(_keyLoginBiometry, '');
    if (pay.isNullOrEmpty || pay.isNullOrEmpty) {
      return false;
    }
    return true;
  }

  /// 设置Touch ID 、Face ID登录
  Future<bool> setBiometryLogin(bool save) async {
    if (save) {
      final timestamp = EncryptUtils.encryptMD5(
          DateTime.now().microsecondsSinceEpoch.toString());
      return await _store.write(_keyLoginBiometry, timestamp);
    } else {
      return await (_store.delete(_keyLoginBiometry) ?? Future.value(false));
    }
  }

  /// 获取设备生物识别类型
  /// BiometricType.face (人脸识别)
  /// BiometricType.fingerprint (指纹识别)
  Future<List<BiometricType>> get getAvailableBiometrics async {
    return await localAuth.getAvailableBiometrics();
  }

  /// 开始生物鉴权
  /// [biometricOnly]为`true`时，如果没有录入生物特征将会抛出异常
  Future<bool> authenticate({
    required String localizedReason,
    bool useErrorDialogs = true,
    bool stickyAuth = false,
    AndroidAuthMessages? androidAuthStrings,
    IOSAuthMessages? iOSAuthStrings,
    bool sensitiveTransaction = true,
    bool biometricOnly = true,
  }) {
    return localAuth.authenticate(
      localizedReason: localizedReason,
      useErrorDialogs: useErrorDialogs,
      stickyAuth: stickyAuth,
      androidCustomUi: true,
      androidAuthStrings: androidAuthStrings ??
          AndroidAuthMessages(
            signInTitle: I18nKeys.pleaseVerifyTheFingerprint,
            biometricHint:
                I18nKeys.afterVerifyingTheFingerprintContinueToTheNextStep,
            cancelButton: I18nKeys.cancel,
          ),
      iOSAuthStrings: iOSAuthStrings ??
          IOSAuthMessages(
            cancelButton: I18nKeys.cancel,
          ),
      sensitiveTransaction: sensitiveTransaction,
      biometricOnly: biometricOnly,
    );
  }

  /// 停止/取消生物鉴权
  Future<bool> stopAuthentication() => localAuth.stopAuthentication();

//</editor-fold>

}
