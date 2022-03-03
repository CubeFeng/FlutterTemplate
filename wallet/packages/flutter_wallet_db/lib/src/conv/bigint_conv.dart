part of 'conv.dart';

/// BigInt转换器
class BigIntConverter extends TypeConverter<BigInt?, String?> {
  @override
  BigInt? decode(String? databaseValue) =>
      databaseValue == null ? null : BigInt.tryParse(databaseValue);

  @override
  String? encode(BigInt? value) => value?.toString();
}
