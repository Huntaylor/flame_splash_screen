import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:new_flame_splash_screen/splash_screen.dart';

class HideFireComponent extends RectangleComponent
    with HasGameReference<NewSplashScreen> {
  HideFireComponent({
    super.position,
    super.priority = 6,
    super.anchor = Anchor.center,
  }) : super();

  final blackPaint = Paint()..color = Colors.black;
  final firePaint = Paint()..color = Colors.orange;

  late TimerComponent hideOrange;
  late TimerComponent showOrange;
  bool shouldHideOrange = true;

  @override
  FutureOr<void> onLoad() {
    hideOrange = TimerComponent(
      period: 2.22,
      autoStart: true,
      repeat: false,
      onTick: () => shouldHideOrange = true,
    );
    showOrange = TimerComponent(
      period: .325,
      autoStart: true,
      repeat: false,
      onTick: () => shouldHideOrange = false,
    );
    final rectPosX = game.firePosition.x;
    final rectPosY = game.firePosition.y;
    paint = Paint()..color = Colors.transparent;
    size = Vector2(275, 125);
    position = Vector2(rectPosX, rectPosY + 70);
    priority = 6;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    hideOrange.update(dt);
    showOrange.update(dt);
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(width / 2, height / .695),

        width: width * 2,
        height: height * 2.75,
      ),
      blackPaint,
    );
    if (!shouldHideOrange) {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(width / 2, 4),
          width: width / 1.06,
          height: 8,
        ),
        firePaint,
      );
    }

    super.render(canvas);
  }
}
