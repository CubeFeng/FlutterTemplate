import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/modules/wallet/manager/controllers/wallet_manage_controller.dart';
import 'package:flutter_wallet/services/local_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet/services/db_service.dart';
import 'package:flutter_wallet/widgets/uni_wallet_card.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';
import 'package:flutter_wallet_chain/flutter_wallet_chain.dart';
import 'package:flutter_wallet_db/flutter_wallet_db.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';

typedef SelectedWalletCallback = void Function(Coin coin);

/// 切换钱包
class SwitchWalletModal extends StatelessWidget {
  final _controller = Get.put(_SwitchWalletController());
  final SelectedWalletCallback onSelectedWalletCallback;
  final QiCoinType? coinType;
  final bool singleChain;

  SwitchWalletModal({
    Key? key,
    required this.onSelectedWalletCallback,
    this.coinType,
    this.singleChain = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _controller.loadInitialData(coinType);
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: constraints.maxHeight * 0.75,
        child: GetBuilder<_SwitchWalletController>(
            init: _controller,
            builder: (controller) {
              int position = 0;
              int selectPosition = 0;
              for (var element in controller.coinsMappings.keys) {
                if (controller.selectCoinType == element) {
                  selectPosition = position;
                }
                position++;
              }
              bool lastOne =
                  selectPosition == controller.coinsMappings.length - 1;

              return controller.selectCoinType == null
                  ? Container()
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.r),
                          topRight: Radius.circular(15.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildTitle(),
                          Expanded(
                            child: Row(
                              children: [
                                _buildDashboardChains(selectPosition, lastOne),
                                Expanded(child: _buildDashboardWallets()),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
            }),
      );
    });
  }

  Widget _buildTitle() {
    return SizedBox(
      height: 51.h,
      child: Stack(
        children: [
          Center(
              child: Text(
            I18nKeys.changeWallet,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
              color: const Color(0xFF333333),
            ),
          )),
          Positioned(
            right: 0,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.clear,
                color: Color(0xFF333333),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDashboardWallets() {
    return Container(
      color: const Color(0xFFF8F9FF),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 20,
              right: 20,
              bottom: 7.5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _controller.selectCoinType!.chainName(),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 1.08354),
                  child: Text(
                    ' /' + _controller.selectCoinType!.fullName(),
                    style:
                        const TextStyle(fontSize: 11, color: Color(0xFF666666)),
                  ),
                ),
              ],
            ),
          ),
          ..._controller.coinsMappings[_controller.selectCoinType]
                  ?.map(
                    (coin) => _buildWalletCard(
                        coin: coin,
                        onTap: () => onSelectedWalletCallback(coin)),
                  )
                  .toList() ??
              []
        ],
      ),
    );
  }

  Widget _buildDashboardChains(int selectPosition, bool lastOne) {
    return Container(
      color: Colors.white,
      width: 62.w,
      child: singleChain
          ? Column(
              children: [_singleChain(coinType!, 0, 0)],
            )
          : Column(
              children: [
                ..._controller.coinsMappings.keys.map((e) {
                  int position = 0;
                  int currentPosition = 0;
                  for (var element in _controller.coinsMappings.keys) {
                    if (element == e) {
                      currentPosition = position;
                    }
                    position++;
                  }
                  return _singleChain(e, currentPosition, selectPosition);
                }).toList(),
                lastOne
                    ? Container(
                        color: const Color(0xFFF8F9FF),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15)),
                          ),
                          height: 62.h,
                        ),
                      )
                    : Container(),
              ],
            ),
    );
  }

  Widget _singleChain(
      QiCoinType coinType, int currentPosition, int selectPosition) {
    return InkWell(
      onTap: () => _controller.setSelectCoinType(coinType),
      child: currentPosition == selectPosition
          ? Container(
              color: const Color(0xFFF8F9FF),
              height: 62.h,
              child: Center(
                child: WalletLoadAssetImage(
                  'property/icon_coin_${coinType.coinUnit().toLowerCase()}',
                  width: 30,
                  height: 30,
                ),
              ))
          : (currentPosition != selectPosition - 1 &&
                  currentPosition != selectPosition + 1)
              ? Container(
                  color: const Color(0xFFFFFFFF),
                  height: 62.h,
                  child: Center(
                      child: WalletLoadAssetImage(
                    'property/icon_coin_${coinType.coinUnit().toLowerCase()}_gray',
                    width: 30,
                    height: 30,
                  )))
              : Container(
                  color: const Color(0xFFF8F9FF),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: currentPosition == selectPosition - 1
                            ? const BorderRadius.only(
                                bottomRight: Radius.circular(15))
                            : const BorderRadius.only(
                                topRight: Radius.circular(15))),
                    height: 62.h,
                    child: Center(
                      child: WalletLoadAssetImage(
                        'property/icon_coin_${coinType.coinUnit().toLowerCase()}_gray',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildWalletCard({required Coin coin, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 7.5,
        ),
        child: UniWalletCard(
          shadowIcon: 'property/shadow_${coin.coinUnit!.toLowerCase()}',
          colors: QiCoinCode44.parse(coin.coinType!).coinGradientColor(),
          name: Text(
            WalletManageController.getCoinWalletName(_controller.wallets, coin),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          balance: Text(
            LocalService.to.currencySymbol +
                WalletService.service.getTotalBalanceCurrency(coin).toStringAsFixed(2),
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          address: coin.coinAddress!,
          selected: _controller.hasSelected(coin),
          hdWallet: WalletManageController.isHD(_controller.wallets, coin),
        ),
      ),
    );
  }
}

class _SwitchWalletController extends GetxController {
  final Map<QiCoinType, List<Coin>> coinsMappings = {};
  late List<Wallet> wallets;
  QiCoinType? selectCoinType;

  ///当前使用的地址
  Coin? currentCoin;

  Future<void> loadInitialData(QiCoinType? coinType) async {
    wallets = await DBService.to.walletDao.findAll();
    // 获取上一次选中使用的地址
    final selectCoinMap =
        StorageUtils.sp.read<Map<String, dynamic>>('currentCoin');
    if (selectCoinMap != null) {
      currentCoin = Coin.fromMap(selectCoinMap);
      update();
    }
    selectCoinType = coinType;
    for (var supportCoin in QiRpcService().supportCoins) {
      final coinList =
          await DBService.to.coinDao.findAllByCoinType(supportCoin.chainName());
      if (coinList.isNotEmpty) {
        coinsMappings[supportCoin] = coinList;
        selectCoinType ??= supportCoin;
      } else {
        coinsMappings.remove(supportCoin);
      }
    }
    update();
    getWalletBalance();
  }

  Future<void> getWalletBalance() async {
    await WalletService.to.refreshCoinBalance(
      coinsMappings[selectCoinType] ?? [],
      refresh: true,
    );

    for (Coin coin in (coinsMappings[selectCoinType] ?? [])) {
      if(coin.coinUnit == WalletService.service.currentCoin!.coinUnit){
        await WalletService.to.refreshTokenBalance(
            WalletService.service.tokenList, coin
        );
      }else{
        List<Token> tokenList = await DBService.service.tokenDao.findAllByCoinType(coin.coinType!);
        await WalletService.to.refreshTokenBalance(
            tokenList, coin
        );
      }
    }
    update();
  }

  void setSelectCoinType(QiCoinType coinType) {
    selectCoinType = coinType;
    update();
    getWalletBalance();
  }

  ///是否选中
  hasSelected(Coin coin) => coin.id == currentCoin?.id;
}
