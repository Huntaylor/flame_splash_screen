import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:new_flame_splash_screen/splash_screen.dart';

const double particleLayerRadius1 = 110;
const double particleLayerRadius2 = 102;

const int particleLayerPriority1 = 1;
const int particleLayerPriority2 = 2;
const int particleLayerPriority3 = 3;

Color lerpColor1 = Colors.yellow;
Color lerpColor2 = Colors.amber[900]!;

Color particleLayerColor1 = Colors.orange;
Color particleLayerColor2 = Colors.deepOrange;

double growingOuterRadius = 0;
double growingInnerRadius = 0;

late RectangleComponent innerRect;

class RectFireComponent extends RectangleComponent
    with HasGameReference<NewSplashScreen> {
  RectFireComponent({
    super.position,
    super.priority = 3,
    super.anchor = Anchor.center,
  }) : super();

  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  late Vector2 nextPosition;

  @override
  FutureOr<void> onLoad() {
    // final rect = Rect.fromCircle(
    //   center: Offset.zero,
    //   radius: particleLayerRadius2,
    // );

    innerRect = RectangleComponent(
      paint: Paint()..color = lerpColor2,
      size: size / 1.1,
    );
    // innerCircle = CircleComponent(
    //   priority: particleLayerPriority2,
    //   position: Vector2(8.5, 8.5),
    //   anchor: Anchor.topLeft,
    //   paint: Paint()..color = lerpColor1,
    //   radius: particleLayerRadius2,
    // );

    nextPosition = position;
    debugColor = Colors.greenAccent;
    createShape();
    return super.onLoad();
  }

  // @override
  // Future<void> onLoad() {
  //   innerCircle = CircleComponent(
  //     priority: particleLayerPriority2,
  //     position: Vector2(8.5, 8.5),
  //     anchor: Anchor.topLeft,
  //     paint: Paint()..color = lerpColor1,
  //     radius: particleLayerRadius2,
  //   );

  //   nextPosition = position;
  //   debugColor = Colors.greenAccent;
  //   createShape();
  //   super.onLoad();
  // }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      // increaseRadiusTimer.update(dt);
      // loadParticles();
      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  void createShape() {
    paint = Paint()..color = particleLayerColor1;
    size = Vector2.all(100);

    // radius = growingOuterRadius;
    // radius = particleLayerRadius1;
    add(innerRect);
  }

  void loadParticles() {
    final firstParticle = getParticle(
      // radius: growingOuterRadius,
      radius: particleLayerRadius1,
      particleColor: Paint()..color = particleLayerColor1,
    );
    final secondParticle = getParticle(
      // radius: growingInnerRadius,
      radius: particleLayerRadius2,
      particleColor: Paint()..color = lerpColor1,
    );

    Vector2 speed = getConsistentSpeed();

    final firstParticleComponent = getOuterParticleSystem(
      speed: speed,
      fireParticle: firstParticle,
    );

    final secondParticleComponent = getParticleSystem(
      speed: speed,
      fireParticle: secondParticle,
    );

    game.world.addAll(
      [
        firstParticleComponent..priority = particleLayerPriority1,
        secondParticleComponent..priority = particleLayerPriority3,
      ],
    );
  }

  ParticleSystemComponent getParticleSystem({
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
          acceleration: Vector2(0, 200),
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
                      particleLayerColor1,
                      particleLayerColor2,
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

  final rnd = Random();

  CircleParticle getParticle({
    required Paint particleColor,
    required double radius,
  }) {
    return CircleParticle(
      radius: radius,
      paint: particleColor,
    );
  }

  Vector2 getConsistentSpeed() {
    double xSpeed = rnd.nextDouble() * 400 - 200;
    return Vector2(
      xSpeed,
      _getDirection(),
    );
  }

  double _getDirection() {
    return -size.y - 200;
  }
}
