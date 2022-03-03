// TODO: Put public facing types in this file.
import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter_wallet_chain/btc/utils/magic_hash.dart';
import 'package:hex/hex.dart';

import 'ecpair.dart';
import 'models/networks.dart';
import 'payments/index.dart' show PaymentData;
import 'payments/p2pkh.dart';

/// Checks if you are awesome. Spoiler: you are.
class HDWallet {
  bip32.BIP32 abip32;
  P2PKH p2pkh;
  String? seed;
  NetworkType network;

  String? get privKey {
    try {
      return HEX.encode(abip32.privateKey!.toList());
    } catch (_) {
      return null;
    }
  }

  String? get pubKey => HEX.encode(abip32.publicKey);

  String? get base58Priv {
    try {
      return abip32.toBase58();
    } catch (_) {
      return null;
    }
  }

  String get base58 => abip32.neutered().toBase58();

  String? get wif {
    try {
      return abip32.toWIF();
    } catch (_) {
      return null;
    }
  }

  String? get address => p2pkh.data.address;

  HDWallet(
      {required this.abip32,
      required this.p2pkh,
      required this.network,
      this.seed}) {}

  HDWallet derivePath(String path) {
    final bip32 = abip32.derivePath(path);
    final p2pkh = new P2PKH(
        data: new PaymentData(pubkey: bip32.publicKey), network: network);
    return HDWallet(abip32: bip32, p2pkh: p2pkh, network: network);
  }

  HDWallet derive(int index) {
    final bip32 = abip32.derive(index);
    final p2pkh = new P2PKH(
        data: new PaymentData(pubkey: bip32.publicKey), network: network);
    return HDWallet(abip32: bip32, p2pkh: p2pkh, network: network);
  }

  factory HDWallet.fromSeed(Uint8List seed, {NetworkType? network}) {
    network = network ?? bitcoin;
    final seedHex = HEX.encode(seed);

    final wallet = bip32.BIP32.fromSeed(
        seed,
        bip32.NetworkType(
            bip32: bip32.Bip32Type(
                public: network.bip32.public, private: network.bip32.private),
            wif: network.wif));
    final p2pkh = new P2PKH(
        data: new PaymentData(pubkey: wallet.publicKey), network: network);
    return HDWallet(
        abip32: wallet, p2pkh: p2pkh, network: network, seed: seedHex);
  }

  factory HDWallet.fromBase58(String xpub, {NetworkType? network}) {
    network = network ?? bitcoin;
    final wallet = bip32.BIP32.fromBase58(
        xpub,
        bip32.NetworkType(
            bip32: bip32.Bip32Type(
                public: network.bip32.public, private: network.bip32.private),
            wif: network.wif));
    final p2pkh = new P2PKH(
        data: new PaymentData(pubkey: wallet.publicKey), network: network);
    return HDWallet(abip32: wallet, p2pkh: p2pkh, network: network, seed: null);
  }

  Uint8List sign(String message) {
    Uint8List messageHash = magicHash(message, network);
    return abip32.sign(messageHash);
  }

  bool verify({String? message, Uint8List? signature}) {
    Uint8List messageHash = magicHash(message!);
    return abip32.verify(messageHash, signature!);
  }
}

class BtcWallet {
  ECPair _keyPair;
  P2PKH _p2pkh;

  String? get privKey => HEX.encode(_keyPair.privateKey!);

  String? get pubKey => HEX.encode(_keyPair.publicKey!);

  String? get wif => _keyPair.toWIF();

  String? get address => _p2pkh.data.address;

  NetworkType network;

  BtcWallet(this._keyPair, this._p2pkh, this.network);

  factory BtcWallet.random([NetworkType? network]) {
    final _keyPair = ECPair.makeRandom(network: network!);
    final _p2pkh = new P2PKH(
        data: new PaymentData(pubkey: _keyPair.publicKey!), network: network);
    return BtcWallet(_keyPair, _p2pkh, network);
  }

  factory BtcWallet.fromWIF(String wif, [NetworkType? network]) {
    network = network ?? bitcoin;
    final _keyPair = ECPair.fromWIF(wif, network: network);
    final _p2pkh = new P2PKH(
        data: new PaymentData(pubkey: _keyPair.publicKey!), network: network);
    return BtcWallet(_keyPair, _p2pkh, network);
  }

  Uint8List sign(String message) {
    Uint8List messageHash = magicHash(message, network);
    return _keyPair.sign(messageHash);
  }

  bool verify({String? message, Uint8List? signature}) {
    Uint8List messageHash = magicHash(message!, network);
    return _keyPair.verify(messageHash, signature!);
  }
}
