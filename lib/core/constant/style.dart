import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';

class AppStyle {
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
      decorationColor: color ?? AppColors.DEFAULT_BLUE_DARK,
      shadows: [
        enableShadow != null
            ? Shadow(
              offset: const Offset(1, 2),
              color: shadowColor ?? AppColors.black.withOpacity(.3),
            )
            : const Shadow(),
      ],
      color: color ?? AppColors.DEFAULT_BLUE_DARK,
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
                    ? AppColors.kAppSecondaryColor
                    : AppColors.white,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.radiusSize10),
          ),
          borderSide: BorderSide(width: 1.5, color: AppColors.kRed),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.radiusSize10),
          ),
          borderSide: BorderSide(width: 1.5, color: AppColors.kRed),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.radiusSize10),
          ),
          borderSide: BorderSide(
            width: 1.5,
            color:
                isBorderWhite == null
                    ? AppColors.kAppSecondaryColor
                    : AppColors.white,
          ),
        ),
      );
}
