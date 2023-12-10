import 'package:flame/components.dart';
import 'package:flamejam_coderjedi/constants/globals.dart';
import 'package:flamejam_coderjedi/game.dart';

class BackgroundComponent extends SpriteComponent with HasGameRef<BlazeGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(Globals.backgroundSprite);
    size = gameRef.size;
  }
}
