import 'dart:math';

import 'package:flutter/material.dart';

class UniCoinCreateProgress extends StatefulWidget {
  final double radius;
  final double padding;
  final Color color;
  final Duration duration;
  final Widget child;

  const UniCoinCreateProgress({
    Key? key,
    this.radius = 48.0,
    this.padding = 10.0,
    this.color = const Color(0xFF333333),
    this.duration = const Duration(milliseconds: 2500),
    required this.child,
  }) : super(key: key);

  @override
  State<UniCoinCreateProgress> createState() => _UniCoinCreateProgressState();
}

class _UniCoinCreateProgressState extends State<UniCoinCreateProgress>
    with SingleTickerProviderStateMixin {
  late final controller =
      AnimationController(vsync: this, duration: widget.duration);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.repeat();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final angleTween = Tween<double>(begin: 0, end: 2 * pi);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: [
            Transform.rotate(
              angle: angleTween.evaluate(controller),
              child: child!,
            ),
            SizedBox(
              width: widget.radius - widget.padding,
              height: widget.radius - widget.padding,
              child: widget.child,
            )
          ],
        );
      },
      child: CustomPaint(
        painter: _UniCoinCreateProgressPainter(
          padding: widget.padding,
          color: widget.color,
        ),
        child: SizedBox(
          width: widget.radius - widget.padding,
          height: widget.radius - widget.padding,
        ),
      ),
    );
  }
}

class _UniCoinCreateProgressPainter extends CustomPainter {
  final double padding;
  final Color color;
  final double colorOpacityStep;
  final int count;
  final double radius;
  final double radiusStep;
  final _paint = Paint()..isAntiAlias = true;

  _UniCoinCreateProgressPainter({
    required this.padding,
    required this.color,
    this.colorOpacityStep = 0.2,
    this.count = 5,
    this.radius = 2.5,
    this.radiusStep = 0.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    drawDot(canvas, size);
  }

  void drawDot(Canvas canvas, Size size) {
    final dy = (size.width + padding) / 2.0;
    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);
    for (double i = 0; i < count; i++) {
      canvas.save();
      double deg = -90 / count * i;
      canvas.rotate(deg / 180.0 * pi);
      canvas.drawCircle(
        Offset(0, dy),
        max(radius - i * radiusStep, 0),
        _paint..color = color.withOpacity(1.0 - max(i * colorOpacityStep, 0)),
      );
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _UniCoinCreateProgressPainter oldDelegate) {
    return oldDelegate.padding != padding || oldDelegate.color != color;
  }
}
