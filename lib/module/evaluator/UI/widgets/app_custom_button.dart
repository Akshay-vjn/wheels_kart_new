import 'package:flutter/material.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';

class EvAppCustomButton extends StatelessWidget {
  final String? title;
  final bool? isSquare;
  final Color? bgColor;
  final Widget? child;

  final void Function()? onTap;

  const EvAppCustomButton({
    super.key,
    this.title,
    this.isSquare,
    this.bgColor,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      child: Container(
        alignment: Alignment.center,
        width: w(context),
        padding: const EdgeInsetsDirectional.all(AppDimensions.paddingSize15),
        decoration: BoxDecoration(
          color: bgColor,
          border:
              bgColor == null
                  ? Border.all(color: AppColors.kAppSecondaryColor)
                  : null,
          boxShadow:
              bgColor == null
                  ? [
                    BoxShadow(
                      blurRadius: 5,
                      blurStyle: BlurStyle.normal,
                      spreadRadius: 1,
                      offset: const Offset(2, 3),
                      color: AppColors.black.withOpacity(.2),
                    ),
                  ]
                  : null,
          borderRadius:
              isSquare == true
                  ? BorderRadius.circular(AppDimensions.radiusSize5)
                  : BorderRadius.circular(AppDimensions.radiusSize18),
          gradient: bgColor == null ? AppColors.buttonGradient1 : null,
        ),
        child:
            child ??
            (title != null
                ? Text(
                  title!,
                  style: AppStyle.style(
                    fontWeight: FontWeight.bold,
                    context: context,
                    size: AppDimensions.fontSize16(context),
                    color: AppColors.white,
                    // : AppColors.kAppSecondaryColor
                  ),
                )
                : SizedBox()),
      ),
    );
  }
}
