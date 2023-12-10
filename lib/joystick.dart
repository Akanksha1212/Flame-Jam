import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flamejam_coderjedi/constants/globals.dart';
import 'package:flutter/material.dart';

final JoystickComponent joystick = JoystickComponent(
  knob: CircleComponent(
    radius: Globals.isTablet ? 30 : 15,
    paint: BasicPalette.yellow.withAlpha(200).paint(),
  ),
  background: CircleComponent(
    radius: Globals.isTablet ? 100 : 50,
    paint: BasicPalette.yellow.withAlpha(100).paint(),
  ),
  margin: const EdgeInsets.only(left: 40, bottom: 40),
);
