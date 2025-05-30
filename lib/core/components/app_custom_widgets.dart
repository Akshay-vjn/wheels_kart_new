import 'package:flutter/material.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';

Widget customBackButton(
  BuildContext context, {
  Color? color,
  void Function()? onPressed,
}) => Container(
    margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.2),
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
      color: color ?? AppColors.white,
    ),
  ),
);
