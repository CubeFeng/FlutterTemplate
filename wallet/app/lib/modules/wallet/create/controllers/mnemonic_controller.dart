import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/models/wallet_importtype_model.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:get/get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';

///
class MnemonicController extends GetxController {
  // ignore: constant_identifier_names
  static const VERIFY_VIEW_ID = 0x1000;

  final WalletCreateType createType = getCreateType(Get.parameters["createType"]?? "hdCreate");

  ///
  late final Map<QiCoinType, QiCoinKeypair> keypairMaps = {};

  /// 支持的币种
  late final supportCoins = [QiCoinType.AITD, QiCoinType.ETH];

  /// 提示请勿截屏
  final isPromptNotToScreenshot = true.obs;

  /// 助记词
  late final mnemonics = qiGenerateMnemonic();

  /// 助记词列表
  List<String> get mnemonicList => mnemonics.split(' ');

  /// 乱序助记词列表
  late var _verifyMnemonicList = mnemonicList..shuffle();

  List<String> get verifyMnemonicList => _verifyMnemonicList;

  /// 待验证的助记词列表位置顺序
  late var _verifyPositionList = List.generate(mnemonicList.length, (index) => index + 1)..shuffle();

  List<int> get verifyTopThreePositionList => _verifyPositionList.sublist(0, 3);

  /// 待验证助记词索引
  final _verifyIndex = 0.obs;

  int get verifyIndex => _verifyIndex.value;

  /// 选中的助记词
  late var _selectedMnemonicList = ['', '', ''];

  List<String> get selectedMnemonicList => _selectedMnemonicList;

  /// 是否可以完成
  bool get canComplete => !selectedMnemonicList.contains('');

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

  /// 打乱助记词列表顺序
  void shuffleMnemonicList() {
    _verifyIndex.value = 0;
    _verifyMnemonicList = mnemonicList..shuffle();
    _verifyPositionList = List.generate(mnemonicList.length, (index) => index + 1)..shuffle();
    _selectedMnemonicList = ['', '', ''];
  }

  void setVerifyIndex(int index) {
    _verifyIndex.value = index;
  }

  void setMnemonic(int index, String mnemonic) {
    _selectedMnemonicList[index] = mnemonic;
    final newIndex = index + 1;
    setVerifyIndex(newIndex > 2 ? 0 : newIndex);
    update([VERIFY_VIEW_ID]);
  }

  void unsetMnemonic(int index) {
    _selectedMnemonicList[index] = '';
    update([VERIFY_VIEW_ID]);
  }

  void completeVerify() {
    var error = false;
    selectedMnemonicList.forEachIndexed((mnemonic, index) {
      final position = verifyTopThreePositionList[index];
      if (mnemonic != mnemonicList[position - 1]) {
        Get.showTopBanner(I18nKeys.inputErrorPleaseReEnter, style: TopBannerStyle.Error);
        error = true;
        return;
      }
    });
    if (!error) {
      Get.back();
      print("completeVerify ${Get.parameters["createType"].toString()}");
      Get.toNamed(Routes.WALLET_CREATE,
          parameters: {'inputText': mnemonics, "createType": createType.typeName});
    }
  }
}
