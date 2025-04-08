import 'package:flutter/material.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';

class VCustomButton extends StatelessWidget {
  final String? title;
  final Widget? child;
  final Color? bgColor;
  final TextStyle? titleStyle;
  final void Function()? onPressed;

  const VCustomButton({
    super.key,
    this.title,
    this.child,
    this.bgColor,
    this.titleStyle,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w(context),
      height: h(context) * .065,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: bgColor ?? AppColors.DARK_PRIMARY,
        ),
        onPressed: onPressed,
        child:
            child ??
            Text(
              title ?? '',
              style:
                  titleStyle ??
                  AppStyle.poppins(
                    fontWeight: FontWeight.w400,
                    size: AppDimensions.fontSize16(context),
                    context: context,
                    color: AppColors.white,
                  ),
            ),
      ),
    );
  }
}
