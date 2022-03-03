import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/extensions/extension_get.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/models/transaction_info_model.dart';
import 'package:flutter_wallet/modules/property/base_record_view.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/theme/decorate_style.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/widgets/qi_app_bar.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';

///
class RecordDetailView extends StatefulWidget {
  const RecordDetailView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetailView();
  }
}

class DetailView extends State<RecordDetailView> {
  late TransactionInfoModel item;
  String? unit, image;

  @override
  void initState() {
    super.initState();
    item = Get.arguments;
    unit = Get.parameters['unit'];
    image = Get.parameters['image'];
    int decimals = WalletService.service.currentCoin!.coinDecimals!;
    QiRpcService().getTransactionStatus(item.txHash!).then((value) {
      if (value == null) {
        return;
      }
      QiRpcService().getTransactionByHash(item.txHash!).then((transaction) {
        if (transaction == null) {
          return;
        }
        setState(() {
          item.blockNumber = value.blockNumber.blockNum;
          item.minerFee = (value.gasUsed! *
                  transaction.gasPrice.getInWei /
                  BigInt.from(pow(10, decimals)))
              .toStringAsFixed(6);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPay =
        item.fromAddr == WalletService.service.currentCoin!.coinAddress;
    return Scaffold(
      appBar: QiAppBar(
        title: Text(I18nKeys.billingDetail),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: image != null ? 96 : 206.0.w,
              child: Container(
                margin: const EdgeInsets.only(left: 12, right: 12),
                decoration: DecorateStyles.decoration15,
                width: 351.w,
                height: 346.w,
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 36.w,
                    ),
                    _leftRightText(I18nKeys.finishTime, item.getTime()),
                    divider(),
                    _leftRightText(
                        I18nKeys.miningLaborFee,
                        (item.minerFee ?? "") +
                            " " +
                            (WalletService.service.currentCoin!.coinUnit!)),
                    divider(),
                    _leftRightText(
                        I18nKeys.blockHeight, '${item.blockNumber ?? ""}'),
                    divider(),
                    InkWell(
                        onTap: () {
                          setDataToastMsg(item.txHash ?? "");
                        },
                        child: _leftRightText(
                            I18nKeys.transactionId, item.txHash ?? "")),
                    divider(),
                    InkWell(
                      onTap: () {
                        final String httpUrlStr;
                        if (QiRpcService().coinType == QiCoinType.AITD) {
                          if (AppEnv.currentEnv() == AppEnvironments.prod) {
                            httpUrlStr =
                                "http://120.78.93.87/coin/explorer?path=" +
                                    Uri.encodeFull("/tx/" + item.txHash!);
                          } else {
                            httpUrlStr =
                                "http://120.78.93.87/coin/explorer-pre?path=" +
                                    Uri.encodeFull("/tx/" + item.txHash!);
                          }
                        } else if (QiRpcService().coinType == QiCoinType.ETH) {
                          if (AppEnv.currentEnv() == AppEnvironments.prod) {
                            httpUrlStr = "https://eth.tokenview.com/cn/tx/" +
                                item.txHash!;
                          } else {
                            httpUrlStr =
                                "https://eth-explorer-pre.aitd.io/tx/" +
                                    item.txHash!;
                          }
                        } else if (QiRpcService().coinType == QiCoinType.BTC) {
                          if (AppEnv.currentEnv() == AppEnvironments.prod) {
                            httpUrlStr = "https://btc.tokenview.com/cn/tx/" +
                                item.txHash!;
                          } else {
                            httpUrlStr =
                                "http://192.168.1.16:8200/#/BTC/regtest/tx/" +
                                    item.txHash!;
                          }
                        } else if (QiRpcService().coinType == QiCoinType.SOL) {
                          if (AppEnv.currentEnv() == AppEnvironments.prod) {
                            httpUrlStr =
                                "https://explorer.solana.com/tx/" +
                                    item.txHash! + '?cluster=testnet';
                          } else {
                            httpUrlStr =
                                "https://explorer.solana.com/tx/" +
                                    item.txHash! + '?cluster=testnet';
                          }
                        } else {
                          httpUrlStr = 'https://tokenview.com/cn/search/';
                        }
                        print(httpUrlStr);
                        Get.toNamed(Routes.DAPPS_Web_BANNER,
                            parameters: {'url': httpUrlStr});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              I18nKeys.pleaseCheckTheBlockDetailsForMoreDetails,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xff4B5A91),
                              ),
                            ),
                            Gaps.vGap9,
                            WalletLoadAssetImage(
                              'common/icon_arrow_right',
                              height: 19.sp,
                              color: const Color(0xFF4B5A91),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            image != null
                ? Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(left: 12, right: 12, top: 30),
                        width: double.infinity,
                        height: 100.w,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 3),
                                //x,y轴
                                color:
                                    const Color(0xFF000000).withOpacity(0.08),
                                //阴影颜色
                                blurRadius: 5.w //投影距
                                ),
                          ],
                          image: const DecorationImage(
                            image: AssetImage(
                                'packages/flutter_wallet_assets/assets/images/property/img_nft_transfer.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Gaps.vGap8,
                            Positioned(
                              top: 15,
                              left: 15,
                              child: Text(
                                I18nKeys.sellers,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333)),
                              ),
                            ),
                            Positioned(
                              left: 15,
                              top: 42,
                              child: InkWell(
                                onTap: () {
                                  setDataToastMsg(item.fromAddr ?? "");
                                },
                                child: SizedBox(
                                  width: 118.w,
                                  child: Text(
                                    item.fromAddr ?? "",
                                    style: const TextStyle(
                                        fontSize: 12, color: Color(0xFF666666)),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 15,
                              top: 15,
                              child: Text(
                                I18nKeys.purchaser,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333)),
                              ),
                            ),
                            Positioned(
                              right: 15,
                              top: 42,
                              child: InkWell(
                                onTap: () {
                                  setDataToastMsg(item.toAddr ?? "");
                                },
                                child: SizedBox(
                                  width: 118,
                                  child: Text(
                                    item.toAddr ?? "",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontSize: 12, color: Color(0xFF666666)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: WalletLoadImage(
                          image!,
                          width: 50.w,
                          height: 50.w,
                        ),
                      ),
                    ],
                  )
                : Container(
                    margin: const EdgeInsets.only(left: 12, right: 12, top: 24),
                    width: double.infinity,
                    height: 226,
                    decoration: DecorateStyles.decoration15,
                    child: Column(
                      children: [
                        Gaps.vGap8,
                        Image.asset(
                          isPay
                              ? 'packages/flutter_wallet_assets/assets/images/property/icon_transaction_out.png'
                              : 'packages/flutter_wallet_assets/assets/images/property/icon_transaction_in.png',
                          width: 50.w,
                          height: 50.w,
                        ),
                        Gaps.vGap9,
                        Text(
                          isPay ? I18nKeys.transferTo : I18nKeys.receiveFrom,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF999999)),
                        ),
                        Gaps.vGap9,
                        InkWell(
                          onTap: () {
                            setDataToastMsg(isPay
                                ? item.toAddr ?? ""
                                : item.fromAddr ?? "");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isPay ? item.toAddr ?? "" : item.fromAddr ?? "",
                                style: const TextStyle(
                                    fontSize: 13, color: Color(0xFF999999)),
                              ),
                              Gaps.vGap4,
                              Image.asset(
                                'packages/flutter_wallet_assets/assets/images/property/icon_copy.png',
                                width: 10.w,
                                height: 10.w,
                              ),
                            ],
                          ),
                        ),
                        Gaps.vGap20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (isPay ? "-" : "+") + (item.amount ?? "1"),
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isPay
                                      ? const Color(0xFF333333)
                                      : const Color(0xFF41B449)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Text(
                                unit ?? item.coin!,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isPay
                                        ? const Color(0xFF333333)
                                        : const Color(0xFF41B449)),
                              ),
                            ),
                          ],
                        ),
                        Gaps.vGap5,
                        Text(
                          '≈ ' +
                              LocalService.to.currencySymbol +
                              WalletService.service
                                  .getCurrencyBalance(
                                      double.parse(item.amount ?? "1"),
                                      WalletService.service.currentCoin!,
                                      item.contractAddress)
                                  .toStringAsFixed(2),
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF999999)),
                        ),
                        Gaps.vGap10,
                        Text(
                          item.status == 3
                              ? I18nKeys.tradeSuc
                              : (item.status == -1
                                  ? I18nKeys.fail
                                  : I18nKeys.confirmationInProgress),
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333)),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

Widget _leftRightText(
  String left,
  String right,
) {
  return Padding(
    padding: const EdgeInsets.only(top: 15, bottom: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xff333333),
          ),
        ),
        Gaps.vGap9,
        SizedBox(
          width: 200,
          child: Text(
            right,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff333333),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget divider() {
  return SizedBox(
    height: 1.h,
    child: Container(
      color: const Color(0xff5E6992).withOpacity(0.05),
    ),
  );
}

//复制内容
setDataToastMsg(String data, {String toastMsg = ''}) {
  if (toastMsg.isEmpty) {
    toastMsg = I18nKeys.copySuc;
  }
  Clipboard.setData(ClipboardData(text: data));
  Get.showTopBanner(toastMsg);
}

///中间省略内容的文本
class AddressText extends Text {
  @override
  // ignore: overridden_fields
  final String data;
  final Color? color;
  final double? fontSize;

  final RenderParagraph __renderParagraph = RenderParagraph(
    const TextSpan(
      text: "",
      style: TextStyle(
        fontSize: 13,
      ),
    ),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );

  AddressText(this.data, {Key? key, this.color, this.fontSize})
      : super(data, key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, boxConstraint) {
      return Text(
        _finalString(boxConstraint.maxWidth, data),
        style: TextStyle(
            color: color ?? const Color(0xFFFFFFFF),
            fontSize: fontSize ?? 13.0),
        maxLines: 1,
      );
    });
  }

