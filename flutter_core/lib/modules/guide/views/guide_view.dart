import 'dart:math';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/routes/app_pages.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/widgets/ucore_button.dart';

class GuideView extends StatefulWidget {
  const GuideView({Key? key}) : super(key: key);

  @override
  _GuideViewState createState() => _GuideViewState();
}

class _GuideViewState extends State<GuideView> {
  final _controller = PageController();

  var _index = 0.0;

  List<String> get _titles => [
        I18nKeys.easy_to_use,
        I18nKeys.new_world_knowledge,
        I18nKeys.individual_reading,
      ];

  List<String> get _imgs => [
        'login/guide_page_one',
        'login/guide_page_two',
        'login/guide_page_three',
      ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _index = _controller.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView.builder(
          controller: _controller,
          physics: const BouncingScrollPhysics()
              .applyTo(AlwaysScrollableScrollPhysics()),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(height: 120),
                Text(_titles[index], style: TextStyle(fontSize: 23)),
                SizedBox(height: 56),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: LoadAssetImage(_imgs[index]),
                ),
              ],
            );
          },
        ),
        Align(
          alignment: Alignment(0, 0.42),
          child: DotsIndicator(
            dotsCount: 3,
            position: _index,
            decorator: DotsDecorator(
              color: const Color(0x50FF9544),
              activeColor: Get.isDarkMode ? Colours.dark_brand : Colours.brand,
              size: const Size(16, 4),
              activeSize: const Size(16, 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              spacing: const EdgeInsets.all(6),
            ),
          ),
        ),
        Align(
          alignment: Alignment(0, 0.56),
          child: Opacity(
            opacity: max(_index - 1, 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: UCoreButton(
                onPressed: () async {
                  if (_index == 2) {
                    await LocalService.to
                        .setCurrentVersionFirstStartupTimestamp();
                    Get.offAllNamed(Routes.HOME);
                  }
                },
                text: I18nKeys.experience_now,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
