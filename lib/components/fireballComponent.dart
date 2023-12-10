import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flamejam_coderjedi/components/blazeComponent.dart';
import 'package:flamejam_coderjedi/constants/globals.dart';
import 'dart:math';

import 'package:flamejam_coderjedi/game.dart';

class FireballComponent extends SpriteComponent
    with HasGameRef<BlazeGame>, CollisionCallbacks {
  final double _spriteHeight = Globals.isTablet ? 70.0 : 40.0;
  final Random _random = Random();

  FireballComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Globals.fireballSprite);

    position = _createRandomPosition();
    width = _spriteHeight;
    height = _spriteHeight;
    anchor = Anchor.center;

    add(CircleHitbox()..radius = 1);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is BlazeComponent) {
      FlameAudio.play(Globals.fireballCaught);
      removeFromParent();
      gameRef.score += 1;
      gameRef.add(FireballComponent());
    }
  }

  Vector2 _createRandomPosition() {
    final double x = _random.nextInt(gameRef.size.x.toInt()).toDouble();
    final double y = _random.nextInt(gameRef.size.y.toInt()).toDouble();

    return Vector2(x, y);
  }
}
