import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/widgets/toast.dart';
import 'package:flutter_wallet/models/wallet_importtype_model.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/api/generate_api.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:get/get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'dart:convert' as convert;
import 'package:flutter_wallet/utils/app_utils.dart';

///
class WalletImportController extends GetxController
    with SingleGetTickerProviderMixin, WidgetsBindingObserver {
  ///
  TextEditingController inputController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  final String fixMode = Get.parameters['fixMode'] ?? "";
  final chainName =
      Get.parameters['chainName'] ?? QiRpcService().coinType.chainName();
  late String titleStr;

  final inputFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  final obscureText = true.obs;

  WalletImportType importType =
      getImpType(Get.parameters['importType'] ?? "menmonic");
  WalletCreateType createType =
      getCreateType(Get.parameters['createType'] ?? "singleImport");

  final nextBtnStatus = false.obs;
  final agreementBtnStatus = false.obs;
  final showBottomWidgetStatus = false.obs;

  /// 助记词列表
  late List<String> _localWordList;

  /// 匹配的助记词列表
  late List<String> searchWordList = [];

  void _changeNextBtnStatus() {
    if (importType == WalletImportType.keyStore) {
      nextBtnStatus.value = (inputController.text.isNotEmpty &&
          agreementBtnStatus.value &&
          passwordController.text.length >= 6);
    } else {
      nextBtnStatus.value =
          (inputController.text.isNotEmpty && agreementBtnStatus.value);
    }
  }

  void clickAgremmentButton() {
    agreementBtnStatus.value = !agreementBtnStatus.value;
    _changeNextBtnStatus();
  }

  void _changeBottomWidgetAction() {
    showBottomWidgetStatus.value =
        (inputFocusNode.hasFocus || passwordFocusNode.hasFocus);
    print("changeBottomWidgetStatus ${showBottomWidgetStatus.value}");
  }

  ///读取本地的助记词列表
  void _getLocalWordList() async {
    print("读取单词库  bip39_english");

    var a = await WalletAssets.loadString('assets/data/bip39_english.txt');

    _localWordList = a.toString().split("\n");
  }

  void selectedWordAction(index) {
    if (index > searchWordList.length) {
      return;
    }

    var inputText = inputController.text;

    List<String> textList = inputText.split(" ");

    var lastedWord = textList.last.toString();


    var selectedWord = "${searchWordList[index]} ";

    inputText = inputText.replaceRange(
        inputText.length - lastedWord.length, inputText.length, selectedWord);

    inputController.text = inputText;

    inputController.value = TextEditingValue(
        text: inputText,
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: inputText.length)));

    searchWordList.clear();

    update();
  }

  void findWordsList() {
    searchWordList.clear();
    if (inputController.text.isEmpty) {
      update();
      return;
    }

    List<String> textList = inputController.text.split(" ");

    var lastedWord = textList.last.toString();

    if (lastedWord.isEmpty) {
      return;
    }

    searchWordList = _localWordList
        .where((text) => text.toString().startsWith(lastedWord))
        .toList();

    if (searchWordList.length > 6) {
      searchWordList = searchWordList.sublist(0, 6);
    }

    // print("输入的单词 ${searchWordList.length} $searchWordList");

    update();
  }

  void eyeAction(){
    obscureText.value = !obscureText.value;
  }

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
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance?.addObserver(this);
    titleStr = I18nRawKeys.importWallet.trPlaceholder([chainName]);

    if (importType == WalletImportType.menmonic) {
      titleStr = I18nKeys.importHdIdentityWallet;

      _getLocalWordList();
    }

    inputController.addListener(_changeNextBtnStatus);
    passwordController.addListener(_changeNextBtnStatus);

    inputFocusNode.addListener(_changeBottomWidgetAction);
    passwordFocusNode.addListener(_changeBottomWidgetAction);

    ///暂时写死
    // inputController.text = 'chimney refuse inspire language subway horror middle tube property knife garage exclude';
  }

  ///检查数字和字母
  bool _isNumberWithPrivaterKey(String str) {
    final reg = RegExp(r'^-?[0-9a-zA-z]+');
    return reg.hasMatch(str);
  }

  ///创建钱包
  void creatWalletAction() {

    AppUtils.hideKeyboard();

    String inputText = inputController.text;

    if (importType == WalletImportType.privatyKey) {
      if (!qiValidatePrivateKey(QiCoinCode44.parse(chainName) , inputText)) {
        Toast.showError(I18nKeys.privateKeyError);
        return;
      }
    } else if (importType == WalletImportType.keyStore) {

      try{
        final jsonString = convert.jsonDecode(inputText);
      }catch(_){
        Toast.showError(I18nKeys.pleaseEnterAValidKeystoreFile);
        return;
      }

      //TODO:判断密码是否正确
      if (passwordController.text.length < 6) {
        Toast.showError(I18nKeys.walletPwdErr);
        return;
      }
    } else if (importType == WalletImportType.menmonic) {
      List<String> textList = [];
      //筛选多个空格

      for (String text in inputText.split(" ")){
        text = text.replaceAll("\r", "");
        text = text.replaceAll("\n", "");
        text = text.trim();
        text = text.toLowerCase();
        if(text.isNotEmpty && text != " "){
          textList.add(text);
        }
      }

      inputText = textList.join(" ");

      if (textList.length != 12) {
        Toast.showError(I18nKeys.pleaseEnterTheCorrectMnemonic);
        return;
      }

      if (!qiValidateMnemonic(inputText)) {
        Toast.showError(I18nKeys.pleaseEnterTheCorrectMnemonic);
        return;
      }
    }

    Get.toNamed(Routes.WALLET_CREATE, parameters: {
      'inputText': inputText,
      "importType": importType.typeName,
      "createType": createType.typeName,
      "password": passwordController.text,
      "fixMode":fixMode,
      "chainName": chainName
    });
  }
}
