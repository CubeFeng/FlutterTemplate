class MathToll {
  ///向下取精度
  static String stringKeepDown(String str, int count) {
    if(str.contains('e-')){
      return '0';
    }
    List<String> splits = str.split('.');
    if (splits.length == 2) {
      String dot = splits[1];
      if (dot.length > count) {
        return str.substring(0, str.length - (dot.length - count));
      }
    }
    return str;
  }

  ///向下取精度
  static String doubleKeepDown(double str, int count) {
    return stringKeepDown(str.toString(), count);
  }
}
