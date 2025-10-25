import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:new_flame_splash_screen/components/flame_logo_component.dart';
import 'package:new_flame_splash_screen/components/flutter_logo_component.dart';
import 'package:flutter/material.dart';
import 'package:new_flame_splash_screen/components/fire_component.dart';
import 'package:new_flame_splash_screen/components/hide_fire_component.dart';

const double particleLayerRadius1 = 100;
const double particleLayerRadius3 = 22;

const int particleLayerPriority1 = 1;
const int particleLayerPriority2 = 2;
const int particleLayerPriority3 = 3;

const Color lerpColor1 = Colors.white;
const Color lerpColor2 = Colors.amber;

class NewSplashScreen extends FlameGame {
  late FireComponent fireComponent;
  late FlutterLogoComponent flutterLogoComponent;
  late FlameLogoComponent flameLogoComponent;
  late HideFireComponent hideFireComponent;
  NewSplashScreen()
    : super(
        camera: CameraComponent.withFixedResolution(
          width: 576,
          height: 832,
        ),
      );

  late TimerComponent showFlameLogoTimer;
  late TimerComponent showFireTimer;
  late TimerComponent hideFlutterLogoTimer;

  late Vector2 firePosition;

  @override
  FutureOr<void> onLoad() {
    firePosition = Vector2(
      camera.visibleWorldRect.width / 2,
      camera.visibleWorldRect.height / 1.65,
    );
    hideFireComponent = HideFireComponent();

    showFlameLogoTimer = TimerComponent(
      period: 2.25,
      autoStart: false,
      repeat: false,
      onTick: () {
        world.removeAll([
          fireComponent,
        ]);
        world.add(flameLogoComponent);
      },
    );

    showFireTimer = TimerComponent(
      period: 2.35,
      autoStart: true,
      repeat: false,
      onTick: () {
        showFlameLogoTimer.timer.start();
        hideFlutterLogoTimer.timer.start();

        world.addAll([
          fireComponent,
          hideFireComponent,
        ]);
        fireComponent.moveFire(firePosition);
      },
    );

    hideFlutterLogoTimer = TimerComponent(
      period: .75,
      autoStart: false,
      repeat: false,
      onTick: () {
        world.remove(
          flutterLogoComponent,
        );
      },
    );

    fireComponent = FireComponent(
      position: Vector2(
        camera.visibleWorldRect.width / 2,
        camera.visibleWorldRect.height / 1,
      ),
    );

    flutterLogoComponent = FlutterLogoComponent(
      position: Vector2(
        camera.visibleWorldRect.width / 2,
        camera.visibleWorldRect.height / 2,
      ),
      size: Vector2.all(200),
    );

    flameLogoComponent = FlameLogoComponent(
      position: Vector2(
        camera.visibleWorldRect.width / 2,
        camera.visibleWorldRect.height / 2.3,
      ),
      size: Vector2(205, 320),
    );

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(flutterLogoComponent);
    // world.addAll([
    //   fireComponent,
    //   hideFireComponent,
    // ]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    showFireTimer.update(dt);
    showFlameLogoTimer.update(dt);
    hideFlutterLogoTimer.update(dt);
    super.update(dt);
  }
}
