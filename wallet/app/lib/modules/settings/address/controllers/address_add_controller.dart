import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/modules/property/base_transaction_controller.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

class AddressAddEditController extends GetxController {
  final nameController = TextEditingController();
  final addressController = TextEditingController();

  final _canSave = false.obs;
  final _selectedCoinType = QiRpcService().supportCoins.first.obs;

  bool get canSave => _canSave.value;

  QiCoinType get selectedCoinType => _selectedCoinType.value;

  List<QiCoinType> get supportCoinTypes => QiRpcService().supportCoins;

  Address? get editAddress => Get.arguments;

  bool get isEdit => editAddress != null;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(_updateCanSave);
    addressController.addListener(_updateCanSave);
    if (isEdit) {
      nameController.text = editAddress?.name ?? '';
      addressController.text = editAddress?.coinAddress ?? '';
      _selectedCoinType.value = QiCoinCode44.parse(editAddress?.coinType ?? '');
    }
  }

  void setSelectedCoinType(QiCoinType coinType) {
    _selectedCoinType.value = coinType;
  }

  Future<void> didSave() async {
    final address = editAddress == null ? Address() : editAddress!;
    DBService.to.addressDao.saveAndReturnId(
      address
        ..name = nameController.text
        ..coinAddress = addressController.text
        ..coinType = selectedCoinType.chainName()
        ..preHandle(),
    );
  }

  void _updateCanSave() {
    _canSave.value =
        nameController.text.isNotEmpty && BaseTransactionController.isAddress(addressController.text);
    // qiGenerateKeypairWithMnemonic(coinType: coinType, mnemonic: mnemonic)
  }

  void validateAddress(String address){
    if(address.isEmpty){
      Toast.show("地址不能为空");
    }
    addressController.text = address;
  }
}
