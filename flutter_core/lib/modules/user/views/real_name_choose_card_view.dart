import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/user_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/auth_service.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';
import 'package:url_launcher/url_launcher.dart';

class RealNameChooseCard extends StatefulWidget {
  @override
  _RealNameChooseCardState createState() => _RealNameChooseCardState();
}

class _RealNameChooseCardState extends State<RealNameChooseCard>
    with WidgetsBindingObserver {
  /// 第三方AppUrlSchemes，不为空时是第三方App调起的
  String? _thirdAppUrlSchemes = null;

  /// userId，不为空时是第三方App调起的
  String? _userId = null;

  @override
  void initState() {
    super.initState();
    _thirdAppUrlSchemes = Get.parameters["thirdAppUrlSchemes"];
    _userId = Get.parameters["userId"];
    // 第三方App调起的实名认证才检查账号一致性
    if (_userId != null) {
      _checkUserIdentical();
    }
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused &&
        Get.currentRoute.startsWith(Routes.USER_REALNAME_CHOOSE_CARD) &&
        _thirdAppUrlSchemes != null) {
      _cancelRealAuth(_thirdAppUrlSchemes!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _thirdAppUrlSchemes == null
          ? null
          : () async {
              _cancelRealAuth(_thirdAppUrlSchemes!);
              return false;
            },
      child: Stack(
        children: [
          Container(
            width: 1.sw,
            height: 1.sh,
            color: Colours.primary_bg,
            child: LoadAssetImage(
              'realname/icon_card_choose',
              fit: BoxFit.fill,
              width: 1.sw,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                I18nKeys.realname_authentication,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colours.primary_bg,
                  fontSize: 18,
                  decoration: TextDecoration.none,
                ),
              ),
              centerTitle: true,
              leading: Container(
                padding: const EdgeInsets.all(18.0),
                child: InkWell(
                  child: const LoadAssetImage(
                    'common/icon_arrow_white_left',
                    fit: BoxFit.contain,
                  ),
                  onTap: () {
                    if (_thirdAppUrlSchemes != null) {
                      _cancelRealAuth(_thirdAppUrlSchemes!);
                    } else {
                      Navigator.pop(context, '');
                    }
                  },
                ),
              ),
            ),
          ),
          Container(
            width: 1.sw,
            padding: EdgeInsets.only(
              top: 48.0 + ScreenUtil().statusBarHeight + 30,
              bottom: 48,
              left: 16,
              right: 16,
            ),
            child: Text(
              I18nKeys.please_select_the_type_of_authentication_id,
              maxLines: 2,
              style: TextStyle(
                color: Color(0xFFffffff),
                fontWeight: FontWeight.bold,
                fontSize: 18,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 136.0 + ScreenUtil().statusBarHeight),
            child: Column(
              children: [
                // 1:国内身份证 0:护照 3:其他证件 2:其他国家身份证, 4: 港澳台身份证
                GestureDetector(
                    child: GetListViewChildrenView(
                      icon: 'realname/icon_card_cn',
                      title: _thirdAppUrlSchemes == null
                          ? I18nKeys.mainland_id_card_cn
                          : "ID CARD",
                      desc: '',
                    ),
                    onTap: () {
                      Get.toNamed(
                        Routes.USER_REALNAME_MESSAGE,
                        arguments: 1,
                        parameters: _thirdAppUrlSchemes == null
                            ? null
                            : {
                                "thirdAppUrlSchemes": _thirdAppUrlSchemes!,
                                "userId": _userId!
                              },
                      );
                    }),
                GestureDetector(
                    child: GetListViewChildrenView(
                        icon: 'realname/icon_card_cn',
                        title: I18nKeys.hk_macao_and_taiwan_identity_card_cn,
                        desc: ''),
                    onTap: () {
                      Get.toNamed(
                        Routes.USER_REALNAME_MESSAGE,
                        arguments: 4,
                        parameters: _thirdAppUrlSchemes == null
                            ? null
                            : {
                                "thirdAppUrlSchemes": _thirdAppUrlSchemes!,
                                "userId": _userId ?? ""
                              },
                      );
                    }),
                GestureDetector(
                    child: GetListViewChildrenView(
                        icon: 'realname/icon_card_passport',
                        title: I18nKeys.passport,
                        desc: I18nKeys.passpore_desc),
                    onTap: () {
                      Get.toNamed(
                        Routes.USER_REALNAME_MESSAGE,
                        arguments: 0,
                        parameters: _thirdAppUrlSchemes == null
                            ? null
                            : {
                                "thirdAppUrlSchemes": _thirdAppUrlSchemes!,
                                "userId": _userId ?? ""
                              },
                      );
                    }),
                GestureDetector(
                    child: GetListViewChildrenView(
                        icon: 'realname/icon_card_otherc',
                        title: I18nKeys.id_card_of_other_countries,
                        desc: ''),
                    onTap: () {
                      Get.toNamed(
                        Routes.USER_REALNAME_MESSAGE,
                        arguments: 2,
                        parameters: _thirdAppUrlSchemes == null
                            ? null
                            : {
                                "thirdAppUrlSchemes": _thirdAppUrlSchemes!,
                                "userId": _userId ?? ""
                              },
                      );
                    }),
                GestureDetector(
                    child: GetListViewChildrenView(
                        icon: 'realname/icon_card_other',
                        title: I18nKeys.other_documents,
                        desc: ''),
                    onTap: () {
                      Get.toNamed(
                        Routes.USER_REALNAME_MESSAGE,
                        arguments: 3,
                        parameters: _thirdAppUrlSchemes == null
                            ? null
                            : {
                                "thirdAppUrlSchemes": _thirdAppUrlSchemes!,
                                "userId": _userId ?? ""
                              },
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 检查账号一致性
  void _checkUserIdentical() {
    final loginUserId = AuthService.to.userModel?.userId;
    if (_userId != loginUserId) {
      // 当前认证账号不一致，请先切换账号
      logger.d("===================当前认证账号不一致，请先切换账号");
      logger.d("===================_userId: ${_userId}");
      logger.d("===================loginUserId: ${loginUserId}");
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _showWarningModal(context);
      });
    }
  }

  /// 显示账号信息不一致弹窗
  void _showWarningModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return WillPopScope(
          onWillPop: () async => false,
          child: _WarningModal(
            onCancel: () {
              Get.back();
              _cancelRealAuth(_thirdAppUrlSchemes!);
            },
            onConfirm: () async {
              var next = false;
              if (AuthService.to.isLoggedInValue) {
                Toast.showLoading();
                final result = await UserApi.userLoginOut();
                Toast.hideLoading();
                next = result.code == 0 && (result.data ?? false);
                if (!next) {
                  Toast.show(result.message ?? '');
                }
              } else {
                next = true;
              }
              if (next) {
                AuthService.to.logout();
                Get.back();
                // 跳转登录页面
                await Get.toNamed(
                  Routes.USER_LOGIN,
                  parameters: {
                    "thirdAppUrlSchemes": _thirdAppUrlSchemes!,
                    "userId": _userId ?? ""
                  },
                );
                _checkUserIdentical();
              }
            },
          ),
        );
      },
    );
  }

  void _goBack() {
    WidgetsBinding.instance?.removeObserver(this);
    Get.back();
  }

  void _cancelRealAuth(String urlSchemes) {
    _goBack();
    _backToThirdApp(urlSchemes);
  }

  Future<void> _backToThirdApp(String urlSchemes) async {
    final url = urlSchemes.contains("://")
        ? "${urlSchemes}?Appback="
        : "${urlSchemes}://?Appback=";
    logger.d("launch url=$url");
    final isCanLaunch = await canLaunch(url);
    logger.d("isCanLaunch=$isCanLaunch");
    launch(url)
        .then((value) => logger.d("launch.result=$value"))
        .catchError((err) => logger.d("launch.err=$err"));
  }
}

class GetListViewChildrenView extends StatelessWidget {
  const GetListViewChildrenView({
    Key? key,
    this.title,
    this.icon,
    this.desc,
  }) : super(key: key);

  final String? title; //button的点击事件
  final String? icon;
  final String? desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      constraints: const BoxConstraints(minHeight: 78.0),
      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            color: Colours.primary_bg,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gaps.hGap15,
              LoadAssetImage(
                icon ?? '',
                fit: BoxFit.fill,
                height: 31,
                width: 31,
              ),
              Gaps.hGap10,
              ConstrainedBox(
                constraints: const BoxConstraints(
                    minHeight: 0, minWidth: 0, maxHeight: 80, maxWidth: 200),
                child: Text(
                  title ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colours.primary_text,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gaps.hGap4,
              Expanded(
                  child: Text(
                desc ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colours.tertiary_text,
                  decoration: TextDecoration.none,
                ),
              )),
              Container(
                height: 25,
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colours.tertiary_text,
                  size: 15,
                ),
              ),
              Gaps.hGap15,
            ],
          ),
        ),
      ),
    );
  }
}

class _WarningModal extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _WarningModal({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 198,
        width: 1.sw * 0.872,
        decoration: BoxDecoration(
          color: Colours.primary_bg,
          borderRadius: BorderRadius.circular(8.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          child: Column(
            children: [
              Container(
                height: 54,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 24, left: 25),
                child: Text(
                  I18nKeys.logout_Tips,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colours.text,
                  ),
                ),
              ),
              Container(
                height: 70,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Text(
                  I18nKeys.account_is_inconsistent,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colours.secondary_text,
                  ),
                ),
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  UCoreButton.outline(
                    minHeight: 44,
                    minWidth: 130,
                    text: I18nKeys.cancel,
                    onPressed: onCancel,
                  ),
                  UCoreButton(
                    minHeight: 44,
                    minWidth: 130,
                    text: I18nKeys.confirm,
                    onPressed: onConfirm,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
