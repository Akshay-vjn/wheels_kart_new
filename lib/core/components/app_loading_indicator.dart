import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';

class AppLoadingIndicator extends StatelessWidget {
  bool? needMorHigt = false;
  AppLoadingIndicator({super.key, this.needMorHigt});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: needMorHigt == true
            ? SizedBox(
                height: h(context) * .8,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),

                //  LoadingAnimationWidget.dotsTriangle(
                //   color: AppColors.DEFAULT_BLUE_DARK,
                //   size: AppDimensions.fontSize45(context),
                // ),
              )
            : CircularProgressIndicator(
                strokeWidth: 2,
              )
        // : LoadingAnimationWidget.dotsTriangle(
        //     color: AppColors.DEFAULT_BLUE_DARK,
        //     size: AppDimensions.fontSize45(context),
        //   ),
        );
  }
}
