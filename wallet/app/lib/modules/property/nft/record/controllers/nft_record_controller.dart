import 'dart:math';

import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_base_kit/net/http/http.dart';
import 'package:flutter_wallet/apis/http_request.dart';
import 'package:flutter_wallet/models/token_info_model.dart';
import 'package:flutter_wallet/models/transaction_info_model.dart';
import 'package:flutter_wallet/models/transaction_page_model.dart';
import 'package:flutter_wallet/models/tx_type.dart';
import 'package:flutter_wallet/modules/property/base_record_controller.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

///
class NftRecordController extends BaseRecordController<TokenInfoModel> {
  bool firstLoadInd = true;

  @override
  getCoinKey() {
    return WalletService.service.currentCoin!.coinAddress! +
        '-record-nft-' +
        coin.contractAddress!;
  }

  @override
  Future<List<TransactionInfoModel>> getCurrentList(TxType txType) async {
    List<TransactionInfoModel> list = [];
    if (firstLoadInd) {
      firstLoadInd = false;
      list = await queryLocalData(txType);
      if (list.isNotEmpty) {
        return list;
      }
    }
    list = await loadNftData(1); //获取转入记录

    //list.sort((left, right) => -left.blockNumber!.compareTo(right.blockNumber!));
    for (var item in list) {
      List<Tx> tx = await DBService.service.txDao.findByTXHash(item.txHash!);
      Tx item2Tx = Tx(
          coinType: coin.tokenId,
          tokenType: coin.contractAddress,
          amount: BigInt.one,
          fromAddress: item.fromAddr,
          toAddress: item.toAddr,
          fee: BigInt.from(double.parse(item.minerFee!) *
              pow(10, WalletService.service.currentCoin!.coinDecimals!)),
          txHash: item.txHash,
          txTime: DateTime.fromMillisecondsSinceEpoch(item.blocktime! * 1000),
          txStatus: TxStatus.SUCCEED,
          blockNumber: item.blockNumber);
      print('${item.txHash} 找到相同的hash数量${tx.length}');
      if (tx.isNotEmpty) {
        item2Tx.id = tx[0].id;
        await DBService.service.txDao.saveAndReturnId(item2Tx);
      } else {
        await DBService.service.txDao.saveAndReturnId(item2Tx);
      }
    }

    return await queryLocalData(txType);
  }

  Future<List<TransactionInfoModel>> queryLocalData(TxType txType) async {
    List<TransactionInfoModel> res = [];
    List<Tx> txList = await DBService.service.txDao
        .findNft(coin.tokenId!, coin.contractAddress!);

    if (txList.isNotEmpty) {
      for (var txItem in txList) {
        TransactionInfoModel transactionInfoModel = TransactionInfoModel();
        transactionInfoModel.coin = txItem.coinType;
        transactionInfoModel.fromAddr = txItem.fromAddress;
        transactionInfoModel.toAddr = txItem.toAddress;
        transactionInfoModel.txHash = txItem.txHash;
        transactionInfoModel.blocktime =
            txItem.txTime!.millisecondsSinceEpoch ~/ 1000;
        transactionInfoModel.contractAddress = txItem.tokenType;
        transactionInfoModel.minerFee = (txItem.fee ??
                BigInt.zero /
                    BigInt.from(pow(
                        10, WalletService.service.currentCoin!.coinDecimals!)))
            .toString();
        transactionInfoModel.amount = '1';

        transactionInfoModel.status = txItem.txStatus! == TxStatus.SUCCEED
            ? 3
            : (txItem.txStatus! == TxStatus.FAILED ? -1 : 1);
        if (transactionInfoModel.status == 1) {
          var receipt = await QiRpcService()
              .getTransactionStatus(transactionInfoModel.txHash!);
          if (receipt != null) {
            bool? success = receipt.status;
            if (success ?? false) {
              txItem.txStatus = TxStatus.SUCCEED;
              transactionInfoModel.status = 3;
            } else {
              transactionInfoModel.status = -1;
              txItem.txStatus = TxStatus.FAILED;
            }
            await DBService.service.txDao.saveAndReturnId(txItem);
          } else {
            print('still pending');
          }
        }
        transactionInfoModel.blockNumber = txItem.blockNumber;
        res.add(transactionInfoModel);
      }
    }
    return res;
  }

  /// 加载更多
  @override
  Future<void> onLoading(TxType txType) async {
    print('onLoading');
    currentPage++;
    hasMore = false;
    List<TransactionInfoModel> list = await loadNftData(currentPage);
    list.sort(
        (left, right) => -left.blockNumber!.compareTo(right.blockNumber!));
    if (list.isNotEmpty) {
      listDataMap[txType]!.addAll(list);
    }
    update([txType]);
    listViewControllers[txType]!.loadComplete();
    if (!hasMore) listViewControllers[txType]!.loadNoData();
  }

  var currentPage = 1;

  /// 加载更多
  Future<List<TransactionInfoModel>> loadNftData(int page) async {
    currentPage = page;
    List<TransactionInfoModel> list = [];
    ResponseModel<TransactionPageModel> data =
        await WalletHttpRequest.getNftTokenRecord(
            page: page,
            pageSize: 50,
            contractAddress: coin.contractAddress,
            tokenId: coin.tokenId!);
    if (data.data != null) {
      if (data.data!.records != null) {
        print('（数量） ${data.data!.size} ');
        list.addAll(data.data!.records!);
      }
      if (data.data!.current! < data.data!.pages!) {
        //还有下一页，继续取
        hasMore = true;
      }
    }
    return list;
  }

  @override
  save2Database(List<TransactionInfoModel> list) {}

  @override
  Future<void> loadData(List<TransactionInfoModel> list, int page, int type,
      TxType txType, bool inEnd, bool outEnd,
      {refresh = false}) async {}
}
