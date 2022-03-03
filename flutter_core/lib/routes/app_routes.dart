part of 'app_pages.dart';

class Routes {
  Routes._();

  /// 启动页
  static const String SPLASH = '/splash';

  /// 引导页
  static const String GUIDE = '/guide';

  /// 主页
  static const String HOME = '/home';

  /// 资讯详细
  static const String NEWS = '/news';

  /// 多语言
  static const String SETTINGS_LANGUAGE = '/settings/language';

  /// 外观设置
  static const String SETTINGS_THEME = '/settings/theme';

  /// 第三方OAuth2授权
  static const String OAUTH2 = '/oauth2';

  /// RSS订阅源
  static const String RSS_CENTER = '/rss/center';

  /// RSS订阅号
  static const String RSS_SUBSCRIPTION = '/rss/subscription';

  /// 阅读历史
  static const String USER_READ_HISTORY = '/user/readHistory';

  /// 订阅主题
  static const String USER_MY_SUBSCRIPTIONS = '/user/mySubscriptions';

  static const String USER_LOGIN = '/user/login'; // 登录页面
  static const String USER_FACE_LOGIN = '/user/faceLogin'; // 人脸登录
  static const String USER_EMAIL_REGISTER = '/user/emailRegister'; // 邮箱注册
  static const String USER_FACE_REGISTER = '/user/faceRegister'; // 人脸注册
  static const String USER_FACE_INPUT = '/user/faceInput'; // 人脸录入
  static const String USER_RESET_PASSWORD = '/user/resetPassword'; //重置密码
  static const String USER_PROTOCOL = '/user/protocol'; // 用户协议
  static const String USER_CENTER = '/user/userCenter'; // 个人中心页面
  static const String USER_MODIFY_PWD = '/modifyPassword'; // 修改密码页面
  static const String USER_MY_AUTH = '/myAuthorization'; // 我的授权页面
  static const String USER_MESSAGE = '/user/message'; // 站内信
  static const String USER_MESSAGE_DETAIL = '/user/message/detail'; // 站内信详情页
  static const String HELP_CENTER = '/user/helpcenter'; // 帮助中心
  static const String HELP_CENTER_CHAT = '/user/helpcenter/chat'; // 帮助中心-客服
  static const String USER_MY_BINDING = '/user/myBinding'; //我的绑定
  static const String USER_EDIT_PROFILE = '/user/editProfile'; //编辑资料
  static const String USER_SET_NICKNAME = '/user/setNickname'; //设定昵称
  static const String USER_REALNAME_CHOOSE_CARD = '/user/realnameChooseCard'; //实名认证选择证件页
  static const String USER_REALNAME_MESSAGE = '/user/realnameMessage'; //实名认证信息
  static const String USER_LIVINGBODY_EXAMPLE_VIEW = '/user/RealNameLivingbodyExampleView'; //实名认证采集人脸样例
  static const String USER_AUTH_RESULT = '/user/RealNameAuthResultView'; //实名认证结果页
  static const String USER_BINDING_EMAIL = '/user/bindingEmail'; //绑定邮箱
  static const String USER_BINDING_SUCCESS = '/user/bindingSuccess'; //人脸绑定成功
  static const String USER_AUTHENTICATION_RESULT = '/user/authentication'; //实名认证等待页
  static const String FEED_BACK = '/user/feedBack'; //反馈
}
