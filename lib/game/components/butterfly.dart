import 'dart:async';

import 'package:flame/components.dart';
import 'package:slappycat/game/game.dart';
import 'package:slappycat/gen/assets.gen.dart';

class Butterfly extends PositionComponent with HasGameRef<SlappyCatGame> {
  SpriteAnimation? _animation;

  SpriteAnimation get animation => _animation!;
  @override
  Future<void> onLoad() async {
    position = Vector2.all(100);
    _animation = await gameRef.loadSpriteAnimation(
      Assets.images.unicornAnimation.path,
      SpriteAnimationData.sequenced(
        amount: 16,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
      ),
    );

    await add(
      SpriteAnimationComponent(animation: _animation, size: Vector2.all(64)),
    );
    return super.onLoad();
  }
}
