import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/settings/node/controller/node_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/theme/decorate_style.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:get/get.dart';

class NodeListView extends StatelessWidget {
  final controller = Get.put(NodeController());

  NodeListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (_) {
          return Scaffold(
            appBar: QiAppBar(
              title: Text(I18nKeys.selectNode),
              action: Get.isRegistered<NodeCoinController>()?Container():InkWell(
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.SETTINGS_NODE_COIN);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15),
                    child: Center(
                      child: Text(
                        I18nKeys.other,
                        style:
                            const TextStyle(fontSize: 15, color: Color(0xFF384A8B)),
                      ),
                    ),
                  )),
            ),
            body: ListView(
              children: [
                WalletLoadAssetImage(
                  'property/icon_node_network',
                  width: 112.w,
                  height: 89.w,
                ),
                Container(
                  decoration: DecorateStyles.decoration15,
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        I18nKeys.howToSelectNodes,
                        style:
                            const TextStyle(fontSize: 15, color: Color(0xFF333333)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        I18nKeys.keyDesc,
                        style:
                            const TextStyle(fontSize: 13, color: Color(0xFF333333)),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF42C53E), // 底色
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.5)),
                                ),
                                width: 9,
                                height: 9,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(I18nKeys.fast,
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF333333))),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF3B22E), // 底色
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.5)),
                                  ),
                                  width: 9,
                                  height: 9,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(I18nKeys.commonly,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF333333))),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF14F4F), // 底色
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.5)),
                                ),
                                width: 9,
                                height: 9,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(I18nKeys.slow,
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF333333))),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: DecorateStyles.decoration15,
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  margin:
                      const EdgeInsets.only(left: 15, bottom: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          I18nKeys.pleaseSelectANode,
                          style:
                              const TextStyle(fontSize: 15, color: Color(0xFF333333)),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: controller.coinConfig!.nodes
                            .map((e) => Column(
                                  children: [
                                    _buildDivider(),
                                    _buildOption(e),
                                  ],
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildOption(String node) {
    Uri? uri = Uri.tryParse(node);
    return InkWell(
      onTap: () {
        controller.selectNode(node);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Text(NodeController.getNodeName(controller.coin, node),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  width: 5,
                ),
                controller.isSelect(node)
                    ? WalletLoadAssetImage(
                        'wallet/icon_select',
                        width: 12.w,
                        height: 12.h,
                      )
                    : Container(),
                const Expanded(child: SizedBox.shrink()),
                controller.isError(node)
                    ? Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFCCCCCC), // 底色
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            ),
                            width: 6,
                            height: 6,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text('Error',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xff999999).withOpacity(0.8),
                              )),
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: controller.getColor(node),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(3)),
                            ),
                            width: 6,
                            height: 6,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(controller.getNodeTime(node),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xff999999).withOpacity(0.8),
                              )),
                        ],
                      )
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              children: [
                Expanded(
                  child: Text(uri != null ? (uri.scheme + "://" + uri.host) : '-',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xff999999),
                      )),
                ),
                controller.isError(node)
                    ? Container()
                    : Text(controller.getBlockHeight(node),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xff999999).withOpacity(0.8),
                        )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      color: const Color(0xff5E6992).withOpacity(0.1),
    );
  }
}
