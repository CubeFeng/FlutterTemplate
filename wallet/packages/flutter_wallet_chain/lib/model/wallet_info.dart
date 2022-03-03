import 'package:flutter/cupertino.dart';

import '../flutter_wallet_chain.dart';

/// 钱包模型.
class QiCoinKeypair {
  /// 助记词.
  var mnemonic;

  /// 私钥.
  var privateKey;

  /// 公钥.
  var publicKey;

  /// 地址.
  var address;
}

/// 钱包类型
enum QiCoinType {
  /// 天启旭达币.
  AITD,

  /// 以太坊.
  ETH,

  /// 比特币.
  BTC,

  /// 波场.
  TRX,

  /// solana .
  SOL
}

/// bip44对应数据
extension QiCoinCode44 on QiCoinType {
  /// coin类型
  static const codes = {
    QiCoinType.ETH: 60,
    QiCoinType.AITD: 60,
    QiCoinType.BTC: 0,
    QiCoinType.TRX: 195,
    QiCoinType.SOL: 501,
  };

  /// coinType
  static QiCoinType parse(String coinType) {
    var res = QiCoinType.AITD;
    QiCoinType.values.forEach((element) {
      if (coinType == element.chainName()) {
        res = element;
      }
    });
    return res;
  }

  /// coinType
  static QiCoinType parseCode(int coinCode) {
    for (QiCoinType element in codes.keys) {
      if (codes[element] == coinCode) {
        return element;
      }
    }
    return QiCoinType.AITD;
  }

  /// 地址编号
  static const addressIndexes = {
    QiCoinType.AITD: 99,
  };

  /// 链全称
  static const fullNames = {
    QiCoinType.ETH: 'Ethereum',
    QiCoinType.AITD: 'AITD Coin',
    QiCoinType.BTC: 'Bitcoin',
    QiCoinType.TRX: 'TRON',
    QiCoinType.SOL: 'Solana',
  };

  /// 链名称
  static const chainNames = {
    QiCoinType.ETH: 'ETH',
    QiCoinType.AITD: 'AITD',
    QiCoinType.BTC: 'BTC',
    QiCoinType.TRX: 'TRX',
    QiCoinType.SOL: 'SOLANA',
  };

  /// 币种单位
  static const coinUnits = {
    QiCoinType.ETH: 'ETH',
    QiCoinType.AITD: 'AITD',
    QiCoinType.BTC: 'BTC',
    QiCoinType.TRX: 'TRX',
    QiCoinType.SOL: 'SOLANA',
  };

  /// 币种精度
  static const coinDecimals = {
    QiCoinType.ETH: 18,
    QiCoinType.AITD: 18,
    QiCoinType.BTC: 8,
    QiCoinType.TRX: 6,
    QiCoinType.SOL: 9,
  };

  /// 币种色调
  static const coinColors = {
    QiCoinType.ETH: [Color(0xFF464646), Color(0xFF2A2A2A), Color(0xFF3D3D3D)],
    QiCoinType.AITD: [Color(0xFF235FD5), Color(0xFF4681F6), Color(0xFF2750EB)],
    QiCoinType.BTC: [Color(0xFFF68734), Color(0xFFE36E16), Color(0xFFF5812A)],
    QiCoinType.TRX: [Color(0xFFDE3A3A), Color(0xFFE94A4A), Color(0xFFEF5353)],
    QiCoinType.SOL: [Color(0xFF464646), Color(0xFF2A2A2A), Color(0xFF3D3D3D)],
  };

  /// 币种单位
  String coinUnit() {
    final unit = coinUnits[this];
    if (unit == null) {
      return 'unKnow';
    }
    return unit;
  }

  /// 币种主色调
  Color coinColor() {
    final unit = coinColors[this];
    if (unit == null) {
      return Color(0xFF2750EB);
    }
    return unit[2];
  }

  /// 币种渐变色调
  List<Color> coinGradientColor() {
    final unit = coinColors[this];
    if (unit == null) {
      return [Color(0xFF4681F6), Color(0xFF235FD5)];
    }
    return unit.sublist(0, 2);
  }

  /// 币种精度
  int coinDecimal() {
    final decimal = coinDecimals[this];
    if (decimal == null) {
      return 0;
    }
    return decimal;
  }

  /// 链是否支持
  bool isSupport() {
    final name = isSupports[this];
    if (name == null) {
      return false;
    }
    return true;
  }

  /// 获取币种的名称
  String chainName() {
    final name = chainNames[this];
    if (name == null) {
      return 'unKnow';
    }
    return name;
  }

  /// 获取币种的名称
  String fullName() {
    final name = fullNames[this];
    if (name == null) {
      return 'unKnow';
    }
    return name;
  }

  /// 获取钱包对应bip44中的的coin
  int coinCode() {
    final code = codes[this];
    if (code == null) {
      return 0;
    }
    return code;
  }

  /// 获取钱包对应bip44中的的addressIndex
  int addressIndex() {
    final index = addressIndexes[this];
    if (index == null) {
      return 0;
    }
    return index;
  }
}
