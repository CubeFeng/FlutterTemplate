import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:convert/convert.dart' show hex;

final BigInt _byteMask = new BigInt.from(0xff);

class EthUtils {
  /// Is the string a hex string.
  static bool isHexString(String value, {int length = 0}) {
    if (!RegExp('^0x[0-9A-Fa-f]*\$').hasMatch(value)) {
      return false;
    }

    if (length > 0 && value.length != 2 + 2 * length) {
      return false;
    }

    return true;
  }

  /// Pads a [String] to have an even length
  static String padToEven(String value) {
    var a = "${value}";

    if (a.length % 2 == 1) {
      a = "0${a}";
    }

    return a;
  }

  static bool isHexPrefixed(String str) {
    return str.substring(0, 2) == '0x';
  }

  static String stripHexPrefix(String str) {
    return isHexPrefixed(str) ? str.substring(2) : str;
  }

  /// Converts a [int] into a hex [String]
  static String intToHex(int i) {
    return "0x${i.toRadixString(16)}";
  }

  /// Converts an [int] to a [Uint8List]
  static Uint8List intToBuffer(int i) {
    return Uint8List.fromList(hex.decode(padToEven(intToHex(i).substring(2))));
  }

  static Uint8List toBuffer(dynamic v) {
    if (!(v is Uint8List)) {
      if (v is List) {
        v = Uint8List.fromList(v as List<int>);
      } else if (v is String) {
        if (isHexString(v)) {
          v = Uint8List.fromList(hex.decode(padToEven(stripHexPrefix(v))));
        } else {
          v = Uint8List.fromList(utf8.encode(v));
        }
      } else if (v is int) {
        v = intToBuffer(v);
      } else if (v == null) {
        v = Uint8List(0);
      } else if (v is BigInt) {
        v = Uint8List.fromList(encodeBigInt(v));
      } else {
        throw 'invalid type';
      }
    }

    return v;
  }

  static Uint8List encodeBigInt(BigInt input, {Endian endian = Endian.be, int length = 0}) {
    int byteLength = (input.bitLength + 7) >> 3;
    int reqLength = length > 0 ? length : max(1, byteLength);
    assert(byteLength <= reqLength, 'byte array longer than desired length');
    assert(reqLength > 0, 'Requested array length <= 0');

    var res = Uint8List(reqLength);
    res.fillRange(0, reqLength - byteLength, 0);

    var q = input;
    if (endian == Endian.be) {
      for (int i = 0; i < byteLength; i++) {
        res[reqLength - i - 1] = (q & _byteMask).toInt();
        q = q >> 8;
      }
      return res;
    } else {
      // FIXME: le
      throw UnimplementedError('little-endian is not supported');
    }
  }
}

enum Endian {
  be,
  // FIXME: le
}
