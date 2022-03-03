import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_wallet/models/wallet_banner_model.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

class BannerCarouselSlider extends StatelessWidget {
  const BannerCarouselSlider({Key? key, required this.images}) : super(key: key);

  final List<WalletBannerModel> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          // color: Colors.white, // 底色
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CarouselSlider.builder(
            unlimitedMode: true,
            slideBuilder: (index) {
              return Center(
                child: InkWell(
                  onTap: () {
                    print("点击的banner轮播图 ${images[index].link}");
                    String url = images[index].link!;
                    if (url.startsWith("http:") || url.startsWith("https:")) {
                      Get.toNamed(Routes.DAPPS_Web_BANNER, parameters: {'url': images[index].link!,"share":"share"});
                    } else {
                      // Toast.showError('请输入正确的Dapp地址!');
                    }
                  },
                  child: BannerItem(imageUrl: images[index].icon??""),
                ),
              );
            },
            slideIndicator: CircularStaticIndicator(
              itemSpacing: 10,
              indicatorRadius: 3,
              padding: const EdgeInsets.only(bottom: 12, right: 25),
              indicatorBorderColor: Colors.transparent,
              indicatorBorderWidth: 0,
              enableAnimation: true,
              currentIndicatorColor: Colors.white,
              indicatorBackgroundColor: Colors.white60,
            ),
            autoSliderTransitionTime: const Duration(milliseconds: 350),
            itemCount: images.length,
            initialPage: 0,
            enableAutoSlider: true,
          ),
        ),
      ),
    );
  }
}

class BannerItem extends StatelessWidget {
  final String imageUrl;

  const BannerItem({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
          width: double.infinity,
          child: WalletLoadImage(
            imageUrl,
            fit: BoxFit.cover,
          )),
    );
  }
}
