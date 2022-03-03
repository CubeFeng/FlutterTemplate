import 'package:flutter_ucore/apis/api_urls.dart';
import 'package:flutter_ucore/models/news/category_model.dart';
import 'package:flutter_ucore/models/news/news_model.dart';
import 'package:flutter_ucore/models/news/read_and_rss_num_model.dart';
import 'package:flutter_ucore/models/news/rss_model.dart';
import 'package:flutter_ucore/services/app_service.dart';
import 'package:flutter_ucore/services/http_service.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

class NewsApi {
  /// 查询用户阅读数和订阅数
  static Future<ResponseModel<ReadAndRssNumModel>> queryUserRssAdvisoryNum() async {
    return HttpService.to.http.get<ReadAndRssNumModel>(ApiUrls.newsQueryUserRssAdvisoryNum);
  }

  /// 资讯列表分页
  /// [page] 单前页面
  /// [pageSize] 单页数量
  /// [device] 设备编号
  /// [rssId] 订阅源ID
  /// [rssIds] 订阅源ID列表
  static Future<ResponseModel<PagedNewsItemModel>> queryAdvisoryList({
    int? page,
    int? pageSize,
    String? device,
    int? rssId,
    List<int>? rssIds,
  }) async {
    final appInfo = await AppService.service.info;
    return HttpService.to.http.post<PagedNewsItemModel>(
      ApiUrls.newsQueryAdvisoryList,
      data: {
        "current": page ?? 1,
        "size": pageSize ?? 20,
        "device": device ?? appInfo?.deviceId,
        "rssId": rssId,
        "rssIds": rssIds,
      },
    );
  }

  /// 查询阅读历史列表分页
  /// [page] 单前页面
  /// [pageSize] 单页数量
  static Future<ResponseModel<PagedNewsItemModel>> queryRecordUserReadHistory({
    int? page,
    int? pageSize,
  }) async {
    return HttpService.to.http.get<PagedNewsItemModel>(
      ApiUrls.newsQueryRecordUserReadHistory,
      queryParameters: {
        "current": page ?? 1,
        "size": pageSize ?? 20,
      },
    );
  }

  /// 订阅源下的资讯列表分页
  /// [page] 单前页面
  /// [pageSize] 单页数量
  /// [device] 设备编号
  /// [rssId] 订阅源Id,查询订阅源下的资讯列表时传值
  /// [rssIds] 用户离线订阅源Id集合
  static  Future<ResponseModel<WithBgPagedNewsItemModel>> queryRssAdvisoryList({
    int? page,
    int? pageSize,
    String? device,
    int? rssId,
    List<int>? rssIds,
  }) async {
    final appInfo = await AppService.service.info;
    return HttpService.to.http.post<WithBgPagedNewsItemModel>(
      ApiUrls.newsQueryRssAdvisoryList,
      data: {
        "current": page ?? 1,
        "size": pageSize ?? 20,
        "device": device ?? appInfo?.deviceId,
        "rssId": rssId,
        "rssIds": rssIds,
      },
    );
  }

  /// 查询所有订阅源
  /// [page] 单前页面
  /// [pageSize] 单页数量
  /// [categoryId] 分类id
  static Future<ResponseModel<PagedRssModel>> queryRssList({
    int? page,
    int? pageSize,
    int? categoryId,
  }) async {
    return HttpService.to.http.post<PagedRssModel>(
      ApiUrls.newsQueryRssList,
      data: {
        "current": page ?? 1,
        "size": pageSize ?? 20,
        "id": categoryId,
      },
    );
  }

  /// 查询当前用户的所有订阅源
  /// [page] 单前页面
  /// [pageSize] 单页数量
  /// [rssIds] 订阅源id集合
  static Future<ResponseModel<PagedRssModel>> queryRssListCurrent({
    int? page,
    int? pageSize,
    List<int>? rssIds,
  }) async {
    return HttpService.to.http.post<PagedRssModel>(
      ApiUrls.newsQueryRssListCurrent,
      data: {
        "current": page ?? 1,
        "size": pageSize ?? 20,
        "rssIds": rssIds,
      },
    );
  }

  /// 查询所有分类名称
  static Future<ResponseModel<List<CategoryModel>>> queryAllCategory() async {
    return HttpService.to.http.get<List<CategoryModel>>(ApiUrls.newsQueryAllCategory);
  }

  /// 记录用户阅读历史
  /// [advisoryId] 资讯id
  static  Future<ResponseModel<bool>> recordUserReadHistory({
    required int advisoryId,
  }) async {
    return HttpService.to.http.post<bool>(
      ApiUrls.newsRecordUserReadHistory,
      data: {
        "advisoryId": advisoryId,
      },
    );
  }

  /// 登录同步用户订阅
  static Future<ResponseModel<bool>> recordUserRssSource({
    required List<int> rssIds,
  }) async {
    return HttpService.to.http.post<bool>(
      ApiUrls.newsRecordUserRssSource,
      data: {
        "rssIds": rssIds,
      },
    );
  }

  /// 订阅资讯，取消订阅，重新订阅
  /// [rssId] 资讯源id
  /// [isSubscribe] 是否订阅：0-取消订阅，1-订阅资讯
  static Future<ResponseModel<bool>> topicRss({
    required int rssId,
    required int isSubscribe,
  }) async {
    return HttpService.to.http.post<bool>(
      ApiUrls.newsTopicRss,
      data: {
        "rssId": rssId,
        "isSubscribe": isSubscribe,
      },
    );
  }

  /// 资讯异常反馈
  /// [advisoryId] 资讯id
  /// [device] 设备号
  /// [type] 反馈异常类型:1-无法显示，2-资讯侵权，3-虚假新闻
  static Future<ResponseModel<bool>> userAdvisoryFeedback({
    required int advisoryId,
    String? device,
    required int type,
  }) async {
    final appInfo = await AppService.service.info;
    return HttpService.to.http.post<bool>(
      ApiUrls.newsUserAdvisoryFeedback,
      data: {
        "advisoryId": advisoryId,
        "device": device ?? appInfo?.deviceId,
        "type": type,
      },
    );
  }
}
