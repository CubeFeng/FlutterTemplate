part of 'conv.dart';

/// WalletType转换器
class WalletTypeConverter extends TypeConverter<WalletType?, int?>
    with _MixinMapperTypeConverter<WalletType, int> {
  @override
  Map<WalletType, int> get mapper => {
        WalletType.HD: 0,
        WalletType.MULTI_SIGN: 1,
        WalletType.NFC: 2,
        WalletType.SINGLE_CHAIN: 100,
      };
}
