import 'package:flame/components.dart';
import 'package:slappycat/game/components/mover.dart';
import 'package:slappycat/gen/assets.gen.dart';

class Box2 extends Mover {
  Box2({
    required super.initialPosition,
  });

  @override
  Future<void> onLoad() async {
    component = SpriteComponent(
      sprite: await gameRef.loadSprite(Assets.images.reddot.path),
    );

    await super.onLoad();
  }
}
