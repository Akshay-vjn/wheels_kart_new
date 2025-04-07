import 'package:flutter/material.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';

Widget customBackButton(BuildContext context, {Color? color}) => IconButton(
  onPressed: () {
    Navigator.pop(context);
  },
  icon: Icon(
    size: AppDimensions.fontSize24(context),
    Icons.arrow_back_ios_new,
    color: color ?? AppColors.white,
  ),
);
