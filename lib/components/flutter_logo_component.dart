import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:new_flame_splash_screen/components/sparks_component.dart';
import 'package:new_flame_splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class FlutterLogoComponent extends PositionComponent
    with HasGameReference<NewSplashScreen> {
  FlutterLogoComponent({
    required Vector2 size,
    required Vector2 position,
  }) : super(position: position, anchor: Anchor.center, size: size);

  @override
  FutureOr<void> onLoad() {
    final sparksPosition = position.clone();
    add(
      Sparks(
        position: sparksPosition,
      ),
    );
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.save();

    final Paint lightPaint = Paint()..color = const Color(0xFF54C5F8);
    final Paint mediumPaint = Paint()..color = const Color(0xFF29B6F6);
    final Paint darkPaint = Paint()..color = const Color(0xFF01579B);

    final ui.Gradient triangleGradient = ui.Gradient.linear(
      const Offset(87.2623 + 37.9092, 28.8384 + 123.4389),
      const Offset(42.9205 + 37.9092, 35.0952 + 123.4389),
      <Color>[const Color(0x001A237E), const Color(0x661A237E)],
    );
    final Paint trianglePaint = Paint()..shader = triangleGradient;

    final Path topBeam = Path()
      ..moveTo(37.7, 128.9)
      ..lineTo(9.8, 101.0)
      ..lineTo(100.4, 10.4)
      ..lineTo(156.2, 10.4);
    canvas.drawPath(topBeam, lightPaint);

    final Path middleBeam = Path()
      ..moveTo(156.2, 94.0)
      ..lineTo(100.4, 94.0)
      ..lineTo(78.5, 115.9)
      ..lineTo(106.4, 143.8);
    canvas.drawPath(middleBeam, lightPaint);

    final Path bottomBeam = Path()
      ..moveTo(79.5, 170.7)
      ..lineTo(100.4, 191.6)
      ..lineTo(156.2, 191.6)
      ..lineTo(107.4, 142.8);
    canvas.drawPath(bottomBeam, darkPaint);

    canvas.save();
    canvas.transform(
      Float64List.fromList(const <double>[
        0.7071,
        -0.7071,
        0.0,
        0.0,
        0.7071,
        0.7071,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        -77.697,
        98.057,
        0.0,
        1.0,
      ]),
    );
    canvas.drawRect(const Rect.fromLTWH(59.8, 123.1, 39.4, 39.4), mediumPaint);
    canvas.restore();

    final Path triangle = Path()
      ..moveTo(79.5, 170.7)
      ..lineTo(120.9, 156.4)
      ..lineTo(107.4, 142.8);
    canvas.drawPath(triangle, trianglePaint);

    canvas.restore();
  }
}
