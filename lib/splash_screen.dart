import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flame_splash_screen/flame_logo_component.dart';
import 'package:flame_splash_screen/flutter_logo_component.dart';
import 'package:flutter/material.dart';

const double particleLayerRadius1 = 100;
const double particleLayerRadius3 = 22;

const int particleLayerPriority1 = 1;
const int particleLayerPriority2 = 2;
const int particleLayerPriority3 = 3;

const Color lerpColor1 = Colors.white;
const Color lerpColor2 = Colors.amber;

class FlameSplashScreen extends FlameGame {
  FlameSplashScreen() : super();

  @override
  FutureOr<void> onLoad() {
    camera.viewfinder.anchor = Anchor.topLeft;
    world.addAll([
      Sparks(
        position: Vector2(250, 75),
      ),
      FlutterLogoComponent(position: Vector2(250, 75)),
      FlameLogoComponent(
        position: Vector2(500, 75),
        size: Vector2(205, 320),
      ),
    ]);
    return super.onLoad();
  }
}

class Sparks extends CircleComponent with HasGameReference<FlameSplashScreen> {
  Sparks({super.position, super.priority = 3, super.anchor = Anchor.center})
    : super();

  final rnd = Random();
  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  var positions = [
    Vector2(500, 500),
    Vector2(-500, 500),
    Vector2(500, -500),
    Vector2(250, 500),
    Vector2(500, 250),
    Vector2(-250, 500),
    Vector2(10, -250),
  ];

  late TimerComponent timer;
  var fireParticles = false;

  void loadParticles() {
    Vector2 speed = getConsistentSpeed();

    final particleSystem = ParticleSystemComponent(
      particle: getSparksParticleComponent(speed: speed),
    );

    game.world.addAll(
      [
        particleSystem..priority = particleLayerPriority1,
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
    // particleFireTimer = TimerComponent(
    //   period: .1,
    //   repeat: true,
    //   onTick: () => loadParticles(),
    // );
    timer = TimerComponent(
      period: 1,
      repeat: true,
      onTick: () {
        fireParticles = !fireParticles;
        // particleFireTimer.timer.stop();
        // loadParticles();
      },
    );
    // createShape();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      timer.update(dt);
      // particleFireTimer.update(dt);
      // if (fireParticles) {
      loadParticles();
      // }

      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  Particle getSparksParticleComponent({
    required Vector2 speed,
  }) {
    return Particle.generate(
      count: 1,
      lifespan: 1,
      generator: (i) {
        final angle = rnd.nextDouble() * pi * 2;
        final speed = 50 + rnd.nextDouble() * 150;
        final velocity = Vector2(
          cos(angle) * speed,
          sin(angle) * speed + 100,
        );

        return AcceleratedParticle(
          acceleration: Vector2(0, 200),
          speed: velocity,
          position: position.clone(),
          child: Particle.generate(
            count: 3,
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
                    Colors.amber[800]!.withValues(alpha: alpha),
                    progress,
                  )!;

                  final paint = Paint()
                    ..color = color
                    ..strokeWidth = 2 * trailSize
                    ..strokeCap = StrokeCap.round;

                  final offset = Offset(
                    -velocity.x * 0.02 * j,
                    -velocity.y * 0.02 * j,
                  );

                  canvas.drawCircle(offset, 2 * trailSize, paint);

                  // canvas.drawLine(
                  //   offset,
                  //   offset + Offset(0, -4 * trailSize),
                  //   paint,
                  // );
                },
              );
            },
          ),
        );
      },
    );
  }

  Vector2 getConsistentSpeed() {
    return Vector2(rnd.nextDouble() * 55 - 30, _getDirection());
  }

  double _getDirection() {
    return -size.y - 50;
  }
}
