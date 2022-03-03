import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/apis/api_urls.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/security_service.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

/// 启动页
class SplashView extends StatefulWidget {
  ///
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await precacheImage(
        AssetImage('assets/images/splash/icon_logo.png'.adaptAssetPath),
        context,
      );
      // await Future.delayed(const Duration(milliseconds: 1500));
      // if (await LocalService.to.getCurrentVersionFirstStartupTimestamp() ==
      //     null) {
      // } else {

     // await Get.offAllNamed(Routes.UCORE_HOME_NEWS);
     // return;

      await getApiHost();
      final isOpenBiometryLogin = await SecurityService.to.isOpenBiometryLogin;
      if (isOpenBiometryLogin) {
        // 解锁页面
        await Get.offAllNamed(Routes.UNLOCK);
      } else {
        // 主功能页面
        await Get.offAllNamed(Routes.HOME);
      }
      // }
    });
  }

  final prod =
      'https://blank-1304418020.cos.ap-guangzhou.myqcloud.com/blank-defi.json';
  final pre =
      'https://blank-1304418020.cos.ap-guangzhou.myqcloud.com/blank-faucet-pre.json';

  ///请求swap 白名单列表
  Future<void> getApiHost() async {
    try{
      HttpClient _linkClient = HttpClient();

      ResponseModel<Map> resultMap = await _linkClient
          .get<Map>(AppEnv.currentEnv() == AppEnvironments.prod ? prod : pre);

      if(resultMap.data != null){
        Map map = resultMap.data!;
        if(AppEnv.currentEnv() == AppEnvironments.prod){
          for (String tempStr in map['data']['aitdcoin']) {
            bool request = await requestApiHost(_linkClient, tempStr);
            if(request){
              return;
            }
          }
        }else{
          for (String tempStr in map['data']['aitdcoin-pre']) {
            bool request = await requestApiHost(_linkClient, tempStr);
            if(request){
              return;
            }
          }
        }
      }
    }catch(e){
      print(e);
    }
  }

  Future<bool> requestApiHost(HttpClient _linkClient, String tempStr) async {
    final baseUrl = EncryptUtils.decodeBase64(
      tempStr,
    );

    List<String> baseUrlList = [];
    int index = 0;
    // 以#分割 ，并把#前面第一个字母去掉
    for (String element in baseUrl.split("#")) {
      index++;
      if (index < baseUrl.split("#").length) {
        element = element.substring(1, element.length);
      }
      baseUrlList.add(element);
    }

    String tempUrl = baseUrlList.join(".");

    //验证URL
    ResponseModel<Map> result =
    await _linkClient.get<Map>("https://$tempUrl/api/wallet/v1/third/v2/get/coinRate");
    if (result.data != null && result.data!['code'] == 200) {
      ApiUrls.set('https://$tempUrl');
      return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                top: 298.h,
                left: 0,
                right: 0,
                child: SizedBox(
                  width: 114.h,
                  height: 175.h,
                  child: const WalletLoadAssetImage('splash/icon_logo'),
                ),
              ),
            ],
          )),
    );
  }
}
