import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/models/transaction_page_model.dart';
import 'package:flutter_wallet/services/http_service.dart';

import 'api_urls.dart';

class WalletHttpRequest {
  ///获取交易记录
  static Future<ResponseModel<TransactionPageModel>> getTransactionRecord(
      {required String address,
      required String coinType,
      required int requestType,
      required int page,
      required int pageSize,
      required int year,
      required int month,
      String? contractAddress}) async {
    String monthStr = month < 10 ? '0$month' : '$month';
    return await HttpService.service.http
        .post<TransactionPageModel>(ApiUrls.getRecord, data: {
      "address": address,
      "contractAddress": contractAddress,
      "addressType": requestType,
      "month": monthStr,
      "pageNum": page,
      "pageSize": pageSize,
      "type": coinType,
      "year": "$year"
    });
  }

  ///获取NFT成交记录
  static Future<ResponseModel<TransactionPageModel>> getNftTokenRecord(
      {required String tokenId,
      required int page,
      required int pageSize,
      required contractAddress}) async {
    return await HttpService.service.http
        .post<TransactionPageModel>(ApiUrls.getNftRecord, data: {
      "contractAddress": contractAddress,
      "pageNum": page,
      "pageSize": pageSize,
      "tokenId": tokenId,
    });
  }
}
