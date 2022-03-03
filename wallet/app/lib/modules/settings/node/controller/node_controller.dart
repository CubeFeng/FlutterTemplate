import 'dart:convert';
import 'dart:ui';

import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet/apis/api_urls.dart';
import 'package:flutter_wallet/apis/transformer/data_transformer.dart';
import 'package:flutter_wallet/generated/i18n_keys.dart';
import 'package:flutter_wallet/generated/json_partner/json_partner.dart';
import 'package:flutter_wallet/models/node_info_model.dart';
import 'package:flutter_wallet/services/http_service.dart';
import 'package:flutter_wallet/services/wallet_service.dart';
import 'package:flutter_wallet_chain/api/rpc_api.dart';
import 'package:flutter_wallet_chain/api/rpc_client.dart';
import 'package:flutter_wallet_chain/model/net_info.dart';
import 'package:flutter_wallet_chain/model/wallet_info.dart';
import 'package:flutter_wallet/generated/json_partner/json_partner.dart';

class NodeCoinController extends GetxController {}

class NodeController extends GetxController {
  QiRpcConfig? coinConfig;
  late QiCoinType coin;

  @override
  void onInit() {
    super.onInit();
    String unit =
        Get.parameters['coin'] ?? WalletService.service.currentCoin!.coinUnit!;
    coin = QiCoinCode44.parse(unit);
    coinConfig = qiGetRpcConfig(coin) ?? QiRpcConfig(coin, [], 1);
  }

  isSelect(String nodeUrl) {
    return nodeUrl == getNode(coin);
  }

  @override
  onReady() async {
    super.onReady();

    List<NodeInfoModel> nodeList = nodeMaps[coin] ?? [];
    for (var element in nodeList) {
      IRpcClient.getRpcClient(
              QiCoinCode44.parse(coin.coinUnit()), element.nodeUrl ?? '', -1)
          .getBlockNumber(element.nodeUrl ?? '')
          .then((value) {
        nodeStatusMaps[element.nodeUrl ?? ''] = value;
        update();
      });
    }
  }

  Color getColor(String node) {
    List<int> res = nodeStatusMaps[node] ?? [];
    if (res.length == 2) {
      int time = res[1];
      if (time >= 1000) {
        return const Color(0xFFF14F4F);
      } else if (time > 200) {
        return const Color(0xFFF3B22E);
      } else {
        return const Color(0xFF42C53E);
      }
    }
    return const Color(0xFFFFFFFF);
  }

  bool isError(String node) {
    if (nodeStatusMaps[node] != null) {
      return nodeStatusMaps[node]!.isEmpty;
    }
    return false;
  }

  Map<String, List<int>> nodeStatusMaps = {};

  String getBlockHeight(String node) {
    List<int> res = nodeStatusMaps[node] ?? [];
    if (res.length == 2) {
      return '${I18nKeys.blockHeight} ${res[0]}';
    }
    return '';
  }

  String getNodeTime(String node) {
    List<int> res = nodeStatusMaps[node] ?? [];
    if (res.length == 2) {
      return '${res[1]}ms';
    }
    return '';
  }

  static String getNode(QiCoinType coinType) {
    String? node =
        StorageUtils.sp.read<String>('currentNode-' + (coinType.coinUnit()));
    if (node != null) {
      return node;
    }
    QiRpcConfig? qiRpcConfig = qiGetRpcConfig(coinType);
    if (qiRpcConfig != null) {
      return qiGetRpcConfig(coinType)!.nodes[0];
    }
    return '';
  }

  static Map<QiCoinType, List<NodeInfoModel>> nodeMaps = {};

  static String getNodeName(QiCoinType coinType, String nodeUrl) {
    List<NodeInfoModel> nodeInfo = nodeMaps[coinType] ?? [];
    for (NodeInfoModel item in nodeInfo) {
      if (item.nodeUrl == nodeUrl) {
        return item.nodeName ?? '-';
      }
    }
    return I18nKeys.unknown;
  }

  static requestNodes() async {
    print('requestNodes');
    ResponseModel<List<NodeInfoModel>> data = await HttpService.service.http
        .get<List<NodeInfoModel>>(ApiUrls.getNodes);
    print(data);

    List<NodeInfoModel> nodeList = [];
    if (data.data != null) {
      nodeList = data.data!;
      List<Map<String, dynamic>>? res =
          data.data!.map((e) => e.toJson()).toList();
      String jsonStr = jsonEncode(res);
      await StorageUtils.sp.write('nodeConfigures', jsonStr);
    } else {
      final jsonStr = StorageUtils.sp.read<String>('nodeConfigures');
      if (jsonStr != null) {
        final dynamic jsonObj = json.decode(jsonStr);
        nodeList = JsonPartner.fromJsonAsT<List<NodeInfoModel>>(jsonObj);
      }
    }
    print('nodeCount = ${nodeList.length}');
    nodeMaps = {};
    for (var element in nodeList) {
      QiCoinType coinType = QiCoinCode44.parse(element.coin!);
      List<NodeInfoModel> nodes = nodeMaps[coinType] ?? [];
      nodes.add(element);
      nodeMaps[coinType] = nodes;
    }
    for (var element in nodeMaps.keys) {
      List<String> nodeUrls = [];
      for (NodeInfoModel item in nodeMaps[element] ?? []) {
        nodeUrls.add(item.nodeUrl!);
      }
      QiRpcService().fetchNodes(element, nodeUrls);
    }
  }

  Future<void> selectNode(String node) async {
    if (isSelect(node)) {
      return;
    } else {
      await StorageUtils.sp.write('currentNode-' + (coin.coinUnit()), node);
      QiRpcService().changeNodeUrl(node);
      WalletService.service.changeNodeUrl(coin, node);
      if (Get.isRegistered<NodeCoinController>()) {
        NodeCoinController controller = Get.find<NodeCoinController>();
        controller.update();
      }
      update();
    }
  }
}
