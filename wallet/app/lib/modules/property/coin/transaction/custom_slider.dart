import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_wallet_assets/flutter_wallet_assets.dart';

// ignore: must_be_immutable
class CustomSlider extends StatelessWidget {
  final double dx;
  final Function(double) onChanged;
  final Function()? onChangeStart;
  final Function()? onChangeEnd;

  CustomSlider(this.dx, {Key? key, required this.onChanged, this.onChangeStart, this.onChangeEnd}) : super(key: key);

  var width = 350.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          SizedBox(
            height: 6,
            width: double.infinity,
            child: CustomPaint(
              painter: SliderPainter(dx, (width) {
                this.width = width;
              }),
            ),
          ),
          const SizedBox(height: 2),
          Stack(
            children: [
              Container(
                height: 15,
                color: Colors.transparent,
                width: double.infinity,
              ),
              Align(
                  child: const WalletLoadAssetImage(
                    'common/thumb_seek',
                    width: 15,
                    height: 15,
                  ),
                  alignment: FractionalOffset(dx, 0)),
            ],
          ),
        ],
      ),
      onTapDown: (details) {
        updateDx(getPoint(context, details.globalPosition));
        if (onChangeStart != null) {
          onChangeStart!.call();
        }
      },
      onTapUp: (details) {
        if (onChangeEnd != null) {
          onChangeEnd!.call();
        }
      },
      onPanUpdate: (details) {
        updateDx(getPoint(context, details.globalPosition));
      },
      onPanEnd: (details) {
        if (onChangeEnd != null) {
          onChangeEnd!.call();
        }
      },
    );
  }

  Offset getPoint(BuildContext context, Offset globalPosition) {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    return renderBox!.globalToLocal(globalPosition);
  }

  void updateDx(Offset value) {
    double progress = value.dx;
    progress = progress < 0 ? 0 : progress;
    progress = progress > width ? width : progress;

    setValue(progress / width);
  }

  void setValue(double progress) {
    onChanged(progress);
  }
}

class SliderPainter extends CustomPainter {
  final double dx;

  final Function(double width) setWidth;

  Paint lineP = Paint();
  Paint lineBG = Paint();

  SliderPainter(this.dx, this.setWidth) {
    lineP.color = const Color(0xFF231815);
    lineBG.color = const Color(0xFFEEEEEE);
  }

  final dotWidth = 3.0;
  final linePercent = 2;

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    setWidth(width);
    lineP.strokeWidth = height / linePercent;
    lineBG.strokeWidth = height / linePercent;
    //绘制灰色背景 和 三个点
    canvas.drawLine(Offset(0, height / linePercent), Offset(width, height / linePercent), lineBG);
    canvas.drawRect(Rect.fromLTWH(width - dotWidth, 0, dotWidth, height), lineBG);
    canvas.drawRect(Rect.fromLTWH(0, 0, dotWidth, height), lineBG);
    canvas.drawRect(Rect.fromLTWH(width / 2 - dotWidth, 0, dotWidth, height), lineBG);

    //绘制进度 和 两个点
    canvas.drawLine(Offset(0, height / linePercent), Offset(dx * (width - 15) + 15 / 2, height / linePercent), lineP);
    canvas.drawRect(Rect.fromLTWH(0, 0, dotWidth, height), lineP);
    canvas.drawRect(Rect.fromLTWH(dx * (width - 15) + 15 / 2 - dotWidth, 0, dotWidth, height), lineP);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
