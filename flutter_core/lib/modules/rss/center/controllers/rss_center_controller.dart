import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/apis/news_apis.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/models/news/category_model.dart';
import 'package:flutter_ucore/models/news/rss_model.dart';
import 'package:flutter_ucore/services/local_service.dart';
// import 'package:get/get.dart';

class RssCenterController extends GetxController {
  static final ALL_CATEGORY_ID = -1;
  static final SUBSCRIBED_CATEGORY_ID = -2;

  final categories = <CategoryModel>[].obs;

  TabController? tabController;

  final tabIndexObservable = 0.obs;

  var _tabIndex = 0;

  @override
  void onInit() async {
    super.onInit();
    Toast.showLoading();
    categories.addAll(_createFixedCategories());
    categories.addAll(await _getCategoriesFromRemote());
    Toast.hideLoading();
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }

  /// 初始化TabBar控制器
  /// 由View层调用
  TabController newTabController(TickerProvider vsync) {
    this.tabController?.dispose();
    final ctl = TabController(length: categories.length, vsync: vsync);
    ctl.addListener(() {
      tabIndexObservable.value = ctl.index;
      _tabIndex = ctl.index;
    });
    ctl.animateTo(_tabIndex);
    this.tabController = ctl;
    return ctl;
  }

  List<CategoryModel> _createFixedCategories() {
    // 全部
    final all = CategoryModel();
    all.id = ALL_CATEGORY_ID;
    all.categoryName = I18nKeys.all;
    // 已订阅
    final subscribed = CategoryModel();
    subscribed.id = SUBSCRIBED_CATEGORY_ID;
    subscribed.categoryName = I18nKeys.subscribed;
    return [all, subscribed];
  }

  Future<List<CategoryModel>> _getCategoriesFromRemote() async {
    final response = await NewsApi.queryAllCategory();
    if (response.code == 0) {
      return response.data ?? [];
    }
    return List.empty();
  }

  Future<ResponseModel<PagedRssModel>> getRssList({
    required CategoryModel category,
    required int page,
    required int pageSize,
  }) async {
    if (category.id == ALL_CATEGORY_ID) {
      return NewsApi.queryRssList(page: page, pageSize: pageSize);
    } else if (category.id == SUBSCRIBED_CATEGORY_ID) {
      return NewsApi.queryRssListCurrent(page: page, pageSize: pageSize, rssIds: LocalService.to.subscribedRssIds);
    } else {
      return NewsApi.queryRssList(page: page, pageSize: pageSize, categoryId: category.id);
    }
  }
}
