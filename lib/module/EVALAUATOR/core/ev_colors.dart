import 'package:flutter/material.dart';

class EvAppColors {
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static Color kScafoldBgColor = Colors.white;
  static const Color black2 = Color(0xFF2c2c2c);
  static const Color  kAppSecondaryColor = Color(0xFF1C67A5);
  static const Color kSelectionColor = Color.fromARGB(255, 238, 239, 240);
  static const Color kRed = Color.fromARGB(255, 184, 47, 37);
  static const Color kGreen = Colors.green;
  static const buttonGradient1 = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomRight,
    colors: [EvAppColors.kAppSecondaryColor, EvAppColors.black],
  );
  static const Color DEFAULT_BLUE_DARK = Color(0xFF042F40);
  static const Color DEFAULT_BLUE_GREY = Color(0xFF365B67);
  static const Color DEFAULT_ORANGE = Color(0xFFEB6105);
  static const Color FILL_COLOR = Color.fromARGB(255, 239, 249, 255);
  static const Color DARK_PRIMARY = Color(0xFF101317);
  static const Color DARK_SECONDARY = Color(0xFF7202e1);
}
