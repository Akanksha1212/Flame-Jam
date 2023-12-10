import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flamejam_coderjedi/components/background.dart';
import 'package:flamejam_coderjedi/components/blazeComponent.dart';
import 'package:flamejam_coderjedi/components/firePowerComponent.dart';
import 'package:flamejam_coderjedi/components/fireballComponent.dart';
import 'package:flamejam_coderjedi/components/snowballComponent.dart';
import 'package:flamejam_coderjedi/components/torchComponent.dart';
import 'package:flamejam_coderjedi/constants/globals.dart';
import 'package:flamejam_coderjedi/constants/screens.dart';
import 'package:flamejam_coderjedi/joystick.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class BlazeGame extends FlameGame with DragCallbacks, HasCollisionDetection {
  final BlazeComponent _blazeComponent = BlazeComponent(joystick: joystick);
  final BackgroundComponent _backgroundComponent = BackgroundComponent();
  final FireballComponent _fireballComponent = FireballComponent();
  final TorchComponent _torchComponent = TorchComponent(
    startPosition: Vector2(200, 200),
  );

  int score = 0;

  static int _remainingTime = Globals.gameTimeLimit;

  int _flameRemainingTime = Globals.torchTimeLimit;

  late Timer gameTimer;

  late Timer flameTimer;
  late TextComponent _scoreText;
  late TextComponent _timerText;
  late TextComponent flameTimerText;
  static int _flameTimeAppearance = _getRandomInt(
    min: 10,
    max: _remainingTime,
  );
  static int _firePowerTimeAppearance = _getRandomInt(
    min: 10,
    max: _remainingTime,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    pauseEngine();
    gameTimer = Timer(
      1,
      repeat: true,
      onTick: () {
        if (_remainingTime == 0) {
          pauseEngine();
          addMenu(menu: Screens.gameOver);
        } else if (_remainingTime == _flameTimeAppearance) {
          add(_torchComponent);
        } else if (_remainingTime == _firePowerTimeAppearance) {
          add(FirePowerComponent());
        }
        _remainingTime -= 1;
      },
    );

    flameTimer = Timer(
      1,
      repeat: true,
      onTick: () {
        if (_flameRemainingTime == 0) {
          _blazeComponent.unflameBlaze();
          flameTimerText.removeFromParent();
        } else {
          _flameRemainingTime -= 1;
        }
      },
    );

    await FlameAudio.audioCache.loadAll(
      [
        Globals.snowAttackSound,
        Globals.fireballCaught,
        Globals.firePowerSound,
      ],
    );

    add(_backgroundComponent);
    add(_fireballComponent);
    add(SnowballComponent(startPosition: Vector2(200, 200)));
    add(SnowballComponent(startPosition: Vector2(size.x - 200, size.y - 200)));
    add(SnowballComponent(startPosition: Vector2(size.x - 100, size.y - 100)));
    add(_blazeComponent);
    add(joystick);
    add(ScreenHitbox());
    _scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(40, 50),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.white.color,
          fontSize: Globals.isTablet ? 30 : 20,
        ),
      ),
    );

    add(_scoreText);
    _timerText = TextComponent(
      text: 'Time: $score',
      position: Vector2(size.x - 40, 50),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.white.color,
          fontSize: Globals.isTablet ? 30 : 20,
        ),
      ),
    );
    add(_timerText);
    flameTimerText = TextComponent(
      text: 'Fire Power Left: $_flameRemainingTime',
      position: Vector2(size.x - 40, size.y - 100),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.red.color,
          fontSize: Globals.isTablet ? 30 : 20,
        ),
      ),
    );

    gameTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);

    gameTimer.update(dt);

    if (_blazeComponent.isFlamed) {
      flameTimer.update(dt);
      flameTimerText.text = 'Flame Time: $_flameRemainingTime';
    }

    _scoreText.text = 'Score: $score';
    _timerText.text = 'Time: $_remainingTime secs';
  }

  void reset() {
    score = 0;
    _remainingTime = Globals.gameTimeLimit;
    _flameRemainingTime = Globals.torchTimeLimit;
    _flameTimeAppearance = _getRandomInt(
      min: 10,
      max: _remainingTime,
    );
    _firePowerTimeAppearance = _getRandomInt(
      min: 10,
      max: _remainingTime,
    );
    _torchComponent.removeFromParent();
    flameTimerText.removeFromParent();
  }

  void addMenu({
    required Screens menu,
  }) {
    overlays.add(menu.name);
  }

  void removeMenu({
    required Screens menu,
  }) {
    overlays.remove(menu.name);
  }

  static int _getRandomInt({
    required int min,
    required int max,
  }) {
    Random rng = Random();
    return rng.nextInt(max - min) + min;
  }
}
