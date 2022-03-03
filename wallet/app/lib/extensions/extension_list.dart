extension ListExtensions<T> on List<T> {
  T getOr(int index, T defVal) {
    if (index < 0 || index > length - 1) {
      return defVal;
    }
    return this[index];
  }
}
