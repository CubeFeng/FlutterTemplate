import 'package:flutter/cupertino.dart';
import 'package:flutter_wallet/modules/settings/security/widgets/password_level_prompt.dart';
import 'package:flutter_wallet/modules/wallet/create/controllers/wallet_create_controller.dart';
import 'package:flutter_wallet/modules/wallet/manager/controllers/wallet_manage_controller.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/security_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:get/get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';

class SetupPasswordController extends GetxController
    with WidgetsBindingObserver {
  late final passwordController = TextEditingController();
  late final passwordFocusNode = FocusNode();
  late final confirmPasswordController = TextEditingController();
  late final confirmPasswordFocusNode = FocusNode();
  final title = Get.parameters["title"] ?? I18nKeys.setWalletPwd;

  final _numberReg = RegExp(r'[0-9]');
  final _lowercaseReg = RegExp(r'[a-z]');
  final _uppercaseReg = RegExp(r'[A-Z]');
  final _symbolReg = RegExp(r'[^A-Za-z0-9]');

  final _passwordLevel = PasswordLevel.Low.obs;
  final _confirmPasswordDifferent = false.obs; // 确认密码不一致
  final _vaildPasswordLength = false.obs;

  PasswordLevel get passwordLevel => _passwordLevel.value;

  bool get confirmPasswordDifferent => _confirmPasswordDifferent.value;

  bool get vaildPasswordLength => _vaildPasswordLength.value;

  final _pswMInLength = 6;
  final _pswMaxLength = 20;

  /// 是否可完成
  bool get canComplete => !confirmPasswordDifferent && vaildPasswordLength;

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      update();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);
    print("SetupPasswordController title ${Get.parameters["title"]}");
    passwordController.addListener(() {
      _updatePasswordLevel();
      _comparePassword();
    });
    confirmPasswordController.addListener(_comparePassword);
  }

  @override
  void onReady() {
    super.onReady();
    passwordFocusNode.requestFocus();
  }

  void _comparePassword() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    _confirmPasswordDifferent.value = password != confirmPassword;
    _vaildPasswordLength.value =
        passwordController.text.length >= _pswMInLength &&
            passwordController.text.length <= _pswMaxLength;
  }

  void _updatePasswordLevel() {
    final password = passwordController.text;
    if (password.length < 6) {
      _passwordLevel.value = PasswordLevel.Low;
    } else {
      var count = 0;
      if (_numberReg.hasMatch(password)) {
        count++;
      }
      if (_lowercaseReg.hasMatch(password)) {
        count++;
      }
      if (_uppercaseReg.hasMatch(password)) {
        count++;
      }
      if (_symbolReg.hasMatch(password)) {
        count++;
      }
      if (count >= 3) {
        _passwordLevel.value = PasswordLevel.High;
      } else if (count >= 2) {
        _passwordLevel.value = PasswordLevel.Medium;
      } else {
        _passwordLevel.value = PasswordLevel.Low;
      }
    }
  }

  /// 保存密码
  void savePassword() async {
    final password = passwordController.text;
    bool isBioPay = await SecurityService.to.isOpenBiometryPay;
    await SecurityService.to.setSecurityPassword(password, original: isBioPay);
    if (Get.parameters["password"] != null) {
      String passwordOld = Get.parameters["password"]!;
      List<Wallet> wallets = await DBService.service.walletDao.findAll();
      for (Wallet wallet in wallets) {
        if (wallet.mnemonic != null) {
          wallet.mnemonic =
              WalletCreateController.decrypt(wallet.mnemonic!, passwordOld);
          wallet.mnemonic =
              WalletCreateController.encrypt(wallet.mnemonic!, password);
          await DBService.service.walletDao.saveAndReturnId(wallet);
          if (WalletService.service.currentWallet != null) {
            if (WalletService.service.currentWallet!.id == wallet.id) {
              WalletService.service.currentWallet = wallet;
            }
          }
        }
      }
      List<Coin> coins = await DBService.service.coinDao.findAll();
      for (Coin coin in coins) {
        if (coin.privateKey != null) {
          coin.privateKey =
              WalletCreateController.decrypt(coin.privateKey!, passwordOld);
          coin.privateKey =
              WalletCreateController.encrypt(coin.privateKey!, password);
          await DBService.service.coinDao.saveAndReturnId(coin);
          if (WalletService.service.currentCoin != null) {
            if (WalletService.service.currentCoin!.id == coin.id) {
              WalletService.service.currentCoin = coin;
            }
          }
        }
      }
    }
    Get.back();
    if(Get.isRegistered<WalletManageController>()){
      Get.find<WalletManageController>().popDialog(password);
    }
  }
}
