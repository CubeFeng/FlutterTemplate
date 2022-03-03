import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/modules/settings/system/views/system_option_modal.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/services/wallet_service.dart';

enum OptionType { Language, Currency, Node }

class SystemOptionsController extends GetxController {
  late var _langList = LocalService.to.supportedLanguageList;
  late var _currencyList = LocalService.to.supportedCurrencyList;
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    LocalService.to.currencyObservable.stream.listen((_) => update());
    LocalService.to.languageObservable.stream.listen((_) => _pageUpdate());
  }

  void _pageUpdate(){
    _langList = LocalService.to.supportedLanguageList;
    _currencyList = LocalService.to.supportedCurrencyList;
    update();
  }

  void showOptionListModal(OptionType optionType) {
    int index = 0;
    List<String> tempLit = [];
    String title;
    switch (optionType) {
      case OptionType.Language:
        title = I18nKeys.languages;
        for (Map map in _langList) {
          String name = map["name"].toString();

          if (LocalService.to.languageText == name) {
            selectedIndex.value = index;
          }
          index++;
          tempLit.add(name);
        }
        break;
      case OptionType.Currency:
        title = I18nKeys.currencyUnit;
        for (Map map in _currencyList) {
          String unit = map["unit"].toString();
          if (LocalService.to.currencyObservable.value == unit) {
            selectedIndex.value = index;
          }
          index++;
          tempLit.add("${map["symbol"].toString()} ${map["name"].toString()}");
        }
        break;
      case OptionType.Node:
        if (WalletService.service.currentCoin != null) {
          Get.toNamed(Routes.SETTINGS_NODE_LIST);
        } else {
          Get.toNamed(Routes.SETTINGS_NODE_COIN);
        }
        return;
    }
    Get.bottomSheet(
      SystemOptionModal(
        title: title,
        optionList: tempLit,
        selectedCallback: () {
          Get.back();
          switch (optionType) {
            case OptionType.Language:
              _switchLanguage();
              break;
            case OptionType.Currency:
              _switchCurrency();
              break;
          }
        },
      ),
    );
  }

  ///切换语言
  void _switchLanguage() {
    Map map = _langList[selectedIndex.value];
    LocalService.to.language = map["locales"];
  }

  ///切换货币
  void _switchCurrency() {
    Map map = _currencyList[selectedIndex.value];
    LocalService.to.currency = map["unit"];
  }
}
