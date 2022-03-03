import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/embed/embed_service.dart';
import 'package:flutter_wallet/generated/icon_font.g.dart';
import 'package:flutter_wallet/modules/dapps/views/dapps_page.dart';
import 'package:flutter_wallet/modules/home/controllers/home_controller.dart';
import 'package:flutter_wallet/modules/home/widgets/home_bottom_tabbar.dart';
import 'package:flutter_wallet/modules/property/views/property_view.dart';
import 'package:flutter_wallet/modules/settings/views/my_view.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/wallet_connect_service.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

///
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController get controller => Get.find();

  @override
  void initState() {
    super.initState();

    /// 预缓存tab icon svg
    IconFont.precacheSvg([IconFont.iconLiulanqiXz, IconFont.iconWodeXz]);

    /// 处理插件路由转发
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      EmbedService.to.tryEmbedForward();
    });
  }

  bool showConnectList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<HomeController>(
          init: controller,
          builder: (context) {
            List<ConnectService> list =
                WalletConnectService.service.getConnectedService();
            if(list.isEmpty){
              showConnectList = false;
            }
            return Stack(
              children: [
                TabBarView(
                  controller: controller.tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const PropertyView(),
                    DappsPage(),
                    MyView(),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Obx(() => _buildBottomTabBar()),
                ),
                list.isNotEmpty && showConnectList == false
                    ? Positioned(
                        right: 0,
                        bottom: 283,
                        child: InkWell(
                          onTap: () {
                            showConnectList = true;
                            controller.update();
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white, // 底色
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 0),
                                    //x,y轴
                                    color: const Color(0xFF000000)
                                        .withOpacity(0.08),
                                    //阴影颜色
                                    blurRadius: 5.w //投影距
                                    ),
                              ],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25.0),
                                  bottomLeft: Radius.circular(25.0)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 4.5,
                                ),
                                const WalletLoadAssetImage(
                                  'wallet/img_connect_count',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.fitHeight,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  '${list.length}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Color(0xFF333333)),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                              ],
                            ),
                          ),
                        ))
                    : Container(),
                showConnectList
                    ? InkWell(
                        onTap: () {
                          showConnectList = false;
                          controller.update();
                        },
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: const Color(0x66000000),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: list
                                  .map((e) => InkWell(
                                        onTap: () {
                                          showConnectList = false;
                                          controller.update();
                                          Get.toNamed(
                                              Routes.Dapp_Wallet_Connect_Detail,
                                              parameters: {
                                                "connectUrl": e.connectUrl
                                              });
                                        },
                                        child: Container(
                                          height: 50,
                                          margin: const EdgeInsets.only(top: 15),
                                          decoration: BoxDecoration(
                                            color: Colors.white, // 底色
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: const Offset(0, 0),
                                                  //x,y轴
                                                  color: const Color(0xFF000000)
                                                      .withOpacity(0.08),
                                                  //阴影颜色
                                                  blurRadius: 5.w //投影距
                                                  ),
                                            ],
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25.0),
                                                    bottomLeft:
                                                        Radius.circular(25.0)),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                width: 4.5,
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: WalletLoadImage(
                                                  e.getIcon(),
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              ConstrainedBox(
                                                constraints: const BoxConstraints(maxWidth: 128),
                                                child: Text(
                                                  e.getName(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFF333333),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  WalletConnectService.service
                                                      .remove(e);
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(6.0),
                                                  child: Icon(
                                                    Icons.close_sharp,
                                                    color: Color(0xFFCCCCCC),
                                                    size: 18,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            );
          }),
    );
  }

  Widget _buildBottomTabBar() {
    return HomeBottomTabBar(
      key: controller.bottomTabBarKey,
      controller: controller.tabController,
      tabs: [
        HomeTabItem(
            selectedIcon: IconFont.iconQianbaoXz,
            unSelectedIcon: IconFont.iconQianbaoHui,
            selected: controller.tabIndex == 0),
        HomeTabItem(
            selectedIcon: IconFont.iconLiulanqiXz,
            unSelectedIcon: IconFont.iconLiulanqiHui,
            selected: controller.tabIndex == 1),
        HomeTabItem(
            selectedIcon: IconFont.iconWodeXz,
            unSelectedIcon: IconFont.iconWodeHui,
            selected: controller.tabIndex == 2),
      ],
    );
  }
}
