import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/modules/property/base_transaction_view.dart';
import 'package:flutter_wallet/modules/property/nft/transaction/controllers/nft_transaction_controller.dart';
import 'package:flutter_wallet/theme/decorate_style.dart';
import 'package:flutter_wallet/theme/gaps.dart';

///
class NftTransactionView extends BaseTransactionView<NftTransactionController> {
  const NftTransactionView({Key? key}) : super(key: key);

  buildAmountWidget() {
    return Container(
      height: 82.h,
      padding: EdgeInsets.all(15.sp),
      decoration: DecorateStyles.decoration15,
      child: Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children: [
          Text(
            '收藏品',
            style: TextStyle(
                fontSize: 14,
                color: Color(0xff333333),
                fontWeight: FontWeight.bold),
          ),
          Gaps.vGap5,
          Text(
            controller.getNftName(),
            style: TextStyle(
                fontSize: 21,
                color: Color(0xff000000),
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
