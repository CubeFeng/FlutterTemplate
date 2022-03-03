import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/theme/colors.dart';

class TextButtonUpDown extends StatelessWidget {
  final int subCount;
  final VoidCallback? onTap;
  final String iconPath;
  final String title;

  const TextButtonUpDown({
    this.subCount = 0,
    this.onTap,
    required this.iconPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: Text(
              '$subCount',
              style: TextStyle(fontSize: 15, color: Colours.secondary_text),
            ),
          ),
          TextButton.icon(
            onPressed: null,
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent)),
            icon: LoadAssetImage(iconPath),
            label: Text(
              title,
              style: TextStyle(fontSize: 15, color: Colours.primary_text),
            ),
          ),
        ],
      ),
    );
  }
}
