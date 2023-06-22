import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:slappycat/game/game.dart';
import 'package:slappycat/gen/assets.gen.dart';

class Mover extends PositionComponent
    with HasGameRef<SlappyCatGame>, TapCallbacks {
  Mover({
    required this.initialPosition,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  final Vector2 initialPosition;
  late Vector2 velocity;
  late final Timer selfDestruction;
  @override
  Future<void> onLoad() async {
    position = initialPosition;
    selfDestruction = Timer(
      7,
      onTick: () {
        gameRef.effectPlayer.play(AssetSource(Assets.audio.drop003));
        gameRef.removeComponent(this);
      },
    );

    final paths = List<double>.generate(
      12,
      (i) {
        return (i.isEven)
            ? gameRef.random.nextInt(gameRef.size.x.toInt()).toDouble()
            : gameRef.random.nextInt(game.size.y.toInt()).toDouble();
      },
    );
    add(
      MoveAlongPathEffect(
        Path()
          ..quadraticBezierTo(
            0,
            0,
            paths.elementAt(2),
            paths.elementAt(3),
          )
          ..quadraticBezierTo(
            paths.elementAt(4),
            paths.elementAt(5),
            paths.elementAt(6),
            paths.elementAt(7),
          )
          ..quadraticBezierTo(
            paths.elementAt(8),
            paths.elementAt(9),
            paths.elementAt(10),
            paths.elementAt(11),
          ),
        EffectController(
          duration: 7,
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    selfDestruction.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    addExplosion();
    gameRef.effectPlayer.play(AssetSource(Assets.audio.drop002));
    gameRef.removeComponent(this);
  }

  Vector2 randomVector2() =>
      (Vector2.random(gameRef.random) - Vector2.random(game.random)) * 2;
  Color randomColor() {
    return Color.fromRGBO(
      game.random.nextInt(100) + 155,
      game.random.nextInt(100),
      game.random.nextInt(50),
      game.random.nextInt(50) + 50 / 100,
    );
  }

  void addExplosion() {
    game.add(
      ParticleSystemComponent(
        particle: Particle.generate(
          count: 50,
          generator: (i) {
            Vector2 position = this.position;
            var speed = Vector2.zero();
            final acceleration = randomVector2();
            final paint = Paint()..color = randomColor();
            final radius = game.random.nextInt(6).toDouble();
            return ComputedParticle(
              renderer: (canvas, _) {
                speed += acceleration;
                position += speed;
                canvas.drawCircle(
                    Offset(position.x, position.y), radius, paint,);
              },
            );
          },
        ),
      ),
    );
  }
}
