import 'package:flutter/material.dart';
import 'package:flamejam_coderjedi/constants/globals.dart';
import 'package:flamejam_coderjedi/constants/screens.dart';
import 'package:flamejam_coderjedi/game.dart';
import 'package:flamejam_coderjedi/utils/screenBackground.dart';

class MainMenuScreen extends StatelessWidget {
  final BlazeGame gameRef;
  const MainMenuScreen({
    Key? key,
    required this.gameRef,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenBackgroundWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Blaze',
                style: TextStyle(
                  fontSize: Globals.isTablet ? 100 : 50,
                ),
              ),
            ),
            SizedBox(
              width: Globals.isTablet ? 200 : 100,
              height: Globals.isTablet ? 80 : 30,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.removeMenu(menu: Screens.main);
                  gameRef.resumeEngine();
                },
                child: Text(
                  'Play',
                  style: TextStyle(
                    fontSize: Globals.isTablet ? 50 : 25,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
