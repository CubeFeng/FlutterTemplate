import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UCoreListFooter extends StatelessWidget {
  const UCoreListFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text(I18nKeys.pull_load_more);
        } else if (mode == LoadStatus.canLoading) {
          body = Text(I18nKeys.release_load_more);
        } else if (mode == LoadStatus.loading) {
          body = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(),
              SizedBox(width: 8),
              Text(I18nKeys.loading_more_data),
            ],
          );
        } else if (mode == LoadStatus.failed) {
          body = Text(I18nKeys.loading_failed_click_retry);
        } else if (mode == LoadStatus.noMore) {
          body = Text(I18nKeys.loading_has_completed);
        } else {
          body = Text("");
        }
        return Container(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
  }
}
