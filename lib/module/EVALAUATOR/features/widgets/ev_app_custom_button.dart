import 'package:flutter/material.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';

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
                  ? Border.all(color: EvAppColors.kAppSecondaryColor)
                  : null,
          boxShadow:
              bgColor == null
                  ? [
                    BoxShadow(
                      blurRadius: 5,
                      blurStyle: BlurStyle.normal,
                      spreadRadius: 1,
                      offset: const Offset(2, 3),
                      color: EvAppColors.black.withOpacity(.2),
                    ),
                  ]
                  : null,
          borderRadius:
              isSquare == true
                  ? BorderRadius.circular(AppDimensions.radiusSize5)
                  : BorderRadius.circular(AppDimensions.radiusSize18),
          gradient: bgColor == null ? EvAppColors.buttonGradient1 : null,
        ),
        child:
            child ??
            (title != null
                ? Text(
                  title!,
                  style: EvAppStyle.style(
                    fontWeight: FontWeight.bold,
                    context: context,
                    size: AppDimensions.fontSize16(context),
                    color: EvAppColors.white,
                    // : AppColors.kAppSecondaryColor
                  ),
                )
                : SizedBox()),
      ),
    );
  }
}
