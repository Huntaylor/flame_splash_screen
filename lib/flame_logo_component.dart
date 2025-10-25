import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame_splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class FlameLogoComponent extends PositionComponent
    with HasGameReference<FlameSplashScreen> {
  FlameLogoComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.topLeft);
  late ui.Gradient gradient1;
  late ui.Gradient gradient2;
  late ui.Gradient gradient3;
  final Paint redPaint = Paint()
    ..color = const ui.Color.fromARGB(255, 232, 0, 46);

  final Paint yellowPaint = Paint()
    ..color = const Color.fromARGB(255, 255, 197, 49);
  final Paint orangePaint = Paint()
    ..color = const Color.fromARGB(255, 255, 145, 54);

  final Paint greyPaint = Paint()
    ..color = const Color.fromARGB(255, 196, 196, 196);
  late Paint gradientPaint1;
  late Paint gradientPaint2;
  late Paint gradientPaint3;

  @override
  FutureOr<void> onLoad() {
    gradient1 = ui.Gradient.linear(
      Offset(center.x, 0),
      Offset(center.x, size.y),
      [
        redPaint.color,
        orangePaint.color,
        yellowPaint.color,
      ],
      [
        0.1,
        .6,
        .9,
      ],
    );
    gradient2 = ui.Gradient.linear(
      Offset(center.x, size.y / 3.5),
      Offset(center.x, size.y),
      [
        redPaint.color,
        orangePaint.color,
        yellowPaint.color,
      ],
      [
        0.2,
        .6,
        .8,
      ],
    );
    gradient3 = ui.Gradient.linear(
      Offset(center.x, size.y / 3),
      Offset(center.x, size.y + 15),
      [
        redPaint.color,
        orangePaint.color,
        yellowPaint.color,
      ],
      [
        0.1,
        .5,
        .8,
      ],
    );
    gradientPaint1 = Paint()..shader = gradient1;
    gradientPaint2 = Paint()..shader = gradient2;
    gradientPaint3 = Paint()..shader = gradient3;

    debugMode = true;
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final cX = size.x;
    final cY = size.y;
    canvas.drawCircle(Offset(cX / 2, cY / 1.52), size.x / 1.9, greyPaint);

    final middleFlame = Path()
      ..moveTo(cX / 3.2, cY / 1.85)
      ..cubicTo(
        cX / 1.6,
        cY / 3.04,
        cX / 2.95,
        cY / 94.2,
        cX / 2.95,
        cY / 94.2,
      )
      ..cubicTo(
        cX / 2.8,
        cY / 97,
        cX / 1.15,
        cY / 4.3,
        cX / 1.35,
        cY / 1.52,
      )
      ..cubicTo(
        cX / 1.3,
        cY / 1.3,
        cX / 1.5,
        cY / 1.4,
        cX / 1.8,
        cY / 1.1,
      )
      ..cubicTo(
        cX / 2.2,
        cY / 1.4,
        cX / 2.5,
        cY / 1.2,
        cX / 2.9,
        cY / 1.6,
      )
      ..cubicTo(
        cX / pi,
        cY / 1.7,
        cX / 3.2,
        cY / 1.7,
        cX / 3.2,
        cY / 1.9,
      );
    canvas.drawPath(middleFlame, gradientPaint1);

    final rightFlame = Path()
      ..moveTo(
        cX / 1.8,
        cY / 1.3,
      )
      ..cubicTo(
        cX / 1.01,
        cY / 1.75,
        cX / 1.26,
        cY / 2.9,
        cX / 1.25,
        cY / 2.9,
      )
      ..cubicTo(
        cX / 1.25,
        cY / 2.9,
        cX / 0.9,
        cY / 1.6,
        cX / 1.12,
        cY / 1.13,
      )
      ..cubicTo(
        cX / 1.12,
        cY / 1.13,
        cX / 1.44,
        cY / 1.2,
        cX / 1.8,
        cY / 1.3,
      );
    canvas.drawPath(rightFlame, gradientPaint2);

    final leftFlame = Path()
      ..moveTo(
        cX / 7.43,
        cY / 1.1031,
      )
      ..cubicTo(
        cX / 19.5,
        cY / 1.1950,
        cX / 95.6091,
        cY / 1.3416,
        cX / 56.6491,
        cY / 1.5300,
      )
      ..cubicTo(
        cX / 27.1865,
        cY / 2.4428,
        cX / pi,
        cY / 6.7880,
        cX / pi,
        cY / 6.7880,
      )
      ..cubicTo(
        cX / pi,
        cY / 6.7880,
        cX / 4.7155,
        cY / 2.3847,
        cX / 2.8794,
        cY / 1.6679,
      )
      ..cubicTo(
        cX / 2.0830,
        cY / 1.2881,
        cX / 1.2472,
        cY / 1.1631,
        cX / 1.1174,
        cY / 1.1329,
      )
      ..cubicTo(
        cX / 1.2605,
        cY / 1.0528,
        cX / 1.5229,
        cY / 1.0068,
        cX / 2.0026,
        cY / 1.0068,
      )
      ..cubicTo(
        cX / 2.7774,
        cY / 1.0068,
        cX / 4.3006,
        cY / 1.0411,
        cX / 7.4310,
        cY / 1.1031,
      );
    canvas.drawPath(leftFlame, gradientPaint3);
  }
}
