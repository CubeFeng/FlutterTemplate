import 'package:flutter_ucore/middleware/auth_middleware.dart';
import 'package:flutter_ucore/modules/guide/views/guide_view.dart';
import 'package:flutter_ucore/modules/home/bindings/home_binding.dart';
import 'package:flutter_ucore/modules/home/views/home_view.dart';
import 'package:flutter_ucore/modules/login/bindings/face_input_binding.dart';
import 'package:flutter_ucore/modules/login/bindings/face_login_binding.dart';
import 'package:flutter_ucore/modules/login/bindings/face_register_binding.dart';
import 'package:flutter_ucore/modules/login/bindings/login_binding.dart';
import 'package:flutter_ucore/modules/login/bindings/register_binding.dart';
import 'package:flutter_ucore/modules/login/bindings/reset_password_binding.dart';
import 'package:flutter_ucore/modules/login/bindings/user_protocol_binding.dart';
import 'package:flutter_ucore/modules/login/views/face_input_view.dart';
import 'package:flutter_ucore/modules/login/views/face_login_view.dart';
import 'package:flutter_ucore/modules/login/views/face_register_view.dart';
import 'package:flutter_ucore/modules/login/views/login_view.dart';
import 'package:flutter_ucore/modules/login/views/register_view.dart';
import 'package:flutter_ucore/modules/login/views/reset_password_view.dart';
import 'package:flutter_ucore/modules/login/views/user_protocol_view.dart';
import 'package:flutter_ucore/modules/news/bindings/news_binding.dart';
import 'package:flutter_ucore/modules/news/views/news_view.dart';
import 'package:flutter_ucore/modules/oauth2/bindings/oauth2_bindings.dart';
import 'package:flutter_ucore/modules/oauth2/views/oauth2_view.dart';
import 'package:flutter_ucore/modules/rss/center/bindings/rss_center_binding.dart';
import 'package:flutter_ucore/modules/rss/center/views/rss_center_view.dart';
import 'package:flutter_ucore/modules/rss/subscription/bindings/rss_subscription_binding.dart';
import 'package:flutter_ucore/modules/rss/subscription/views/rss_subscription_view.dart';
import 'package:flutter_ucore/modules/settings/feedback/bindings/feedback_bindings.dart';
import 'package:flutter_ucore/modules/settings/feedback/views/feedback_page.dart';
import 'package:flutter_ucore/modules/settings/help_center/bindings/help_center_bindings.dart';
import 'package:flutter_ucore/modules/settings/help_center/bindings/help_chat_bindings.dart';
import 'package:flutter_ucore/modules/settings/help_center/views/help_center_page.dart';
import 'package:flutter_ucore/modules/settings/help_center/views/help_chat_page.dart';
import 'package:flutter_ucore/modules/settings/language/views/settings_language_view.dart';
import 'package:flutter_ucore/modules/settings/message/bindings/message_bindings.dart';
import 'package:flutter_ucore/modules/settings/message/views/message_detail_page.dart';
import 'package:flutter_ucore/modules/settings/message/views/message_page.dart';
import 'package:flutter_ucore/modules/settings/theme/views/settings_theme_view.dart';
import 'package:flutter_ucore/modules/splash/views/splash_view.dart';
import 'package:flutter_ucore/modules/user/bindings/authentication_result_binding.dart';
import 'package:flutter_ucore/modules/user/bindings/binding_email_binding.dart';
import 'package:flutter_ucore/modules/user/bindings/binding_success_binding.dart';
import 'package:flutter_ucore/modules/user/bindings/edit_profile_binding.dart';
import 'package:flutter_ucore/modules/user/bindings/modify_password_binding.dart';
import 'package:flutter_ucore/modules/user/bindings/my_binding_binding.dart';
import 'package:flutter_ucore/modules/user/bindings/real_name_message_binding.dart';
import 'package:flutter_ucore/modules/user/bindings/realname_auth_result_binding.dart';
import 'package:flutter_ucore/modules/user/bindings/set_nickname_binding.dart';
import 'package:flutter_ucore/modules/user/bindings/user_center_binding.dart';
import 'package:flutter_ucore/modules/user/my_authorization/bindings/my_authorization_binding.dart';
import 'package:flutter_ucore/modules/user/my_authorization/views/my_authorization_view.dart';
import 'package:flutter_ucore/modules/user/my_subscriptions/bindings/my_subscriptions_binding.dart';
import 'package:flutter_ucore/modules/user/my_subscriptions/views/my_subscriptions_view.dart';
import 'package:flutter_ucore/modules/user/read_history/bindings/read_history_binding.dart';
import 'package:flutter_ucore/modules/user/read_history/views/read_history_view.dart';
import 'package:flutter_ucore/modules/user/views/authentication_result_view.dart';
import 'package:flutter_ucore/modules/user/views/binding_email_view.dart';
import 'package:flutter_ucore/modules/user/views/binding_success_view.dart';
import 'package:flutter_ucore/modules/user/views/edit_profile_view.dart';
import 'package:flutter_ucore/modules/user/views/modify_password_view.dart';
import 'package:flutter_ucore/modules/user/views/my_binding_view.dart';
import 'package:flutter_ucore/modules/user/views/real_name_choose_card_view.dart';
import 'package:flutter_ucore/modules/user/views/real_name_message_view.dart';
import 'package:flutter_ucore/modules/user/views/realname_auth_result_view.dart';
import 'package:flutter_ucore/modules/user/views/realname_livingbody_example_view.dart';
import 'package:flutter_ucore/modules/user/views/set_nickname_view.dart';
import 'package:flutter_ucore/modules/user/views/user_center_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    /// 启动页
    GetPage<dynamic>(
      name: Routes.SPLASH,
      page: () => SplashView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      transition: Transition.fade,
    ),

    /// 引导页
    GetPage<dynamic>(
      name: Routes.GUIDE,
      page: () => GuideView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      transition: Transition.fade,
    ),

    /// 主页(初始页面)
    GetPage<dynamic>(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      transition: Transition.fade,
    ),

    /// 资讯详细
    GetPage<dynamic>(
      name: Routes.NEWS,
      page: () => NewsView(),
      binding: NewsBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 多语言
    GetPage<dynamic>(
      name: Routes.SETTINGS_LANGUAGE,
      page: () => SettingsLanguageView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 外观设置
    GetPage<dynamic>(
      name: Routes.SETTINGS_THEME,
      page: () => SettingsThemeView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 第三方OAuth2授权
    GetPage<dynamic>(
      name: Routes.OAUTH2,
      page: () => OAuth2View(),
      binding: OAuth2Binding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// RSS订阅源
    GetPage<dynamic>(
      name: Routes.RSS_CENTER,
      page: () => RssCenterView(),
      binding: RssCenterBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// RSS订阅号
    GetPage<dynamic>(
      name: Routes.RSS_SUBSCRIPTION,
      page: () => RssSubscriptionView(),
      binding: RssSubscriptionBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 阅读历史
    GetPage<dynamic>(
      name: Routes.USER_READ_HISTORY,
      page: () => ReadHistoryView(),
      binding: ReadHistoryBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureAuthMiddleware()],
    ),

    /// 订阅主题
    GetPage<dynamic>(
      name: Routes.USER_MY_SUBSCRIPTIONS,
      page: () => MySubscriptionsView(),
      binding: MySubscriptionsBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureAuthMiddleware()],
    ),

    /// 绑定
    GetPage<dynamic>(
      name: Routes.USER_MY_BINDING,
      page: () => MyBindingView(),
      binding: MyBindingBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureAuthMiddleware()],
    ),

    /// 登录
    GetPage<dynamic>(
      name: Routes.USER_LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    GetPage<dynamic>(
      name: Routes.USER_EMAIL_REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    GetPage<dynamic>(
      name: Routes.USER_FACE_INPUT,
      page: () => FaceInputView(),
      binding: FaceInputBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    GetPage<dynamic>(
      name: Routes.USER_FACE_LOGIN,
      page: () => FaceLoginView(),
      binding: FaceLoginBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    GetPage<dynamic>(
      name: Routes.USER_BINDING_EMAIL,
      page: () => BindingEmailView(),
      binding: BindingEmailBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    GetPage<dynamic>(
      name: Routes.USER_FACE_REGISTER,
      page: () => FaceRegisterView(),
      binding: FaceRegisterBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    GetPage<dynamic>(
      name: Routes.USER_RESET_PASSWORD,
      page: () => ResetPasswordView(),
      binding: RestPasswordBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),
    GetPage<dynamic>(
      name: Routes.USER_PROTOCOL,
      page: () => UserProtocolView(),
      binding: UserProtocolBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    GetPage<dynamic>(
      name: Routes.USER_CENTER,
      page: () => UserCenterView(),
      binding: UserCenterBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureAuthMiddleware()],
    ),

    ///实名认证选择证件
    GetPage<dynamic>(
      name: Routes.USER_REALNAME_CHOOSE_CARD,
      page: () => RealNameChooseCard(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureAuthMiddleware()],
    ),

    ///实名认证获取信息
    GetPage<dynamic>(
      name: Routes.USER_REALNAME_MESSAGE,
      page: () => RealNameMessageView(),
      binding: RealNameMessageBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureAuthMiddleware()],
    ),

    ///实名认证采集人脸样例
    GetPage<dynamic>(
      name: Routes.USER_LIVINGBODY_EXAMPLE_VIEW,
      page: () => RealNameLivingbodyExampleView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureAuthMiddleware()],
    ),

    ///实名认证结果页
    GetPage<dynamic>(
      name: Routes.USER_AUTH_RESULT,
      page: () => RealNameAuthResultView(),
      binding: RealNameAuthResultBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureAuthMiddleware()],
    ),

    GetPage<dynamic>(
      name: Routes.USER_MODIFY_PWD,
      page: () => ModifyPasswordView(),
      binding: ModifyPasswordBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureAuthMiddleware()],
    ),

    GetPage<dynamic>(
      name: Routes.USER_MY_AUTH,
      page: () => MyAuthorizationView(),
      binding: MyAuthorizationBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureAuthMiddleware()],
    ),

    GetPage<dynamic>(
      name: Routes.USER_MESSAGE,
      page: () => MessagePage(),
      binding: MessageBinding(),
      middlewares: [EnsureAuthMiddleware()],
    ),

    GetPage<dynamic>(
      name: Routes.USER_EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureAuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: Routes.USER_MESSAGE_DETAIL,
      page: () => MessageDetailPage(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    GetPage<dynamic>(
      name: Routes.USER_SET_NICKNAME,
      page: () => SetNicknameView(),
      binding: SetNicknameBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureAuthMiddleware()],
    ),

    GetPage<dynamic>(
        name: Routes.HELP_CENTER,
        page: () => HelpCenterPage(),
        binding: HelpCenterBinding(),
        participatesInRootNavigator: true,
        preventDuplicates: false),

    GetPage<dynamic>(
      name: Routes.HELP_CENTER_CHAT,
      page: () => HelpChatPage(),
      binding: HelpChatBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: false,
    ),
    GetPage<dynamic>(
      name: Routes.USER_BINDING_SUCCESS,
      page: () => BindingSuccessView(),
      binding: BindingSuccessBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    GetPage<dynamic>(
      name: Routes.USER_AUTHENTICATION_RESULT,
      page: () => AuthenticationResultView(),
      binding: AuthenticationResultBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    /// 意见反馈
    GetPage<dynamic>(
      name: Routes.FEED_BACK,
      page: () => FeedbackPage(),
      binding: FeedbackBindings(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureAuthMiddleware()],
    ),
  ];
}
