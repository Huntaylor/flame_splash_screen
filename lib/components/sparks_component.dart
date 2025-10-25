import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:new_flame_splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

class Sparks extends CircleComponent with HasGameReference<NewSplashScreen> {
  Sparks({super.position, super.priority = 10, super.anchor = Anchor.center})
    : super();

  final rnd = Random();
  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  var positions = <Vector2>[];

  late TimerComponent sparksTimer;
  late TimerComponent delayTimer;
  late TimerComponent fasterTimer;

  final sparksPaint = Paint();
  var fireParticles = false;

  var index = 0;

  void loadParticles() {
    final particleSystem = ParticleSystemComponent(
      particle: getSparksParticleComponent(),
    );

    game.world.addAll(
      [
        particleSystem..priority = priority,
      ],
    );
  }

  void createShape() {
    paint = Paint()..color = lerpColor1;
    radius = particleLayerRadius1;
    addAll([
      CircleComponent(
        priority: particleLayerPriority2,
        position: Vector2(size.x / 2, size.y / 2),
        anchor: Anchor.center,
        paint: Paint()..color = lerpColor2,
        radius: particleLayerRadius3,
      ),
    ]);
  }

  @override
  Future<void> onLoad() {
    final flutterPosition = game.flutterLogoComponent.position;
    positions = [
      Vector2(flutterPosition.x / 1.45, flutterPosition.y),
      Vector2(flutterPosition.x * 1.2, flutterPosition.y * 1.22),
      Vector2(flutterPosition.x, flutterPosition.y * 1.22),
    ];
    delayTimer = TimerComponent(
      period: .50,
      autoStart: true,
      repeat: true,
      onTick: () {
        fireParticles = !fireParticles;
        sparksTimer.timer.start();
      },
    );
    sparksTimer = TimerComponent(
      period: .25,
      autoStart: false,
      repeat: false,
      onTick: () {
        moveSparks();
        loadParticles();
      },
    );
    fasterTimer = TimerComponent(
      period: .20,
      repeat: false,
      autoStart: false,
      onTick: () {
        moveSparks();
        loadParticles();
      },
    );

    return super.onLoad();
  }

  void moveSparks() {
    if (index >= positions.length - 1) {
      position = positions[index];
      delayTimer.timer.stop();
      sparksTimer.timer.stop();
      return;
    }

    if (index == 1) {
      fasterTimer.timer.start();
    }
    position = positions[index];
    index++;
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      delayTimer.update(dt);
      if (fireParticles) {
        sparksTimer.update(dt);
        fasterTimer.update(dt);
      }

      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  Particle getSparksParticleComponent() {
    return Particle.generate(
      count: 30,
      lifespan: .75,
      generator: (i) {
        final angle = rnd.nextDouble() * pi * 2;
        final speed = 25 + rnd.nextDouble() * 150;
        final velocity = Vector2(
          cos(angle) * speed,
          sin(angle) * speed - 100,
        );

        return AcceleratedParticle(
          acceleration: Vector2(0, 200),
          speed: velocity,
          position: position.clone(),
          child: Particle.generate(
            count: 4,
            generator: (j) {
              final trailDelay = j * 0.05;
              final trailSize = 1.0 - (j * 0.15);

              return ComputedParticle(
                lifespan: 1.5 - trailDelay,
                renderer: (canvas, particle) {
                  final progress = particle.progress;
                  final alpha = (1 - progress).clamp(0.0, 1.0) * (1 - j * 0.15);

                  final color = Color.lerp(
                    Colors.white.withValues(alpha: alpha),
                    Colors.amberAccent[700]!.withValues(alpha: alpha),
                    progress,
                  )!;

                  paint = sparksPaint
                    ..color = color
                    ..strokeWidth = 2 * trailSize
                    ..strokeCap = StrokeCap.round;

                  final offset = Offset(
                    -velocity.x * 0.02 * j,
                    -velocity.y * 0.02 * j,
                  );

                  canvas.drawCircle(offset, 2 * trailSize, paint);
                },
              );
            },
          ),
        );
      },
    );
  }
}
