import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_base_kit/theme/gaps.dart';
import 'package:flutter_wallet/modules/property/record_detail_view.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/theme/text_style.dart';
import 'package:flutter_wallet/utils/app_utils.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';

import '../controllers/token_list_controller.dart';

///
class TokenListView extends GetView<TokenListController> {
  const TokenListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TokenListController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            leading: null,
            automaticallyImplyLeading: false,
            title: SearchBar(
              onTextChange: (key) {
                controller.searchToken(key);
              },
            ),
          ),
          body: controller.searchMode
              ? ListView(
                  children: controller.searchTokenList.map((item) {
                    return tokenWidget(item);
                  }).toList(),
                )
              : ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: Text(
                        I18nKeys.haveBeedAddToken,
                        style: TextStyles.textBold14,
                      ),
                    ),
                    Column(
                      children: controller.localTokenList.map((item) {
                        return tokenWidget(item, showAmount: true);
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: Text(
                        I18nKeys.tokenList,
                        style: TextStyles.textBold14,
                      ),
                    ),
                    Column(
                      children: controller.netShowTokenList.map((item) {
                        return tokenWidget(item);
                      }).toList(),
                    ),
                  ],
                ),
        );
      },
      init: controller,
    );
  }

  Widget tokenWidget(Token item, {showAmount = false}) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: WalletLoadImage(
                item.tokenIcon!,
                width: 40.w,
                fit: BoxFit.fitHeight,
                height: 40.w,
                defaultImg: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      color: const Color(0xFFCCCCCC),
                      borderRadius: BorderRadius.circular(20.w)),
                ),
              )),
          Gaps.hGap10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.tokenUnit!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF333333),
                    )),
                Gaps.vGap5,
                SizedBox(
                    width: 138.w,
                    child: AddressText(
                      item.contractAddress!,
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
                    )),
                showAmount
                    ? Column(
                  children: [
                    Gaps.vGap4,
                    SizedBox(
                        width: 138.w,
                        child: AddressText(
                          I18nKeys.balance +
                              ': ' +
                              WalletService.service.getTokenBalance(item),
                          fontSize: 12.sp,
                          color: const Color(0xFF333333),
                        )),
                  ],
                )
                    : Container(),
              ],
            ),
          ),
          Switch(
            activeColor: const Color(0xFFFFFFFF),
            activeTrackColor: const Color(0xFF234CE6),
            inactiveTrackColor: const Color(0x225E6992),
            value: (controller.maps[item.tokenUnit] != null &&
                controller.maps[item.tokenUnit] == true),
            //当前状态
            onChanged: (value) {
              if (value) {
                controller.addToken(item);
              } else {
                controller.removeToken(item);
              }
            },
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key, this.onTextChange}) : super(key: key);
  final ValueChanged<String>? onTextChange;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  final _showClearBtn = false.obs;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      _updateDelIconVisible();
    });
    _focusNode.addListener(() {
      _updateDelIconVisible();
    });
  }

  void _updateDelIconVisible() {
    _showClearBtn.value =
        _focusNode.hasFocus && _textEditingController.text.isNotEmpty;
    if (widget.onTextChange != null) {
      widget.onTextChange!(_textEditingController.text);
    }
  }

  search(String key) {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        height: 35,
        child: Row(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  GestureDetector(
                    // behavior: HitTestBehavior.translucent,
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFF234CE6), width: 1),
                        //边框
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // alignment: Alignment.center,
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _textEditingController,
                        maxLines: 1,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                          hintText:
                              I18nKeys.pleaseEnterTheContractAddressToFind,
                          hintStyle: const TextStyle(
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFFD2D2D2),
                          ),
                          isCollapsed: true,
                          border: InputBorder.none,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Obx(() {
                        return Visibility(
                            visible: _showClearBtn.value,
                            child: GestureDetector(
                              child: const WalletLoadAssetImage(
                                'user/icon_delect_all',
                              ),
                              onTap: () => _textEditingController.clear(),
                            ));
                      }),
                      Gaps.hGap10
                    ],
                  ),
                ],
              ),
            ),
            Gaps.hGap5,
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                child: Text(
                  I18nKeys.cancel,
                  style: TextStyle(color: Colors.black87, fontSize: 14.sp),
                ),
                onTap: () {
                  AppUtils.hideKeyboard();
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.unfocus();
    _textEditingController.dispose();
    super.dispose();
  }
}
