import 'package:flutter/material.dart';

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> svg = [Color(0xFF7E57C2), Color(0xFF512DA8)];
}

class GradientTemplate {
  static List<GradientColors> gradientTemplate = [
    GradientColors(GradientColors.svg),
  ];
}



class CustomColors {
  static Color primaryColor = Color(0xff1ebdb5);
  static Color primaryTextColor = Colors.deepPurple.shade50;
  static Color dividerColor = Colors.deepPurple.shade100;
  static Color pageBackgroundColor = Colors.deepPurple.shade200;
  static Color menuBackgroundColor = Colors.deepPurple.shade300;

  static Color clockBG = Colors.deepPurple.shade400;
  static Color clockOutline = Colors.deepPurple.shade500;
  static Color? secHandColor = Colors.deepPurple.shade600;
  static Color minHandStatColor = Colors.deepPurple.shade700;
  static Color minHandEndColor = Colors.deepPurple.shade800;
  static Color hourHandStatColor = Colors.deepPurple.shade900;
  static Color hourHandEndColor = Color(0xff8b33e1);
}