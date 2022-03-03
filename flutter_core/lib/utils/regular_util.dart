
///正则表达式工具
class RegularUtils {

  /// 判断密码是否符合规则
  static bool isPasswordLegal(String str) {
    return RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[^]{8,12}$')
        .hasMatch(str);
  }

  /// 判断邮箱地址是否符合规则
  static bool isEmailLegal(String str) {
    return RegExp(
        r'^[a-z0-9A-Z]+([-_.][a-z0-9A-Z]+)*@([a-z0-9A-Z]+[-.])+[A-Za-zd]{2,6}$')
        .hasMatch(str);
  }

}
