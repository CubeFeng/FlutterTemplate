import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

void main() {
  group('wallet db tests', () {
    late WalletDatabase db;

    setUp(() async {
      db = await $FloorWalletDatabase.inMemoryDatabaseBuilder().build();
    });

    tearDown(() async {
      await db.close();
    });

    test('test tb_address', () async {
      final address = Address(
        id: null,
        name: '天启AITD',
        coinType: 'AITD',
        coinAddress: '0xF76f238b5e0c6447c8E1e7a26CA38aDaA02FbfFE',
        remark: 'this a remark'
      );
      address.preHandle();
      final id = await db.addressDao.saveAndReturnId(address);
      address.id = id;
      final actual = await db.addressDao.findById(id);
      print('address: ' + address.toString());
      print('actual: ' + actual.toString());
      expect(actual, equals(address));
    });
  });
}
