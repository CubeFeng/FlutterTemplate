import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/wallet/export/controllers/wallet_export_controller.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/theme/text_style.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet/widgets/uni_button.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 导出钱包
class WalletExportView extends GetView<WalletExportController> {
  const WalletExportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QiAppBar(title: Obx(() => Text(controller.title))),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildExportView(),
                _buildQrCodeView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodeView() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 15, //阴影范围
                spreadRadius: 5, //阴影浓度
                offset: Offset.fromDirection(1, 3),
                color: const Color(0xFF000000).withOpacity(0.05), //阴影颜色
              )
            ],
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Text(I18nKeys.notes, style: TextStyles.textSize17Bold),
              Gaps.vGap20,
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: WalletLoadAssetImage("settings/lead_arrow"),
                  ),
                  Text(
                    I18nKeys.pleaseScan,
                    style: TextStyles.textSize14Bold,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13, top: 5),
                child: Text(
                  I18nKeys.qrCodeNotes,
                  style: TextStyles.textSize12,
                ),
              ),
              Gaps.vGap20,
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: WalletLoadAssetImage("settings/lead_arrow"),
                  ),
                  Text(
                    I18nKeys.ensurePerimeterSec,
                    style: TextStyles.textSize14Bold,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13, top: 5),
                child: Text(
                  I18nKeys.qrCodeSecNotes,
                  style: TextStyles.textSize12,
                ),
              ),
              Gaps.vGap50,
              Obx(
                () => controller.value.isEmpty
                    ? const SizedBox.shrink()
                    : Center(
                        child: ClipRRect(
                          borderRadius: controller.showOrHideQrCode
                              ? BorderRadius.zero
                              : BorderRadius.circular(16.0),
                          child: GestureDetector(
                            onTap: () => controller.switchShowOrHideQrCode(),
                            child: Stack(
                              children: [
                                QrImage(data: controller.value, size: 154),
                                controller.showOrHideQrCode
                                    ? const SizedBox.shrink()
                                    : BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 12,
                                          sigmaY: 12,
                                        ),
                                        child: Container(
                                          color: Colors.white.withOpacity(0.12),
                                          width: 154,
                                          height: 154,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              Gaps.vGap50,
            ],
          ),
        )
      ],
    );
  }

  Widget _buildExportView() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 15, //阴影范围
                spreadRadius: 5, //阴影浓度
                offset: Offset.fromDirection(1, 3),
                color: const Color(0xFF000000).withOpacity(0.05), //阴影颜色
              )
            ],
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(I18nKeys.notes, style: TextStyles.textSize17Bold),
              Gaps.vGap20,
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: WalletLoadAssetImage("settings/lead_arrow"),
                  ),
                  Text(I18nKeys.offLineSaving, style: TextStyles.textSize14Bold)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13, top: 5),
                child: Text(
                  I18nKeys.savedSecNotes,
                  style: TextStyles.textSize12,
                ),
              ),
              Gaps.vGap20,
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: WalletLoadAssetImage("settings/lead_arrow"),
                  ),
                  Text(I18nKeys.dontTransfer, style: TextStyles.textSize14Bold)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13, top: 5),
                child: Text(
                  I18nKeys.offlineScanQRCode,
                  style: TextStyles.textSize12,
                ),
              ),
              Gaps.vGap20,
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: WalletLoadAssetImage("settings/lead_arrow"),
                  ),
                  Text(I18nKeys.safekeeping, style: TextStyles.textSize14Bold)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13, top: 5),
                child: Text(
                  I18nRawKeys.aitdWalletExportLastNotes.trPlaceholder(
                      [controller.tabs.first, controller.tabs.first]),
                  style: TextStyles.textSize12,
                ),
              ),
              Gaps.vGap24,
              Container(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 15,
                  bottom: 15,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F8F8), // 底色
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                child: Obx(
                  () => Text(
                    controller.value.isEmpty
                        ? "Generating..."
                        : controller.value,
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                  ),
                ),
              ),
              Gaps.vGap24,
              Center(
                child: Obx(() => SizedBox(
                      height: 33.h,
                      child: UniButton(
                        style: UniButtonStyle.PrimaryLight,
                        onPressed: controller.value.isEmpty
                            ? null
                            : () {
                                Clipboard.setData(
                                  ClipboardData(text: controller.value),
                                );
                                Get.showTopBanner(I18nKeys.copySuc);
                              },
                        child: Text(
                          I18nKeys.copy,
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF), // 底色
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 3), //x,y轴
              color: const Color(0xFF000000).withOpacity(0.08), //阴影颜色
              blurRadius: 5.w //投影距
              ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      height: 40.h,
      width: 345.w,
      child: TabBar(
        indicator: CustomRRecTabIndicator(
          radius: 15,
          color: const Color(0XFF2750EB).withOpacity(0.05),
          borderColor: const Color(0XFF2750EB).withOpacity(0.2),
        ),
        labelColor: const Color(0XFF333333),
        labelStyle: const TextStyle(
            fontSize: 14,
            color: Color(0XFF333333),
            fontWeight: FontWeight.w700),
        unselectedLabelColor: const Color(0XFFCCCCCC),
        tabs: controller.tabs
            .map((e) => SizedBox(
                  width: double.infinity,
                  child: Center(child: Text(e)),
                ))
            .toList(),
        controller: controller.tabController,
      ),
    );
  }
}

class CustomRRecTabIndicator extends Decoration {
  /// Create an underline style selected tab indicator.
  ///
  /// The [borderSide] and [insets] arguments must not be null.
  const CustomRRecTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.width,
    this.radius,
    this.color,
    this.borderColor,
  });

  /// The color and weight of the horizontal line drawn below the selected tab.
  final BorderSide? borderSide;

  final double? radius;

  final double? width;

  final Color? color;
  final Color? borderColor;

  /// Locates the selected tab's underline relative to the tab's boundary.
  ///
  /// The [TabBar.indicatorSize] property can be used to define the
  /// tab indicator's bounds in terms of its (centered) tab widget with
  /// [TabIndicatorSize.label], or the entire tab with [TabIndicatorSize.tab].
  final EdgeInsetsGeometry? insets;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is CustomRRecTabIndicator) {
      return CustomRRecTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide!, borderSide!, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is CustomRRecTabIndicator) {
      return CustomRRecTabIndicator(
        borderSide: BorderSide.lerp(borderSide!, b.borderSide!, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _UnderlinePainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, onChanged);
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  final CustomRRecTabIndicator decoration;

  BorderSide get borderSide => decoration.borderSide!;

  EdgeInsetsGeometry get insets => decoration.insets!;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration? configuration) {
    assert(configuration != null);
    assert(configuration!.size != null);
    final Rect rect = offset & configuration!.size!;
    final RRect rRect =
        RRect.fromRectAndRadius(rect, Radius.circular(decoration.radius!));
    canvas.drawRRect(
        rRect,
        Paint()
          ..style = PaintingStyle.fill
          ..color = decoration.color ?? Colors.transparent);
    canvas.drawRRect(
        rRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = decoration.borderColor ?? Colors.transparent);
  }
}
