import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/theme/colors.dart';

typedef BoolCallback = bool Function();

@immutable
class UCoreChoiceItem {
  final String title;
  final GestureTapCallback onTap;
  final BoolCallback selected;

  const UCoreChoiceItem({required this.title, required this.onTap, required this.selected});
}

class UCoreChoiceListView extends StatelessWidget {
  final List<UCoreChoiceItem> items;

  const UCoreChoiceListView({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics().applyTo(AlwaysScrollableScrollPhysics()),
      itemBuilder: (context, index) => _UCoreChoiceItemWidget(
        child: Text(items[index].title),
        selected: items[index].selected(),
        onTap: items[index].onTap,
      ),
      separatorBuilder: (context, index) => Divider(indent: 16),
      itemCount: items.length,
    );
  }
}

class _UCoreChoiceItemWidget extends StatelessWidget {
  final Widget child;
  final bool? selected;
  final GestureTapCallback? onTap;

  const _UCoreChoiceItemWidget({
    Key? key,
    required this.child,
    this.selected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Get.isDarkMode ? Colours.dark_primary_bg : Colours.primary_bg,
      child: Container(
        height: 55,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                DefaultTextStyle(style: Get.textTheme.subtitle1!.copyWith(fontSize: 15), child: child),
                Expanded(child: Container()),
                selected == true ? LoadAssetImage("drawer/icon_choose_language") : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
