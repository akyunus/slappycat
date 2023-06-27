import 'dart:async';

import 'package:flame/components.dart';
import 'package:slappycat/game/components/mover.dart';
import 'package:slappycat/gen/assets.gen.dart';

class Butterfly extends Mover {
  Butterfly({required super.initialPosition});

  SpriteAnimation? _animation;

  SpriteAnimation get animation => _animation!;
  @override
  Future<void> onLoad() async {
   

    _animation = await gameRef.loadSpriteAnimation(
      Assets.images.butterfly12.path,
      SpriteAnimationData.sequenced(
        amount: 27,
        stepTime: 0.02,
        textureSize: Vector2(244, 164),
      ),
    );
    component =
        SpriteAnimationComponent(animation: _animation, size: Vector2.all(64));

    return super.onLoad();
  }
}
