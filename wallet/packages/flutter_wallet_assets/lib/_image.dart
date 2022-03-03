part of 'flutter_wallet_assets.dart';

/// 图片加载（支持本地与网络图片）
///
/// [image] 图片本地路径/网络图片
/// [darkImage] 暗色模式图片
/// [width] 宽度
/// [height] 高度
class WalletLoadImage extends StatelessWidget {
  const WalletLoadImage(
    this.image, {
    this.darkImage,
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.format = ImageFormat.png,
    this.holderImg = 'common/placeholder',
    this.cacheWidth,
    this.cacheHeight,
    this.defaultImg,
  }) : super(key: key);

  final String image;
  final String? darkImage;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ImageFormat format;
  final String holderImg;
  final Widget? defaultImg;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty || image.startsWith('http')) {
      final Widget _image = WalletLoadAssetImage(
        holderImg,
        height: height,
        width: width,
        fit: fit,
      );
      return CachedNetworkImage(
        imageUrl: Get.isDarkMode ? darkImage ?? image : image,
        placeholder: (_, __) => defaultImg ?? _image,
        errorWidget: (_, __, dynamic error) => _image,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: cacheWidth,
        memCacheHeight: cacheHeight,
      );
    } else {
      return WalletLoadAssetImage(
        image,
        darkImage: darkImage,
        height: height,
        width: width,
        fit: fit,
        format: format,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      );
    }
  }
}

/// 加载本地资源图片
class WalletLoadAssetImage extends StatelessWidget {
  const WalletLoadAssetImage(
    this.image, {
    Key? key,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.fit,
    this.format = ImageFormat.png,
    this.color,
    this.darkImage,
  }) : super(key: key);

  final String image;
  final String? darkImage;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BoxFit? fit;
  final ImageFormat format;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageUtils.getImgPath(
        (Get.isDarkMode ? darkImage ?? image : image),
        format: format,
      ).adaptAssetPath,
      height: height,
      width: width,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      fit: fit,
      color: color,

      /// 忽略图片语义
      excludeFromSemantics: true,
    );
  }
}
