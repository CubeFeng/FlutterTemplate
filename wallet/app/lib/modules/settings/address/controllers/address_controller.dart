import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

class AddressController extends GetxController {
  final addressList = <Address>[].obs;

  @override
  void onInit() async {
    super.onInit();
    addressList.value = await DBService.to.addressDao.findAll();
  }

  void requestUpdate() async {
    addressList.value = await DBService.to.addressDao.findAll();
  }

  void didDelete(Address address) async {
    await DBService.to.addressDao.deleteAndReturnChangedRows(address);
    addressList.value = await DBService.to.addressDao.findAll();
  }
}
