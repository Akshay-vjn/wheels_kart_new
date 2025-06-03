import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';

class EvAppStyle {
  // GoogleFonts.openSans
  // GoogleFonts.sourceSans3
  static TextStyle style({
    double? size,
    required BuildContext context,
    bool? enableShadow,
    Color? shadowColor,
    FontWeight? fontWeight,
    double? letterSpacing,
    Color? color,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      decoration: decoration,
      decorationColor: color ?? EvAppColors.DEFAULT_BLUE_DARK,
      shadows: [
        enableShadow != null
            ? Shadow(
              offset: const Offset(1, 2),
              color: shadowColor ?? EvAppColors.black.withOpacity(.3),
            )
            : const Shadow(),
      ],
      color: color ?? EvAppColors.DEFAULT_BLUE_DARK,
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
      decorationColor: color ?? EvAppColors.DEFAULT_BLUE_DARK,
      shadows: [
        enableShadow != null
            ? Shadow(
              offset: const Offset(1, 2),
              color: shadowColor ?? EvAppColors.black.withOpacity(.3),
            )
            : const Shadow(),
      ],
      color: color ?? EvAppColors.DEFAULT_BLUE_DARK,
      fontWeight: fontWeight,
      fontSize: size ?? AppDimensions.fontSize12(context),
      letterSpacing: letterSpacing,
    );
  }

  static InputDecoration dropdownDecoration({bool? isBorderWhite}) =>
      InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.radiusSize10),
          ),
          borderSide: BorderSide(
            width: 1,
            color:
                isBorderWhite == null
                    ? EvAppColors.kAppSecondaryColor
                    : EvAppColors.white,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.radiusSize10),
          ),
          borderSide: BorderSide(width: 1.5, color: EvAppColors.kRed),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.radiusSize10),
          ),
          borderSide: BorderSide(width: 1.5, color: EvAppColors.kRed),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.radiusSize10),
          ),
          borderSide: BorderSide(
            width: 1.5,
            color:
                isBorderWhite == null
                    ? EvAppColors.kAppSecondaryColor
                    : EvAppColors.white,
          ),
        ),
      );
}
