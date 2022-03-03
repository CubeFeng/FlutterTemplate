import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/modules/dapps/controllers/dapp_browser_controller.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/theme/gaps.dart';
import 'package:flutter_wallet/utils/app_utils.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

class DappsBrowserSearchBar extends StatefulWidget {
  const DappsBrowserSearchBar({
    Key? key,
    this.onTextChange,
  }) : super(key: key);
  final ValueChanged<String>? onTextChange;

  @override
  _DappsBrowserSearchBarState createState() => _DappsBrowserSearchBarState();
}

class _DappsBrowserSearchBarState extends State<DappsBrowserSearchBar> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  final DappBrowserController _browserController = Get.find<DappBrowserController>();

  final _showClearBtn = false.obs;
  final _showScanBtn = true.obs;
  final _buttonText = I18nKeys.cancel.obs;

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
    _showScanBtn.value = !_focusNode.hasFocus;
    _buttonText.value =
        _textEditingController.text.isEmpty ? I18nKeys.cancel : I18nKeys.finish;
    if (widget.onTextChange != null) {
      widget.onTextChange!(_textEditingController.text);
    }
  }

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
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // alignment: Alignment.center,
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _textEditingController,
                      maxLines: 1,
                      cursorColor: Colors.grey,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value){
                        _browserController.searchDappWithTextFlied(value);
                      },
                      decoration: InputDecoration(
                        hintText: I18nKeys.searchDappOrEnterALink,
                        hintStyle: const TextStyle(
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFFD2D2D2),
                        ),
                        // border: OutlineInputBorder(borderSide: BorderSide.none),
                        isCollapsed: true,
                        // contentPadding: EdgeInsets.all(0)
                        // prefixIconConstraints: BoxConstraints(maxHeight: 22, maxWidth: 22),
                        border: InputBorder.none,
                        // contentPadding: EdgeInsets.all(20),
                      ),
                      textAlignVertical: TextAlignVertical.center,
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
            Obx(() {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: _showScanBtn.isTrue
                    ? GestureDetector(
                        child: const WalletLoadAssetImage(
                          'common/scan_qrcode',
                          width: 24,
                        ),
                        onTap: () async {
                          if (false) {
                            String url =
                                'wc:be887aa9-c886-45ec-8362-25d6ee45786e@1?bridge=https%3A%2F%2Fbridge.walletconnect.org%2F&key=c0a9dd157b51b5005c8e7e9d73ed6fd9974437958f7902340478ee2cd61f5c78';
                            Get.toNamed(Routes.Dapp_Wallet_Connect,
                                parameters: {"connectUrl": url});
                            return;
                          }
                          AppUtils.hideKeyboard();
                          // // 扫码
                          final result = await Get.toNamed(
                              Routes.Dapp_Wallet_Connect_SCAN);
                          if (result != null) {
                            Get.toNamed(Routes.Dapp_Wallet_Connect,
                                parameters: {"connectUrl": result.toString()});
                          }
                        },
                      )
                    : GestureDetector(
                        child: Text(
                          _buttonText.value,
                          style:
                              TextStyle(color: Colors.black87, fontSize: 14.sp),
                        ),
                        onTap: () {
                          AppUtils.hideKeyboard();
                          if (_textEditingController.text.isNotEmpty) {
                            String url = _textEditingController.text;
                            _browserController.searchDappWithTextFlied(_textEditingController.text);
                          }
                          _textEditingController.text = '';
                          _focusNode.unfocus();
                        },
                      ),
              );
            }),
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
