import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';

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
}
