class Globals {
  Globals._();

  /// Audio
  static const String snowAttackSound = 'fall.wav';
  static const String fireballCaught = 'item-grab-sound.wav';
  static const String firePowerSound = 'flame-sound.wav';

  /// Images
  static const String idleBlaze = 'walkfront.gif';
  static const String deadBlaze = 'dead.png';
  static const String blazeLeftWalk = 'walkleft.png';
  static const String blazeRightWalk = 'walkright.gif';
  static const String backgroundSprite = 'gamebackground.jpeg';
  static const String fireballSprite = 'fireball.png';
  static const String snowSprite = 'Snowball.png';
  static const String torchSprite = 'torch.gif';
  static const String firePowerSprite = 'fireballextreme.png';

  static late bool isTablet;

  static const int gameTimeLimit = 45;
  static const int frozenTimeLimit = 3;
  static const int torchTimeLimit = 10;
  static const int firePowerTimeLimit = 10;
}
