import '../entity/entity.dart';

///
extension AddressExtensions on Address {
  ///
  void preHandle() {
    if (id == null) {
      createTime = DateTime.now();
    }
    updateTime = DateTime.now();
  }
}

///
extension CoinExtensions on Coin {
  ///
  void preHandle() {
    if (id == null) {
      createTime = DateTime.now();
    }
    updateTime = DateTime.now();
  }
}

///
extension TokenExtensions on Token {
  ///
  void preHandle() {
    if (id == null) {
      createTime = DateTime.now();
    }
    updateTime = DateTime.now();
  }
}

///
extension TxExtensions on Tx {
  ///
  void preHandle() {
    if (id == null) {
      createTime = DateTime.now();
    }
    updateTime = DateTime.now();
  }
}

///
extension WalletExtensions on Wallet {
  ///
  void preHandle() {
    if (id == null) {
      createTime = DateTime.now();
    }
    updateTime = DateTime.now();
  }
}
