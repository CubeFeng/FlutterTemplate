import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/models/news/category_model.dart';
import 'package:flutter_ucore/modules/rss/center/controllers/rss_center_controller.dart';
import 'package:flutter_ucore/modules/rss/center/views/widgets/rss_center_tab_page_view.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';

class RssCenterView extends StatefulWidget {
  const RssCenterView({Key? key}) : super(key: key);

  @override
  _RssCenterViewState createState() => _RssCenterViewState();
}

class _RssCenterViewState extends State<RssCenterView> with TickerProviderStateMixin {
  RssCenterController get controller => Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UCoreAppBar(
        title: Text(I18nKeys.rss_source_of_subscription),
        elevation: 0,
      ),
      body: Obx(() {
        final tabs = controller.categories.map((e) => _buildTabItemWidget(e)).toList();
        final pages =
            controller.categories.mapIndexed((index, e) => RssCenterTabPageView(index: index, category: e)).toList();
        final tabController = controller.newTabController(this);
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TabBar(
                  isScrollable: true,
                  physics: BouncingScrollPhysics().applyTo(AlwaysScrollableScrollPhysics()),
                  tabs: tabs,
                  indicatorWeight: 3,
                  indicatorColor: Get.isDarkMode ? Colours.dark_brand : Colours.brand,
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: Colours.tertiary_text,
                  labelStyle: TextStyle(fontSize: 16),
                  labelColor: Colours.primary_text,
                  controller: tabController,
                ),
              ),
              SizedBox(height: 4),
              Divider(height: 1),
              Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics().applyTo(AlwaysScrollableScrollPhysics()),
                  controller: tabController,
                  children: pages,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTabItemWidget(CategoryModel category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(category.categoryName ?? ""),
    );
  }
}
