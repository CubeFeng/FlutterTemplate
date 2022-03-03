// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter_wallet/apis/transformer/data_transformer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

void main() {
  final apiDataTransformer = ApiDataTransformer();

  group('#1 T is dynamic and data type is null or void', () {
    test('#1.1 data is null', () async {

      List str = [
        "amRvdWJsZS13YWxsZXQjb2puYmR3a29vcXBiYyNjb20=",
        "c2RvdWJsZS13YWxsZXQjeXVkaG1udHd1emhheSNjb20=",
        "a2RvdWJsZTItd2FsbGV0I21qbmJkd2tvb3FwYmMjY29t",
        "bmRvdWJsZTItd2FsbGV0I3B1ZGhtbnR3dXpoYXkjY29t",
        "emRvdWJsZTMtd2FsbGV0I2NqbmJkd2tvb3FwYmMjY29t",
        "YWRvdWJsZTMtd2FsbGV0I2R1ZGhtbnR3dXpoYXkjY29t"
      ];
      for (String tempStr in str) {
        //解码
        final baseUrl = EncryptUtils.decodeBase64(
          tempStr,
        );
        List<String> baseUrlList = [];
        int index = 0;
        // 以#分割 ，并把#前面第一个字母去掉
        for (String element in baseUrl.split("#")) {
          index++;
          if (index < baseUrl.split("#").length) {
            element = element.substring(1, element.length);
          }
          baseUrlList.add(element);
        }

        String tempUrl = baseUrlList.join(".");

        print(tempUrl);
      }

    });
    test('#1.2 data is empty', () async {
      final result = await apiDataTransformer.onTransform('');
      expect(result.data, null);
    });
    test('#1.3 T type is Null', () async {
      final result = await apiDataTransformer.onTransform<Null>('');
      expect(result.data, null);
    });
  });

  group('#2 data is String or bool', () {
    test('#2.1 data is String and T type is String or Dynamic', () async {
      final result1 = await apiDataTransformer.onTransform<String>('ok');
      expect(result1.data, 'ok');

      final result2 = await apiDataTransformer.onTransform('ok');
      expect(result2.data, 'ok');
    });

    test('#2.2 data is bool and T is bool or dynamic', () async {
      final result1 = await apiDataTransformer.onTransform<bool>(true);
      expect(result1.data, true);

      final result2 = await apiDataTransformer.onTransform(true);
      expect(result2.data, true);
    });
  });

  group('#3 data is List', () {
    test('#3.1 T type is String or Dynamic', () async {
      final result1 = await apiDataTransformer.onTransform<List>([1, 2, 3, 4]);
      expect(result1.data, [1, 2, 3, 4]);

      final result2 = await apiDataTransformer.onTransform([1, 2, 3, 4]);
      expect(result2.data, [1, 2, 3, 4]);
    });

    test('#3.1 T type is String or Dynamic', () async {
      final result1 = await apiDataTransformer.onTransform<String>([1, 2, 3, 4]);
      expect(result1.data, json.encode([1, 2, 3, 4]));

      final result2 = await apiDataTransformer.onTransform([1, 2, 3, 4]);
      expect(result2.data, [1, 2, 3, 4]);
    });

    test('#3.2 T type is List', () async {
      final result1 = await apiDataTransformer.onTransform<List<int>>([1, 2, 3, 4]);
      expect(result1.data, [1, 2, 3, 4]);

      // final result2 = await apiDataTransformer.onTransform<List<Nums>>([1, 2, 3, 4]);
      // expect(result2.data, [1, 2, 3, 4]);
    });
  });

  group('#4 data is Map', () {
    test('#4.1 T type is String or Dynamic or bool', () async {
      final responseData = {
        'code': 0,
        'msg': 'msg',
        'data': {'nickName': 'tuantuan'}
      };
      final result1 = await apiDataTransformer.onTransform<String>(responseData);
      expect(result1.data, json.encode({'nickName': 'tuantuan'}));

      final result2 = await apiDataTransformer.onTransform(responseData);
      expect(result2.data, {'nickName': 'tuantuan'});

      final result3 = await apiDataTransformer.onTransform<bool>({'code': 0, 'msg': 'msg', 'data': true});
      expect(result3.data, true);
    });

    test('#4.2 T type is num(int, double)', () async {
      final result1 = await apiDataTransformer.onTransform<num>({'code': 0, 'msg': 'msg', 'data': 100});
      expect(result1.data, 100);

      final result2 = await apiDataTransformer.onTransform<int>({'code': 0, 'msg': 'msg', 'data': 100});
      expect(result2.data, 100);

      final result3 = await apiDataTransformer.onTransform<double>({'code': 0, 'msg': 'msg', 'data': 100.234});
      expect(result3.data, 100.234);
    });

    test('#4.3 T type is List', () async {
      final result1 = await apiDataTransformer.onTransform<List<int>>({
        'code': 0,
        'msg': 'msg',
        'data': [1, 2, 3, 4]
      });
      expect(result1.data, [1, 2, 3, 4]);

      // obj
    });

    test('#4.4 T type is Map<String or Map<dynamic', () async {
      final result1 = await apiDataTransformer.onTransform<Map>({
        'code': 0,
        'msg': 'msg',
        'data': {'nickName': 'tuantuan'}
      });
      expect(result1.data, {'nickName': 'tuantuan'});

      final result2 = await apiDataTransformer.onTransform<Map<String, dynamic>>({
        'code': 0,
        'msg': 'msg',
        'data': {'nickName': 'tuantuan'}
      });
      expect(result2.data, {'nickName': 'tuantuan'});

      // obj
    });
  });
}
