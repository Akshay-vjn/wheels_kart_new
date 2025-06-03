import 'package:flutter/material.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';

class EVAppLoadingIndicator extends StatelessWidget {
  bool? needMorHigt = false;
  EVAppLoadingIndicator({super.key, this.needMorHigt});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          needMorHigt == true
              ? SizedBox(
                height: h(context) * .8,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  // color: AppColors.DEFAULT_ORANGE,
                ),

                // SpinKitFadingCircle(
                //   itemBuilder:
                //       (context, index) => DecoratedBox(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(100),
                //           color: AppColors.DEFAULT_ORANGE,
                //         ),
                //       ),
                // ),
                // CircularProgressIndicator(strokeWidth: 2),
              )
              : CircularProgressIndicator(
                strokeWidth: 2,
                // color: AppColors.DEFAULT_ORANGE,
              ),

      //  SpinKitFadingCircle(
      //   itemBuilder:
      //       (context, index) => DecoratedBox(
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(100),
      //           color: AppColors.DEFAULT_ORANGE,
      //         ),
      //       ),
      // ),
    );
  }
}