  RenderParagraph _renderParagraph(String text) {
    __renderParagraph.text = TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize ?? 13.0,
      ),
    );
    return __renderParagraph;
  }

  String _finalString(double maxWidth, String text) {
    int startIndex = 0;
    int endIndex = text.length;
    // 计算当前text的宽度
    double width = _renderParagraph(text)
        .computeMinIntrinsicWidth(style?.fontSize ?? 13.0);
    // 当前text的宽度小于最大宽度，直接返回
    if (width < maxWidth) return text;
    // 计算...的宽度
    double ellipsisWidth = _renderParagraph("...")
        .computeMinIntrinsicWidth(style?.fontSize ?? 13.0);
    double leftWidth = (maxWidth - ellipsisWidth) * 0.5;
    int s = startIndex, e = endIndex;
    // 计算显示...的开始位置
    while (s < e) {
      int m = ((s + e) * 0.5).floor();
      double width = _renderParagraph(text.substring(0, m))
          .computeMinIntrinsicWidth(style?.fontSize ?? 13.0);
      if (width > leftWidth) {
        e = m;
      } else {
        s = m;
      }
      if (e - s <= 1) {
        startIndex = s;
        break;
      }
    }

    s = startIndex;
    e = endIndex;
    // 计算显示...的结束位置
    while (s < e) {
      int m = ((s + e) * 0.5).ceil();
      double width = _renderParagraph(text.substring(m, endIndex))
          .computeMinIntrinsicWidth(style?.fontSize ?? 13.0);
      if (width > leftWidth) {
        s = m;
      } else {
        e = m;
      }
      if (e - s <= 1) {
        endIndex = e;
        break;
      }
    }
    double leftW = _renderParagraph(text.substring(0, startIndex))
        .computeMinIntrinsicWidth(style?.fontSize ?? 13.0);
    double rightW = _renderParagraph(text.substring(endIndex, text.length))
        .computeMinIntrinsicWidth(style?.fontSize ?? 13.0);

    double margin = maxWidth - leftW - rightW - ellipsisWidth;
    double startNext =
        _renderParagraph(text.substring(startIndex, startIndex + 1))
            .computeMinIntrinsicWidth(style?.fontSize ?? 13.0);
    double endBefore = _renderParagraph(text.substring(endIndex - 1, endIndex))
        .computeMinIntrinsicWidth(style?.fontSize ?? 13.0);
    // 总体margin 可以再填下一个字符，将该字符填进去
    if (margin >= startNext && margin >= endBefore) {
      if (startNext >= endBefore) {
        startIndex = startIndex + 1;
      } else {
        endBefore = endBefore - 1;
      }
    } else if (margin >= startNext) {
      startIndex = startIndex + 1;
    } else if (margin >= endBefore) {
      endIndex = endIndex - 1;
    }
    return text.replaceRange(startIndex, endIndex, "...");
  }
}
