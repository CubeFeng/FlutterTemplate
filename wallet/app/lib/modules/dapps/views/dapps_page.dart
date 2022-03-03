import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/models/swap_item_model.dart';
import 'package:flutter_wallet/models/wallet_banner_model.dart';
import 'package:flutter_wallet/modules/dapps/controllers/dapp_browser_controller.dart';
import 'package:flutter_wallet/modules/dapps/views/widgets/dapps_sticky_tabbar.dart';
import 'package:flutter_wallet/modules/dapps/views/widgets/dapps_tabbar_indicator.dart';
import 'package:flutter_wallet/modules/home/controllers/home_controller.dart';
import 'package:flutter_wallet/widgets/u_sliver_sticky_widget.dart';
import 'package:flutter_wallet/widgets/uni_refresh_nested_scrollview.dart';
import 'package:flutter_wallet/widgets/uni_scroll_behavior.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

import 'widgets/dapps_browser_banner.dart';
import 'widgets/dapps_browser_search_bar.dart';

///
class DappsPage extends StatelessWidget {
  DappsPage({Key? key}) : super(key: key);
  final DappBrowserController _controller = Get.put(DappBrowserController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DappBrowserController>(
        init: _controller,
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              titleSpacing: 0,
              // toolbarHeight: 44,
              backgroundColor: Colors.white,
              // elevation: 0,
              title: const DappsBrowserSearchBar(),
            ),
            body: _controller.tabs.isNotEmpty ? _buildOldContent():_emptyContentView(),
          );
        });
  }

  Widget _emptyContentView(){
    return GestureDetector(
      onTap: _controller.onReady,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 100.h),
            const SizedBox(
              width: 112,
              height: 89,
              child: WalletLoadImage("load/icon_load_nodata"),
            ),
            SizedBox(height: 40.h),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF666666),
              ),
              child: Text(I18nKeys.noContent),
            )
          ],
        ),),
    );
  }
  ///旧版内容
  RefreshIndicator _buildOldContent() {
    return RefreshIndicator(
      onRefresh: _controller.onReady,
      notificationPredicate: (notification) {
        // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
        if (notification is OverscrollNotification || Platform.isIOS) {
          return notification.depth == 2;
        }
        return notification.depth == 0;
      },
      child: NestedScrollView(
        controller: _controller.scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Column(
                key: _controller.headerGlobalKey,
                children: [
                  /// 轮播图
                  _buildBanner(_controller.bannerList),
                ],
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),

            DappsStickyTabBarWidget(
                mPadding: EdgeInsets.only(
                  left: _controller.contentPadding,
                  right: _controller.contentPadding,
                ),
                tabBarGlobalKey: _controller.tabBarGlobalKey,
                tabController: _controller.tabController,
                onTap: (index) {
                  _controller.tabbarIndex = index;
                },
                tabs: _controller.tabs.map((item) {
                  return Tab(text: item.name);
                }).toList()),

            /// TabBar
          ];
        },
        body: Container(
          color: Colors.white,
          child: Obx(() => Container(
                margin: EdgeInsets.symmetric(
                    horizontal: _controller.contentPadding),
                decoration: BoxDecoration(
                  color: Colors.white, // 底色
                  borderRadius: _controller.tabViewChildTopPadding > 40
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        )
                      : const BorderRadius.only(
                          topLeft: Radius.zero, topRight: Radius.zero),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(-10, -12),
                      blurRadius: 15, //阴影范围
                      spreadRadius: -5, //阴影浓度
                      color: const Color(0xFF000000).withOpacity(0.08),
                    ),
                    BoxShadow(
                      offset: const Offset(10, -12),
                      blurRadius: 15, //阴影范围
                      spreadRadius: -5, //阴影浓度
                      color: const Color(0xFF000000).withOpacity(0.08),
                    ),
                  ],
                ),
                child: TabBarView(
                  controller: _controller.tabController,
                  children: _controller.tabs.map(
                    (e) {
                      List<SwapItemModel> list =
                          _controller.swapItemMap[e.id!.toString()]!;
                      return Obx(
                        () => ScrollConfiguration(
                          behavior: NoSplashScrollBehavior(),
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                              top: _controller.tabViewChildTopPadding,
                              bottom:
                                  HomeController.to.bottomTabBarSize?.height ??
                                      0.0,
                            ),
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (_, index) {
                              return _listViewItem(list[index]);
                            },
                            // separatorBuilder: (_, index) {
                            //   return _listViewSeparator();
                            // },
                            itemCount: list.length,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              )),
        ),
      ),
    );
  }
  ///新版内容
  UniRefreshNestedScrollView _buildNewContent(){
    return UniRefreshNestedScrollView(
      onRefresh: _controller.onReady,
      refreshIndicatorBuilder:
          (BuildContext context, UniRefreshState state) {
        switch (state) {
          case UniRefreshState.normal:
            return Center(child: Text(I18nKeys.pull_down_to_refresh));
          case UniRefreshState.refreshing:
            return Center(
                child: Text(I18nKeys.data_is_being_refreshed));
        }
      },
      headerSliverBuilder:
          (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Column(
              key: _controller.headerGlobalKey,
              children: [
                /// 轮播图
                _buildBanner(_controller.bannerList),
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          DappsStickyTabBarWidget(
              mPadding: EdgeInsets.only(
                left: _controller.contentPadding,
                right: _controller.contentPadding,
              ),
              tabBarGlobalKey: _controller.tabBarGlobalKey,
              tabController: _controller.tabController,
              onTap: (index) {
                _controller.tabbarIndex = index;
              },
              tabs: _controller.tabs.map((item) {
                return Tab(text: item.name);
              }).toList()),
        ];
      },
      body: Container(
        color: Colors.white,
        child: Obx(() => Container(
          margin: EdgeInsets.symmetric(
              horizontal: _controller.contentPadding),
          decoration: BoxDecoration(
            color: Colors.white, // 底色
            borderRadius: _controller.tabViewChildTopPadding > 50
                ? const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            )
                : const BorderRadius.only(
                topLeft: Radius.zero, topRight: Radius.zero),
            boxShadow: [
              BoxShadow(
                offset: const Offset(-10, -12),
                blurRadius: 15, //阴影范围
                spreadRadius: -5, //阴影浓度
                color: const Color(0xFF000000).withOpacity(0.08),
              ),
              BoxShadow(
                offset: const Offset(10, -12),
                blurRadius: 15, //阴影范围
                spreadRadius: -5, //阴影浓度
                color: const Color(0xFF000000).withOpacity(0.08),
              ),
            ],
          ),
          child: TabBarView(
            controller: _controller.tabController,
            children: _controller.tabs.map(
                  (e) {
                List<SwapItemModel> list =
                _controller.swapItemMap[e.id!.toString()]!;
                return Obx(
                      () => ScrollConfiguration(
                    behavior: NoSplashScrollBehavior(),
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        top: _controller.tabViewChildTopPadding,
                        bottom: HomeController
                            .to.bottomTabBarSize?.height ??
                            0.0,
                      ),
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (_, index) {
                        return _listViewItem(list[index]);
                      },
                      // separatorBuilder: (_, index) {
                      //   return _listViewSeparator();
                      // },
                      itemCount: list.length,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        )),
      ),
    );
  }

  ListTile _listViewItem(SwapItemModel item) {
    // print("TabBar ListView 数据更新 item ${item.whiteLink}");
    return ListTile(
      leading: WalletLoadImage(item.iconUrl ?? "",
        fit: BoxFit.fitHeight,
        height: 60,
        width: 60,),
      title: Text(
        item.name ?? "",
        style: const TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        item.desc ?? "",
        style: const TextStyle(fontSize: 12, color: Colors.black54),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        _controller.browserListClickAction(item);
      },
    );
  }

  /// listView 分割线
  Padding _listViewSeparator() {
    return const Padding(
      padding: EdgeInsets.only(right: 20),
      child: Divider(
        // height: 1,
        indent: 80,
        thickness: .5,
        color: Colors.black12,
      ),
    );
  }

  Widget _buildBanner(List<WalletBannerModel> bannerList) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: BannerCarouselSlider(images: bannerList),
    );
  }
}

class RandomIconWidget extends StatelessWidget {
  const RandomIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, Random().nextInt(256) + 0,
            Random().nextInt(256) + 0, Random().nextInt(256) + 0),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
