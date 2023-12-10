import 'package:flamejam_coderjedi/constants/globals.dart';
import 'package:flamejam_coderjedi/constants/screens.dart';
import 'package:flamejam_coderjedi/game.dart';
import 'package:flamejam_coderjedi/utils/nakamaProvider.dart';
import 'package:flamejam_coderjedi/utils/providers.dart';
import 'package:flamejam_coderjedi/utils/screenBackground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameOverScreen extends ConsumerWidget {
  final BlazeGame gameRef;
  const GameOverScreen({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NakamaProvider nakamaProvider = ref.watch(Providers.nakamaProvider);
    nakamaProvider.writeLeaderboardRecord(score: gameRef.score);
    return ScreenBackgroundWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Game Over',
                style: TextStyle(
                    fontSize: Globals.isTablet ? 70 : 30, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Score: ${gameRef.score}',
                style: TextStyle(
                  fontSize: Globals.isTablet ? 70 : 30,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: Globals.isTablet ? 400 : 200,
              height: Globals.isTablet ? 100 : 50,
              child: GestureDetector(
                child: Image.asset("assets/images/home-button.png"),
                onTap: () {
                  gameRef.removeMenu(menu: Screens.gameOver);
                  gameRef.reset();
                  gameRef.addMenu(menu: Screens.main);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
