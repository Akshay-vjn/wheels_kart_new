import 'package:flutter/material.dart';

class AppColors {
  static const Color kBlack = Colors.black;
  static const Color kWhite = Colors.white;
  static const Color kGrey = Colors.grey;
  static Color kscafoldBgColor = Colors.white;
  static const Color kBlack2 = Color(0xFF2c2c2c);

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
    colors: [AppColors.kAppSecondaryColor, AppColors.kBlack],
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
}
