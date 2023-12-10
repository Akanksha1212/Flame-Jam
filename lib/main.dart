import 'package:flamejam_coderjedi/constants/globals.dart';
import 'package:flamejam_coderjedi/constants/screens.dart';
import 'package:flamejam_coderjedi/game.dart';
import 'package:flamejam_coderjedi/utils/hiveService.dart';
import 'package:flamejam_coderjedi/screens/gameOver.dart';
import 'package:flamejam_coderjedi/screens/mainMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart';

BlazeGame _BlazeGame = BlazeGame();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.openHiveBox(boxName: 'settings');

  runApp(ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          Globals.isTablet = MediaQuery.of(context).size.width > 600;

          return GameWidget(
            initialActiveOverlays: [Screens.main.name],
            game: _BlazeGame,
            overlayBuilderMap: {
              Screens.gameOver.name:
                  (BuildContext context, BlazeGame gameRef) =>
                      GameOverScreen(gameRef: gameRef),
              Screens.main.name: (BuildContext context, BlazeGame gameRef) =>
                  MainMenuScreen(gameRef: gameRef),
            },
          );
        },
      ),
    ),
  ));
}
