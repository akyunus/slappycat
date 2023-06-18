import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/material.dart';
import 'package:slappycat/game/entities/unicorn/behaviors/tapping_behavior.dart';
import 'package:slappycat/gen/assets.gen.dart';

class Unicorn extends PositionedEntity with HasGameRef {
  Unicorn({
    required super.position,
  }) : super(
          anchor: Anchor.center,
          size: Vector2.all(32),
          behaviors: [
            TappingBehavior(),
          ],
        );

  @visibleForTesting
  Unicorn.test({
    required super.position,
    super.behaviors,
  }) : super(size: Vector2.all(32));

  SpriteAnimation? _animation;

  @visibleForTesting
  SpriteAnimation get animation => _animation!;

  @override
  Future<void> onLoad() async {
    _animation = await gameRef.loadSpriteAnimation(
      Assets.images.unicornAnimation.path,
      SpriteAnimationData.sequenced(
        amount: 16,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );

    resetAnimation();
    //animation.onComplete = resetAnimation;

    await add(SpriteAnimationComponent(animation: _animation, size: size));
  }

  /// Set the animation to the first frame by tricking the animation
  /// into thinking it finished the last frame.
  void resetAnimation() {
  
  }

  /// Plays the animation.
  void playAnimation() {}

  /// Returns whether the animation is playing or not.
  bool isAnimationPlaying() => true;
}
