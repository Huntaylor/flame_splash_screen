import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:new_flame_splash_screen/splash_screen.dart';

const double particleLayerRadius1 = 130;
const double particleLayerRadius2 = 122;

const int particleLayerPriority1 = 1;
const int particleLayerPriority2 = 2;
const int particleLayerPriority3 = 3;

Color lerpColor1 = Colors.yellow;
Color lerpColor2 = Colors.amber[900]!;

Color particleLayerColor1 = Colors.orange;
Color particleLayerColor2 = Colors.deepOrange;

double growingOuterRadius = 0;
double growingInnerRadius = 0;

late CircleComponent innerCircle;

class FireComponent extends CircleComponent
    with HasGameReference<NewSplashScreen> {
  FireComponent({
    super.position,
    super.priority = 3,
    super.anchor = Anchor.center,
  }) : super();
  MoveToEffect? moveToEffect;

  bool isMoving = false;
  bool canCheckMoving = false;

  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  late TimerComponent showBackground;

  late Vector2 nextPosition;

  @override
  Future<void> onLoad() {
    innerCircle = CircleComponent(
      priority: particleLayerPriority2,
      position: Vector2(8.5, 8.5),
      anchor: Anchor.topLeft,
      // paint: Paint()..color = lerpColor1,
      paint: Paint()..color = Colors.transparent,
      // radius: growingInnerRadius / 2,
      radius: particleLayerRadius2,
    );

    showBackground = TimerComponent(
      period: .1,
      autoStart: true,
      repeat: false,
      onTick: () {
        paint = Paint()..color = particleLayerColor1;
        innerCircle.paint = Paint()..color = lerpColor1;
      },
    );
    nextPosition = position;
    debugColor = Colors.greenAccent;
    createShape();
    return super.onLoad();
  }

  bool checkPosition(Vector2 currentPosition) {
    double xRounded = currentPosition.x.roundToDouble();
    double yRounded = currentPosition.y.roundToDouble();
    double xNextRounded = nextPosition.x.roundToDouble();
    double yNextRounded = nextPosition.y.roundToDouble();

    if (xRounded == xNextRounded && yNextRounded == (yRounded + 1)) {
      yRounded = yRounded + 1;
    }

    return Vector2(xRounded, yRounded) != Vector2(xNextRounded, yNextRounded);
  }

  void moveFire(Vector2 newPosition) {
    canCheckMoving = true;
    nextPosition = newPosition;

    if (position == newPosition) {
      return;
    }

    MoveToEffect effect;
    if (moveToEffect != null) {
      if (!moveToEffect!.controller.completed) {
        remove(moveToEffect!);
        effect = getMoveEffect(newPosition);
        moveToEffect = effect;
        add(moveToEffect!);
        return;
      }
    }
    effect = getMoveEffect(newPosition);

    moveToEffect = effect;
    add(moveToEffect!);
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      showBackground.update(dt);
      loadParticles();
      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  void createShape() {
    paint = Paint()..color = Colors.transparent;
    // paint = Paint()..color = particleLayerColor1;
    // radius = growingOuterRadius;
    radius = particleLayerRadius1;
    add(
      innerCircle,
    );
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
                final progress = particle.progress;
                final alpha = (1 - progress).clamp(0.0, 1.0) * (1 - i * 0.15);
                canvas.drawCircle(
                  Offset.zero,
                  fireParticle.radius,
                  Paint()
                    ..color = Color.lerp(
                      lerpColor1.withValues(alpha: alpha),
                      lerpColor2.withValues(alpha: alpha),
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
                final progress = particle.progress;
                final alpha = (1 - progress).clamp(0.0, 1.0) * (1 - i * 0.15);
                canvas.drawCircle(
                  Offset.zero,
                  fireParticle.radius,
                  Paint()
                    ..color = Color.lerp(
                      particleLayerColor1.withValues(alpha: alpha),
                      particleLayerColor2.withValues(alpha: alpha),
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
    double xSpeed = rnd.nextDouble() * 600 - 300;
    return Vector2(
      xSpeed,
      _getDirection(),
    );
  }

  double _getDirection() {
    return -size.y - 600;
  }

  MoveToEffect getMoveEffect(Vector2 newPosition) {
    return MoveToEffect(
      newPosition,
      EffectController(
        speed: 700,
      ),
    );
  }
}
