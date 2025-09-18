import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';

class VStyle {
  static TextStyle style({
    double? size,
    required BuildContext context,
    Color? shadowColor,
    FontWeight? fontWeight,
    double? letterSpacing,
    Color? color,
    TextDecorationStyle? textDecorationStyle,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      decoration: decoration,
      decorationColor: color,

      shadows:
          shadowColor == null
              ? []
              : [Shadow(offset: const Offset(1, 2), color: shadowColor)],
      color: color,
      fontWeight: fontWeight,
      fontSize: size ?? AppDimensions.fontSize12(context),
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle poppins({
    double? size,
    required BuildContext context,
    bool? enableShadow,
    Color? shadowColor,
    FontWeight? fontWeight,
    double? letterSpacing,
    Color? color,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.poppins(
      decoration: decoration,
      decorationColor: color ?? VColors.SECONDARY,
      shadows: [
        enableShadow != null
            ? Shadow(
              offset: const Offset(1, 2),
              color: shadowColor ?? VColors.BLACK.withOpacity(.3),
            )
            : const Shadow(),
      ],
      color: color ?? VColors.SECONDARY,
      fontWeight: fontWeight,
      fontSize: size ?? AppDimensions.fontSize12(context),
      letterSpacing: letterSpacing,
    );
  }
}
