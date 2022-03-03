// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/theme/colors.dart';
import 'package:flutter_ucore/theme/gaps.dart';

//我的绑定item
class MyBingdingItemWidget extends StatelessWidget {
  const MyBingdingItemWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.desc,
    required this.isBinding,
  }) : super(key: key);
  final String icon;
  final String title;
  final String desc;
  final bool isBinding;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 46.0),
      color: const Color(0xFFffffff),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gaps.vGap15,
          Container(
            padding: const EdgeInsets.only(left: 23, right: 28),
            child: Row(
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: LoadAssetImage(icon, fit: BoxFit.fill),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colours.primary_text,
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      desc,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: isBinding ? Colours.brand : Colours.tertiary_text,
                        fontSize: isBinding ? 14 : 12,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                Container(
                  height: 25,
                  child: Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: const Color(0xFF979797),
                    size: 15,
                  ),
                )
              ],
            ),
          ),
          Gaps.vGap15,
        ],
      ),
    );
  }
}
