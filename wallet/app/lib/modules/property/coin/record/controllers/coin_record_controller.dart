import 'dart:math';

import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_base_kit/net/http/http.dart';
import 'package:flutter_wallet/apis/http_request.dart';
import 'package:flutter_wallet/models/transaction_info_model.dart';
import 'package:flutter_wallet/models/transaction_page_model.dart';
import 'package:flutter_wallet/models/tx_type.dart';
import 'package:flutter_wallet/modules/property/base_record_controller.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';

///
class CoinRecordController extends BaseRecordController<Coin> {
  @override
  Future<void> onRefresh(TxType txType, bool timeChanged) {
    final now = DateTime.now();
    year = now.year;
    month.value = now.month;
    return super.onRefresh(txType, timeChanged);
  }

  @override
  getCoinKey() {
    return 'record-mainChain-' + coin.coinAddress!;
  }

  @override
  save2Database(List<TransactionInfoModel> list) async {
    print(list.length);
    for (var item in list) {
      List<Tx> tx = await DBService.service.txDao.findByTXHash(item.txHash!);
      Tx item2Tx = Tx(
          coinType: coin.coinType,
          tokenType: item.contractAddress,
          amount: BigInt.from(
              double.parse(item.amount!) * pow(10, coin.coinDecimals!)),
          fromAddress: item.fromAddr,
          toAddress: item.toAddr,
          txHash: item.txHash,
          fee: BigInt.from(
              double.parse(item.minerFee!) * pow(10, coin.coinDecimals!)),
          txTime: DateTime.fromMillisecondsSinceEpoch(item.blocktime! * 1000),
          txStatus: TxStatus.SUCCEED,
          blockNumber: item.blockNumber);
      print('找到相同的hash数量${tx.length}');
      if (tx.isNotEmpty) {
        item2Tx.id = tx[0].id;
        await DBService.service.txDao.saveAndReturnId(item2Tx);
      } else {
        await DBService.service.txDao.saveAndReturnId(item2Tx);
      }
    }
  }

  @override
  Future<List<TransactionInfoModel>> queryLocalData(TxType txType) async {
    List<TransactionInfoModel> res = [];
    DateTime from = DateTime(1990, 1, 1);
    DateTime to = DateTime.now();
    List<Tx> txList = [];
    switch (txType) {
      case TxType.ALL:
        txList = await DBService.service.txDao
            .findByCoinTypeAndTime(coin.coinType!, coin.coinAddress!, from, to);
        break;
      case TxType.OUT:
        txList = await DBService.service.txDao.findTOutByCoinTypeAndTime(
            coin.coinType!, coin.coinAddress!, from, to);
        break;
      case TxType.IN:
        txList = await DBService.service.txDao.findTInByCoinTypeAndTime(
            coin.coinType!, coin.coinAddress!, from, to);
        break;
      case TxType.FAIL:
        // TODO: Handle this case.
        break;
    }

    print('数量${txList.length}');
    if (txList.isNotEmpty) {
      for (var txItem in txList) {
        TransactionInfoModel transactionInfoModel = TransactionInfoModel();
        transactionInfoModel.coin = txItem.coinType;
        transactionInfoModel.fromAddr = txItem.fromAddress;
        transactionInfoModel.toAddr = txItem.toAddress;
        transactionInfoModel.txHash = txItem.txHash;
        transactionInfoModel.minerFee = (txItem.fee ??
                BigInt.zero / BigInt.from(pow(10, coin.coinDecimals!)))
            .toString();
        transactionInfoModel.blocktime =
            txItem.txTime!.millisecondsSinceEpoch ~/ 1000;
        transactionInfoModel.contractAddress = txItem.tokenType;
        transactionInfoModel.amount =
            (txItem.amount! / BigInt.from(pow(10, coin.coinDecimals!)))
                .toString();

        transactionInfoModel.status = txItem.txStatus! == TxStatus.SUCCEED
            ? 3
            : (txItem.txStatus! == TxStatus.FAILED ? -1 : 1);
        if (transactionInfoModel.status == 1) {
          try {
            var receipt = await QiRpcService()
                .getTransactionStatus(transactionInfoModel.txHash!);
            if (receipt != null) {
              bool? success = receipt.status;
              if (success ?? false) {
                txItem.txStatus = TxStatus.SUCCEED;
                transactionInfoModel.status = 3;
              } else {
                if (coin.coinType == 'BTC') {
                  print('still pending');
                  //失败处理，未知
                } else {
                  transactionInfoModel.status = -1;
                  txItem.txStatus = TxStatus.FAILED;
                }
              }
              await DBService.service.txDao.saveAndReturnId(txItem);
            } else {
              print('still pending');
            }
          } catch (_) {}
        }
        transactionInfoModel.blockNumber = txItem.blockNumber;
        res.add(transactionInfoModel);
      }
    }
    return res;
  }

  int count = 0;

  @override
  Future<void> loadData(List<TransactionInfoModel> list, int page, int type,
      TxType txType, bool inEnd, bool outEnd,
      {refresh = false}) async {
    print(
        '$page>>加载>>$type>>$closeTag ,月份:${month.value}  inEnd:$inEnd, outEnd:$outEnd 数量：${list.length}');
    if (closeTag) {
      return;
    }
    if (inEnd && outEnd) {
      count++;
      if (count > cacheMonthCount) {
        cache6monthFinished = true;
        StorageUtils.sp.write(getCoinKey(), DateTime.now().millisecondsSinceEpoch);
        return;
      }
      month--;
      if (month.value == 0) {
        month.value = 12;
        year--;
      }
      await loadNetRecord(list, txType, 2);
      return;
    }
    ResponseModel<TransactionPageModel> data =
        await WalletHttpRequest.getTransactionRecord(
            page: page,
            address: coin.coinAddress!,
            month: month.value,
            requestType: type,
            year: year,
            coinType: coin.coinType!,
            pageSize: 50);

    if (data.data != null) {
      if (data.data!.records != null) {
        list.addAll(data.data!.records!);
      }
      if (refresh) {
        return;
      }
      if (list.length < 100) {
        if (txType == TxType.ALL) {
          if (type == 2) {
            await loadData(list, page + 1, 1, txType, inEnd,
                data.data!.current! >= data.data!.pages!);
          } else {
            await loadData(list, page, 2, txType,
                data.data!.current! >= data.data!.pages!, outEnd);
          }
        } else {
          await loadData(
              list,
              page,
              type,
              txType,
              data.data!.current! >= data.data!.pages!,
              data.data!.current! >= data.data!.pages!);
        }
      } else {
        cache6monthFinished = true;
        StorageUtils.sp.write(getCoinKey(), DateTime.now().millisecondsSinceEpoch);
      }
    }
  }
}
