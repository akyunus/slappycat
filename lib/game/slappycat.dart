import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:slappycat/game/components/box.dart';
import 'package:slappycat/game/components/box2.dart';
import 'package:slappycat/game/components/butterfly.dart';
import 'package:slappycat/game/components/spawn_component.dart';
import 'package:slappycat/l10n/l10n.dart';

class SlappyCatGame extends FlameGame {
  SlappyCatGame({
    required this.l10n,
    required this.effectPlayer,
  }) {
    images.prefix = '';
  }

  final AppLocalizations l10n;

  final AudioPlayer effectPlayer;

  int counter = 0;
  final int maxElement = 3;
  final world = World();
  late CameraComponent cameraComponent;

  final random = Random();

  @override
  Color backgroundColor() => const Color.fromARGB(255, 38, 34, 52);

  @override
  Future<void> onLoad() async {
    cameraComponent = CameraComponent.withFixedResolution(
      world: world,
      width: 300,
      height: 800,
    );

    await addAll(
      [
        cameraComponent,
        world,
        SpawnComponent(
          period: 3,
        ),
        
      ],
    );
  }

  void addComponent() {
    if (counter < maxElement) {
      add(Butterfly(initialPosition: Vector2.random()));
      counter++;
    }
  }

  void removeComponent(Component component) {
    remove(component);
    counter--;
  }
}
