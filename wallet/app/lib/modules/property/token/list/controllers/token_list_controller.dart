import 'package:flutter_base_kit/net/http/http.dart';
import 'package:flutter_wallet/apis/api_urls.dart';
import 'package:flutter_wallet/models/token_item_model.dart';
import 'package:flutter_wallet/modules/property/controllers/property_controller.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/http_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:get/get.dart';

///
class TokenListController extends GetxController {
  @override
  Future<void> onReady() async {
    localTokenList = await DBService.to.tokenDao
        .findAllByCoinType(WalletService.service.currentCoin!.coinType!);
    for (var item in localTokenList) {
      maps[item.tokenUnit!] = true;
    }
    update();

    ResponseModel<List<TokenItemModel>> result = await HttpService.service.http
        .get<List<TokenItemModel>>(
            ApiUrls.getTokenList(WalletService.service.currentCoin!.coinUnit!));

    if (result.data != null) {
      for (var element in result.data!) {
        Token token = Token(
          coinId: WalletService.service.currentCoin!.id,
          coinType: WalletService.service.currentCoin!.coinType,
          tokenName: element.consensus,
          tokenType: element.agreement,
          contractAddress: element.contract,
          tokenIcon: element.iconUrl,
          tokenUnit: element.coinUnit,
          tokenDecimals: element.decimals,
          description: element.description,
          dappUrl: element.dappUrl,
          tokenUrl: element.tokenUrl,
        ); //接口缺少作者和平台字段
        if (!token.tokenType!.endsWith('721')) {
          netTokenList.add(token);
          if (element.showToken == '1') {
            netShowTokenList.add(token);
          }
        }
      }
    }
    update();
  }

  final Map<String, bool> maps = {};
  List<Token> netTokenList = [];
  List<Token> netShowTokenList = [];
  List<Token> localTokenList = [];
  List<Token> searchTokenList = [];

  ///
  void verify() {}

  Future<void> addToken(Token token) async {
    final propertyController = Get.find<PropertyController>();
    token.coinId = WalletService.service.currentCoin!.id!;
    token.preHandle();
    await DBService.to.tokenDao.saveAndReturnId(token);
    await propertyController.getTokenList();
    maps[token.tokenUnit!] = true;
    update();
  }

  Future<void> removeToken(Token token) async {
    final propertyController = Get.find<PropertyController>();
    for (var item in WalletService.service.tokenList) {
      if (token.contractAddress == item.contractAddress) {
        await DBService.to.tokenDao.deleteAndReturnChangedRows(item);
        WalletService.service.tokenList.remove(item);
        await propertyController.getTokenList();
        maps[token.tokenUnit!] = false;
        update();
        return;
      }
    }
  }

  bool searchMode = false;

  void searchToken(String key) {
    if (key.isNotEmpty) {
      searchMode = true;
      searchTokenList.clear();
      for (var element in netTokenList) {
        if (element.tokenName!.contains(key)) {
          searchTokenList.add(element);
        } else if (element.contractAddress!.contains(key)) {
          searchTokenList.add(element);
        }
      }
    } else {
      searchMode = false;
    }
    update();
  }
}
