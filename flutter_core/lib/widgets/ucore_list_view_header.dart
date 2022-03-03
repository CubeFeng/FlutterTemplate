import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UCoreListHeader extends StatelessWidget {
  const UCoreListHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      builder: (BuildContext context, RefreshStatus? mode) {
        Widget body;
        if (mode == RefreshStatus.idle) {
          body = Text(I18nKeys.pull_down_to_refresh);
        } else if (mode == RefreshStatus.canRefresh) {
          body = Text(I18nKeys.release_to_refresh_immediately);
        } else if (mode == RefreshStatus.refreshing) {
          body = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(),
              SizedBox(width: 8),
              Text(I18nKeys.data_is_being_refreshed),
            ],
          );
        } else if (mode == RefreshStatus.completed) {
          body = Text(I18nKeys.refresh_succeeded);
        } else if (mode == RefreshStatus.failed) {
          body = Text(I18nKeys.refresh_failed);
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
