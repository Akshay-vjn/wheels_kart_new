import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static Color kScafoldBgColor = Colors.white;
  static const Color black2 = Color(0xFF2c2c2c);

  static const Color DEFAULT_BLUE_DARK = Color(0xFF042F40);
  // static const Color DEFAULT_BLUE_DARK_LIGHT = Color.fromARGB(174, 4, 47, 64);
  static const Color kAppSecondaryColor = Color.fromARGB(255, 28, 103, 165);
  static const Color kSelectionColor = Color.fromARGB(255, 238, 239, 240);

  static const Color kRed = Color.fromARGB(255, 184, 47, 37);
  static const Color kGreen = Colors.green;
  static const Color kWarningColor = Colors.amberAccent;

  static const buttonGradient1 = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomRight,
    colors: [AppColors.kAppSecondaryColor, AppColors.black],
  );
  static const buttonGradient2 = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomRight,
    colors: [AppColors.DEFAULT_BLUE_DARK, AppColors.kAppSecondaryColor],
  );

  static const Color DEFAULT_BLUE_GREY = Color(0xFF365B67);
  static const Color DEFAULT_ORANGE = Color(0xFFEB6105);
  static const Color DEFAULT_ORANGE_LIGHT = Color.fromARGB(255, 255, 232, 217);
  static const Color FILL_COLOR = Color.fromARGB(255, 239, 249, 255);

  // VENDOR COLOR

  static const Color DARK_PRIMARY_LIGHT = Color(0xFF272A2E);
  static const Color DARK_PRIMARY = Color(0xFF101317);
  static const Color BORDER_COLOR = Color.fromARGB(255, 157, 162, 171);

  static Color vScafoldColor = const Color.fromARGB(255, 227, 227, 227);

  static Color vFillColor = Color(0xFFf7f8f9);
}
