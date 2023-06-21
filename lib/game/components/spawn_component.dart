import 'dart:async';

import 'package:flame/components.dart';
import 'package:slappycat/game/game.dart';

class SpawnComponent extends TimerComponent with HasGameRef<SlappyCatGame> {
  SpawnComponent({
    required super.period,
    this.max = 3,
  }) : super(repeat: true);
  final int max;
  int current = 0;

  @override
  FutureOr<void> onLoad() {
    return super.onLoad();
  }

  @override
  void onTick() {
    super.onTick();
    gameRef.addComponent();
  }
}
