import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:slappycat/game/game.dart';
import 'package:slappycat/gen/assets.gen.dart';

class MyBox extends SpriteComponent
    with HasGameRef<SlappyCatGame>, TapCallbacks {
  MyBox({
    required this.gridPosition,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  final Vector2 gridPosition;
  late Vector2 velocity;
  late final Timer selfDestruction;
  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite(Assets.images.reddot.path);
    position = gridPosition;
    velocity = Vector2.random() * 50;
    selfDestruction = Timer(7, onTick: () {
      gameRef.effectPlayer.play(AssetSource(Assets.audio.drop003));
      gameRef.removeBox(this);
    });
    /*
    add(
      MoveEffect.to(
        Vector2(380, 50),
        EffectController(
          duration: 3,
          reverseDuration: 3,
          infinite: true,
          curve: Curves.easeOut,
        ),
      ),
    );
    */
    print("size.x ${game.size.x}");
    print(game.size.y);
    final paths = List<double>.generate(
      12,
      (i) {
        return (i % 2 == 0)
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
    gameRef.effectPlayer.play(AssetSource(Assets.audio.drop004));
  }

  @override
  void update(double dt) {
    super.update(dt);
    selfDestruction.update(dt);
    position.add(velocity * dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // TODO: implement onTapDown
    super.onTapDown(event);

    addExplosion();
    gameRef.effectPlayer.play(AssetSource(Assets.audio.drop002));
    gameRef.removeBox(this);
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
    game.add(ParticleSystemComponent(
        particle: Particle.generate(
            count: 50,
            generator: (i) {
              Vector2 position = this.position;
              Vector2 speed = Vector2.zero();
              final acceleration = randomVector2();
              final paint = Paint()..color = randomColor();
              final radius = game.random.nextInt(6).toDouble();
              return ComputedParticle(renderer: (canvas, _) {
                speed += acceleration;
                position += speed;
                canvas.drawCircle(
                    Offset(position.x, position.y), radius, paint);
              });
            })));
  }
}
