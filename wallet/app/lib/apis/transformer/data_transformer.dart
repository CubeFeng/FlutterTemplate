import 'dart:convert';

import 'package:flutter_base_kit/net/net.dart';
import 'package:flutter_wallet/generated/json_partner/json_partner.dart';

class ApiDataTransformer implements ResponseTransformer {
  @override
  Future<ResponseModel<T>> onTransform<T>(Object? data) async {
    final String tType = T.toString();
    if (data == null || data.toString().isEmpty || tType == 'void' || tType == 'Null') {
      return Future.value(ResponseModel<T>.named(data: null));
    }

    final listType = ['List<dynamic>', 'List<int>', 'List<String>', 'List<num>', 'List<int>', 'List<double>'];

    /// 因为默认使用了 json formater, 所以 data 只会有5种类型
    /// [String], [bool], [List], [Map]
    ///
    /// 当 [data] is [Map] 时候进行状态解析
    ///
    if (data is String) {
      if (tType == 'String' || tType == 'dynamic') {
        return Future.value(ResponseModel<T>.named(data: data as T));
      } else {
        throw Exception('Data Parse Error');
      }
    } else if (data is bool) {
      if (tType == 'bool' || tType == 'dynamic') {
        return Future.value(ResponseModel<T>.named(data: data as T));
      } else {
        throw Exception('Data Parse Error');
      }
    } else if (data is List) {
      if (tType == 'dynamic') {
        return Future.value(ResponseModel<T>.named(data: data as T));
      } else if (tType.startsWith('List<')) {
        if (listType.contains(tType)) {
          return Future.value(ResponseModel<T>.named(data: data as T));
        } else {
          final obj = JsonPartner.fromJsonAsT<T>(data);
          return Future.value(ResponseModel<T>.named(data: obj));
        }
      } else if (tType == 'String') {
        return Future.value(ResponseModel<T>.named(data: json.encode(data) as T));
      } else {
        throw Exception('Data Parse Error');
      }
    } else if (data is Map) {
      final int code = data['code'];
      final String? msg = data['msg'];
      final d = data['data'];
      if (tType == 'dynamic' || tType == 'bool') {
        return Future.value(ResponseModel<T>.named(code: code, message: msg, data: d));
      } else if (tType == 'String') {
        String res;
        if (d.toString().contains('{') || d.toString().contains('[')) {
          res = json.encode(d);
        } else {
          res = d.toString();
        }
        return Future.value(ResponseModel<T>.named(code: code, message: msg, data: res as T));
      } else if (tType == 'num') {
        final n = num.tryParse(d.toString());
        if (n == null) {
          throw Exception('Data Parse Error');
        }
        return Future.value(ResponseModel<T>.named(code: code, message: msg, data: n as T));
      } else if (tType == 'int') {
        final n = int.tryParse(d.toString());
        if (n == null) {
          throw Exception('Data Parse Error');
        }
        return Future.value(ResponseModel<T>.named(code: code, message: msg, data: n as T));
      } else if (tType == 'double') {
        final n = double.tryParse(d.toString());
        if (n == null) {
          throw Exception('Data Parse Error');
        }
        return Future.value(ResponseModel<T>.named(code: code, message: msg, data: n as T));
      } else {
        /// 分为 List、Map、Other 的情况
        if (tType.startsWith('Map<String') || tType.startsWith('Map<dynamic')) {
          return Future.value(ResponseModel<T>.named(code: code, message: msg, data: d as T));
        } else if (listType.contains(tType)) {
          return Future.value(ResponseModel<T>.named(code: code, message: msg, data: d as T));
        }
        final obj = d == null ? null : JsonPartner.fromJsonAsT<T>(d);
        return Future.value(ResponseModel<T>.named(code: code, message: msg, data: obj));
      }
    }
    throw Exception('Data Parse Error');
  }
}
