import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallet/embed/embed_helper.dart';

class EmbedGlobalBack extends StatefulWidget {
  final Widget Function() builder;

  const EmbedGlobalBack({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<EmbedGlobalBack> createState() => _EmbedGlobalBackState();
}

class _EmbedGlobalBackState extends State<EmbedGlobalBack> {
  double get screenHeight => MediaQuery.of(context).size.height != 0
      ? MediaQuery.of(context).size.height
      : 720.0;

  double get minTop => screenHeight * 0.12;

  double get maxTop => screenHeight * 0.85;

  var hide = false;
  late double top = screenHeight * 0.75;

  @override
  Widget build(BuildContext context) {
    return EmbedHelper.isEmbedLaunch
        ? Stack(children: [widget.builder(), _buildGlobalBackFloating()])
        : widget.builder();
  }

  Widget _buildGlobalBackFloating() {
    final child = GestureDetector(
      onVerticalDragStart: (details) {
        setState(() {
          if (details.globalPosition.dy > maxTop) {
            top = maxTop;
          } else if (details.globalPosition.dy < minTop) {
            top = minTop;
          } else {
            top = details.globalPosition.dy;
          }
        });
      },
      onVerticalDragUpdate: (details) {
        setState(() {
          if (details.globalPosition.dy > maxTop) {
            top = maxTop;
          } else if (details.globalPosition.dy < minTop) {
            top = minTop;
          } else {
            top = details.globalPosition.dy;
          }
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: hide ? _buildHideGlobalBack() : _buildGlobalBack(),
      ),
    );
    if (MediaQuery.of(context).size.height == 0) {
      return Align(alignment: const Alignment(-1, 0.75), child: child);
    }
    return Positioned(left: 0, top: top, child: child);
  }

  Widget _buildHideGlobalBack() {
    return GestureDetector(
      onTap: () {
        setState(() => hide = false);
      },
      child: Container(
        width: 22,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 5,
            )
          ],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(22),
            bottomRight: Radius.circular(22),
          ),
        ),
        child: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF333333),
          size: 13,
        ),
      ),
    );
  }

  Widget _buildGlobalBack() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => SystemNavigator.pop(animated: true),
          child: Container(
            height: 44,
            padding: const EdgeInsets.only(left: 9, right: 3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  blurRadius: 5,
                )
              ],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF333333),
                    size: 13,
                  ),
                  const SizedBox(width: 5),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      EmbedHelper.backText,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => hide = true),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF4F6FF),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFF333333),
                        size: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
