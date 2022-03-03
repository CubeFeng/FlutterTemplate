part of 'conv.dart';


/// WalletSource转换器
class WalletSourceConverter extends TypeConverter<WalletSource?, int?>
    with _MixinMapperTypeConverter<WalletSource, int> {
  @override
  Map<WalletSource, int> get mapper => {
        WalletSource.CREATE: 0,
        WalletSource.IMPORT: 1,
      };
}
