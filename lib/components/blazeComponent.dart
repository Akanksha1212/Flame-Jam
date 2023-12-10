import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flamejam_coderjedi/components/firePowerComponent.dart';
import 'package:flamejam_coderjedi/components/snowballComponent.dart';
import 'package:flamejam_coderjedi/components/torchComponent.dart';
import 'package:flamejam_coderjedi/constants/globals.dart';
import 'package:flamejam_coderjedi/game.dart';

enum MovementState {
  idle,
  slideLeft,
  slideRight,
  frozen,
}

class BlazeComponent extends SpriteGroupComponent<MovementState>
    with HasGameRef<BlazeGame>, CollisionCallbacks {
  final double _spriteHeight = Globals.isTablet ? 100.0 : 50;
  static final double _originalSpeed = Globals.isTablet ? 500.0 : 250.0;
  static double _speed = _originalSpeed;
  final JoystickComponent joystick;
  late double _rightBound;
  late double _leftBound;
  late double _upBound;
  late double _downBound;
  bool isFrozen = false;
  bool isFlamed = false;

  final Timer _frozenCountdown = Timer(Globals.frozenTimeLimit.toDouble());
  final Timer _firePowerCountdown =
      Timer(Globals.firePowerTimeLimit.toDouble());

  BlazeComponent({required this.joystick});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final Sprite idleBlaze = await gameRef.loadSprite(Globals.idleBlaze);
    final Sprite blazeLeftWalk =
        await gameRef.loadSprite(Globals.blazeLeftWalk);
    final Sprite blazeRightWalk =
        await gameRef.loadSprite(Globals.blazeRightWalk);
    final Sprite deadBlaze = await gameRef.loadSprite(Globals.deadBlaze);
    sprites = {
      MovementState.idle: idleBlaze,
      MovementState.slideLeft: blazeLeftWalk,
      MovementState.slideRight: blazeRightWalk,
      MovementState.frozen: deadBlaze,
    };

    _rightBound = gameRef.size.x - 45;
    _leftBound = 0 + 45;
    _upBound = 0 + 55;
    _downBound = gameRef.size.y - 55;
    position = gameRef.size / 2;
    width = _spriteHeight * 1.42;
    height = _spriteHeight;
    anchor = Anchor.center;
    current = MovementState.idle;

    add(CircleHitbox()..radius = 1);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isFrozen) {
      if (joystick.direction == JoystickDirection.idle) {
        current = MovementState.idle;
        return;
      }
      if (x >= _rightBound) {
        x = _rightBound - 1;
      }
      if (x <= _leftBound) {
        x = _leftBound + 1;
      }
      if (y >= _downBound) {
        y = _downBound - 1;
      }
      if (y <= _upBound) {
        y = _upBound + 1;
      }
      bool moveLeft = joystick.relativeDelta[0] < 0;
      if (moveLeft) {
        current = MovementState.slideLeft;
      } else {
        current = MovementState.slideRight;
      }

      _firePowerCountdown.update(dt);
      if (_firePowerCountdown.finished) {
        _resetSpeed();
      }
      position.add(joystick.relativeDelta * _speed * dt);
    } else {
      _frozenCountdown.update(dt);
      if (_frozenCountdown.finished) {
        _unfreezeBlaze();
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is SnowballComponent) {
      if (!isFlamed) {
        _freezeBlaze();
      }
    }
    if (other is TorchComponent) {
      flameBlaze();
    }
    if (other is FirePowerComponent) {
      _increaseSpeed();
    }
  }

  void _increaseSpeed() {
    FlameAudio.play(Globals.fireballCaught);
    _speed *= 2;
    _firePowerCountdown.start();
  }

  void _resetSpeed() {
    _speed = _originalSpeed;
  }

  void flameBlaze() {
    if (!isFrozen) {
      isFlamed = true;
      FlameAudio.play(Globals.firePowerSound);
      gameRef.add(gameRef.flameTimerText);
      gameRef.flameTimer.start();
    }
  }

  void unflameBlaze() {
    isFlamed = false;
  }

  void _freezeBlaze() {
    if (!isFrozen) {
      isFrozen = true;
      FlameAudio.play(Globals.snowAttackSound);
      current = MovementState.frozen;
      _frozenCountdown.start();
    }
  }

  void _unfreezeBlaze() {
    isFrozen = false;
    current = MovementState.idle;
  }
}
