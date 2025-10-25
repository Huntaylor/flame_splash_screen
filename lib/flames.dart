import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:new_flame_splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

class Flames extends CircleComponent with HasGameReference<NewSplashScreen> {
  Flames({super.position, super.priority = 3, super.anchor = Anchor.center})
    : super();

  final rnd = Random();
  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  void loadParticles() {
    final firstParticle = getParticle(
      radius: particleLayerRadius1,
      particleColor: Paint()..color = lerpColor1,
    );

    Vector2 speed = getConsistentSpeed();

    final firstParticleComponent = getOuterParticleSystem(
      speed: speed,
      fireParticle: firstParticle,
    );

    game.world.addAll(
      [
        firstParticleComponent..priority = particleLayerPriority1,
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
    createShape();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      loadParticles();
      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  ParticleSystemComponent getOuterParticleSystem({
    required Vector2 speed,
    required CircleParticle fireParticle,
  }) {
    return ParticleSystemComponent(
      position: position.clone(),
      anchor: Anchor.center,
      particle: Particle.generate(
        count: 1,
        lifespan: .65,
        generator: (i) => AcceleratedParticle(
          speed: speed,
          child: ScalingParticle(
            child: ComputedParticle(
              renderer: (canvas, particle) {
                canvas.drawCircle(
                  Offset.zero,
                  fireParticle.radius,
                  Paint()
                    ..color = Color.lerp(
                      lerpColor1,
                      lerpColor2,
                      particle.progress,
                    )!,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  CircleParticle getParticle({
    required Paint particleColor,
    required double radius,
  }) {
    return CircleParticle(radius: radius, paint: particleColor);
  }

  Vector2 getConsistentSpeed() {
    return Vector2(rnd.nextDouble() * 55 - 30, _getDirection());
  }

  double _getDirection() {
    return -size.y - 50;
  }
}
