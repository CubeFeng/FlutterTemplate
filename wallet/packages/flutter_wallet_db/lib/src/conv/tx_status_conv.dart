part of 'conv.dart';

/// TxStatus转换器
class TxStatusConverter extends TypeConverter<TxStatus?, int?>
    with _MixinMapperTypeConverter<TxStatus, int> {
  @override
  Map<TxStatus, int> get mapper => {
        TxStatus.PENDING: 0,
        TxStatus.SUCCEED: 1,
        TxStatus.FAILED: -1,
      };
}
