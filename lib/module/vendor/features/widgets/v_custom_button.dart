import 'package:flutter/material.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';
import 'package:wheels_kart/module/vendor/core/v_style.dart';

class VCustomButton extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final Color? bgColor;
  final double? width;
  final void Function()? onTap;
  const VCustomButton({
    super.key,
    required this.title,
    this.titleStyle,
    this.bgColor,
    this.width,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        alignment: Alignment.center,

        width: width ?? w(context) * .85,
        decoration: BoxDecoration(
          color: bgColor ?? VColors.SECONDARY,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSize10+5),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // tileMode: TileMode.clamp,
            transform: GradientRotation(5),
            colors: [
              bgColor != null ? bgColor! : VColors.SECONDARY,
              // EvAppColors.white.withAlpha(120),
              EvAppColors.white,
            ],
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              spreadRadius: .5,
              offset: Offset(2, 2),
              color:
                  bgColor != null
                      ? bgColor!.withAlpha(100)
                      : EvAppColors.kAppSecondaryColor.withAlpha(100),
            ),
          ],
        ),

        child: Text(
          title,
          style:
              titleStyle ??
              VStyle.style(
                context: context,
                color: EvAppColors.white,
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
    );
  }
}
