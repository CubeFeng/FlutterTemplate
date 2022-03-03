part of 'conv.dart';

/// DateTime转换器
class DateTimeConverter extends TypeConverter<DateTime?, int?> {
  @override
  DateTime? decode(int? databaseValue) => databaseValue == null
      ? null
      : DateTime.fromMicrosecondsSinceEpoch(databaseValue);

  @override
  int? encode(DateTime? value) => value?.microsecondsSinceEpoch;
}

class DateTimeNotNullConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) =>
      DateTime.fromMicrosecondsSinceEpoch(databaseValue);

  @override
  int encode(DateTime value) => value.microsecondsSinceEpoch;
}
