import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';

class UploadImageFailView extends StatefulWidget {
  const UploadImageFailView({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UploadImageFailViewState();
  }
}

class UploadImageFailViewState extends State<UploadImageFailView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(duration: const Duration(seconds: 20000), vsync: this);
    _animation = Tween(begin: .0, end: 10000.0).animate(_animationController);
    //开始动画
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: const LoadAssetImage(
        'realname/icon_card_upload_fail',
        fit: BoxFit.fill,
        height: 22,
        width: 22,
      ),
    );
  }
}
