import 'package:flutter/material.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';

Widget evCustomBackButton(
  BuildContext context, {
  Color? color,
  void Function()? onPressed,
}) => Container(
    margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: EvAppColors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
  child: IconButton(
    onPressed:
        onPressed ??
        () {
          Navigator.pop(context);
        },
    icon: Icon(
      size: AppDimensions.fontSize24(context),
      Icons.arrow_back_ios_new,
      color: color ?? EvAppColors.white,
    ),
  ),
);
