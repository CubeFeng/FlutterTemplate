import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/apis/api_urls.dart';
import 'package:flutter_wallet/models/token_info_model.dart';
import 'package:flutter_wallet/routes/app_pages.dart';
import 'package:flutter_wallet/services/http_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:get/get.dart';

///
class NftListController extends GetxController {
  late Token token;
  List<TokenInfoModel> tokenList = [];

  @override
  void onInit() {
    super.onInit();
    token = Get.arguments;
  }

  @override
  Future<void> onReady() async {
    ResponseModel<List<TokenInfoModel>> data = await HttpService.service.http
        .post<List<TokenInfoModel>>(ApiUrls.getNftCollections, data: {
      'contractAddress': token.contractAddress!,
      'address': WalletService.service.currentCoin!.coinAddress!
    });
    print(data);
    tokenList.addAll(data.data!);
    update();
  }

  void onTokenClick(TokenInfoModel tokenInfoModel) {
    Get.toNamed(Routes.NFT_TRANSACTION_LIST, arguments: tokenInfoModel);
  }
}
