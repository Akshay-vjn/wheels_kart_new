import 'package:flutter/material.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';

class AppDimensions {
  static double fontSize10(BuildContext context) =>
      responsiveTextSize(context, .0067); ////10.0;
  static double fontSize12(BuildContext context) =>
      responsiveTextSize(context, .0088); ////12.0;
  static double fontSize13(BuildContext context) =>
      responsiveTextSize(context, .0099);

  ///13
  static double fontSize15(BuildContext context) =>
      responsiveTextSize(context, .011); ////15.0;
  static double fontSize16(BuildContext context) =>
      responsiveTextSize(context, .0117); //// 16.0;
  static double fontSize17(BuildContext context) =>
      responsiveTextSize(context, .0125); ////17.0;
  static double fontSize18(BuildContext context) =>
      responsiveTextSize(context, .0132); ////18.0;
  static double fontSize24(BuildContext context) =>
      responsiveTextSize(context, .0175); ////24.0;
  static double fontSize25(BuildContext context) =>
      responsiveTextSize(context, .0183); ////24.0;
  static double fontSize30(BuildContext context) =>
      responsiveTextSize(context, .025); ////30.0;
  static double fontSize34(BuildContext context) =>
      responsiveTextSize(context, .03); // 34.0;
  static double fontSize45(BuildContext context) =>
      responsiveTextSize(context, .035); //45.0;

  static const double paddingSize5 = 5.0;
  static const double paddingSize10 = 10.0;
  static const double paddingSize15 = 15.0;
  static const double paddingSize20 = 20.0;
  static const double paddingSize25 = 25.0;

  static const double radiusSize5 = 5.0;
  static const double radiusSize8 = 8.0;
  static const double radiusSize10 = 10.0;
  static const double radiusSize15 = 15.0;
  static const double radiusSize18 = 18.0;
  static const double radiusSize50 = 50.0;
}
