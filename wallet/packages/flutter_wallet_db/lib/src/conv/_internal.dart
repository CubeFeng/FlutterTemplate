part of 'conv.dart';

/// 可映射的类型转换器混入
mixin _MixinMapperTypeConverter<T, S> {
  /// 映射
  Map<T, S> get mapper;

  Map<T, S>? _cacheMapper;
  Map<S, T>? _cacheReverseMapper;

  Map<T, S> get _mapper =>
      _cacheMapper ?? mapper.also((it) => _cacheMapper = it);

  /// 反向映射
  Map<S, T> get _reverseMapper =>
      _cacheReverseMapper ??
      Map.fromEntries(
        _mapper.entries.map((e) => MapEntry(e.value, e.key)),
      ).also((it) => _cacheReverseMapper = it);

  /// Converts the [databaseValue] of type [S] into [T]
  T? decode(S? databaseValue) =>
      databaseValue == null ? null : _reverseMapper[databaseValue];

  /// Converts the [value] of type [T] into the database-compatible type [S]
  S? encode(T? value) => value == null ? null : _mapper[value];
}
