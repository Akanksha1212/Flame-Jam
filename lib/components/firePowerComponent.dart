import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flamejam_coderjedi/components/blazeComponent.dart';
import 'package:flamejam_coderjedi/constants/globals.dart';
import 'dart:math' as math;

import 'package:flamejam_coderjedi/game.dart';

class FirePowerComponent extends SpriteComponent
    with HasGameRef<BlazeGame>, CollisionCallbacks {
  
  final double _spriteHeight = Globals.isTablet ? 100.0 : 50.0;

  late Vector2 _velocity;

  double speed = Globals.isTablet ? 600 : 300;

  final double degree = math.pi / 180;

  FirePowerComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(Globals.firePowerSprite);
    position = Vector2(200, 200);
    final double spawnAngle = _getSpawnAngle();
    final double vx = math.cos(spawnAngle * degree) * speed;
    final double vy = math.sin(spawnAngle * degree) * speed;
    _velocity = Vector2(vx, vy);
    width = _spriteHeight;
    height = _spriteHeight;
    anchor = Anchor.center;
    add(CircleHitbox()..radius = 1);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += _velocity * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ScreenHitbox) {
      final Vector2 collisionPoint = intersectionPoints.first;
      if (collisionPoint.x == 0) {
        _velocity.x = -_velocity.x;
        _velocity.y = _velocity.y;
      }
      if (collisionPoint.x == gameRef.size.x) {
        _velocity.x = -_velocity.x;
        _velocity.y = _velocity.y;
      }
      if (collisionPoint.y == 0) {
        _velocity.x = _velocity.x;
        _velocity.y = -_velocity.y;
      }
      if (collisionPoint.y == gameRef.size.y) {
        _velocity.x = _velocity.x;
        _velocity.y = -_velocity.y;
      }
    }

    if (other is BlazeComponent) {
      removeFromParent();
    }
  }

  double _getSpawnAngle() {
    final random = math.Random().nextDouble();
    final spawnAngle = lerpDouble(0, 360, random)!;

    return spawnAngle;
  }
}
