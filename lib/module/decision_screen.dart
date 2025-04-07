import 'package:flutter/material.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/images.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/auth/ev_login_screen.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/module/vendor/UI/screen/auth/ve_login_screen.dart';

class DecisionScreen extends StatelessWidget {
  const DecisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // ),
      body: AppMargin(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // AppSpacer(heightPortion: .08),
              SizedBox(
                width: w(context) * .7,
                child: Image.asset(ConstImages.appLogo),
              ),
              // Text(
              //   "YOU'R CAR SALE PARTNER",
              //   style: AppStyle.style(
              //     size: AppDimensions.fontSize13(context),
              //     fontWeight: FontWeight.normal,
              //     context: context,
              //     color: AppColors.kAppSecondaryColor,
              //   ),
              // ),
              // AppSpacer(heightPortion: .08),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome !',
                      style: AppStyle.style(
                        fontWeight: FontWeight.w600,
                        size: AppDimensions.fontSize30(context),
                        context: context,
                      ),
                    ),
                    Text(
                      'Please choose your profile',
                      style: AppStyle.style(
                        fontWeight: FontWeight.normal,
                        size: AppDimensions.fontSize18(context),
                        context: context,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacer(heightPortion: .05),
              _builddecisionButton(
                context,
                'Evaluator',
                'Login as Wheels Kart Evaluator',
                ConstImages.evaluatorImage,
                () {
                  Navigator.of(
                    context,
                  ).push(AppRoutes.createRoute(EvLoginScreen()));
                },
              ),
              _builddecisionButton(
                context,
                'Vendor',
                'Login as Vendor / Dealer',
                ConstImages.vendorImage,
                () {
                  Navigator.of(
                    context,
                  ).push(AppRoutes.createRoute(VeLoginScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _builddecisionButton(
    context,
    String title,
    String subtitle,
    String image,
    void Function()? onTap,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSize20),
      child: InkWell(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingSize25,
            vertical: AppDimensions.paddingSize25 + AppDimensions.paddingSize20,
          ),
          width: w(context) * .85,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                blurStyle: BlurStyle.normal,
                spreadRadius: 1,
                offset: const Offset(1, 3),
                color: AppColors.black.withOpacity(.3),
              ),
            ],

            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: const [AppColors.kAppSecondaryColor, AppColors.black],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
            color: AppColors.DEFAULT_BLUE_DARK,
            // border: Border.all(color: AppColors.kBlack)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyle.style(
                      context: context,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      size: AppDimensions.fontSize24(context),
                    ),
                  ),
                  AppSpacer(heightPortion: .005),
                  Text(
                    subtitle,
                    style: AppStyle.style(
                      context: context,
                      color: AppColors.white,
                      fontWeight: FontWeight.normal,
                      // size: AppDimensions.fontSize18(context)
                    ),
                  ),
                ],
              ),
              Image.asset(image, color: AppColors.white, scale: 10),
            ],
          ),
        ),
      ),
    );
  }
}
