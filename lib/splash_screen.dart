import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:new_flame_splash_screen/components/flame_logo_component.dart';
import 'package:new_flame_splash_screen/components/flutter_logo_component.dart';
import 'package:flutter/material.dart';

const double particleLayerRadius1 = 100;
const double particleLayerRadius3 = 22;

const int particleLayerPriority1 = 1;
const int particleLayerPriority2 = 2;
const int particleLayerPriority3 = 3;

const Color lerpColor1 = Colors.white;
const Color lerpColor2 = Colors.amber;

class NewSplashScreen extends FlameGame {
  NewSplashScreen() : super();

  @override
  FutureOr<void> onLoad() {
    camera.viewfinder.anchor = Anchor.topLeft;
    world.addAll([
      FlutterLogoComponent(
        position: Vector2(
          size.x / 2,
          size.y / 2,
        ),
        size: Vector2.all(200),
      ),
      // FlameLogoComponent(
      //   position: Vector2(50, 50),
      //   size: Vector2(205, 320),
      // ),
    ]);
    return super.onLoad();
  }
}
