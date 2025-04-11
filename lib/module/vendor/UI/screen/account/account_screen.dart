import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';

import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: w(context),
      height: h(context),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.topLeft,
          colors: [AppColors.gradientBlack, AppColors.DARK_SECONDARY],
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.DARK_PRIMARY,
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(200, 200),
                topRight: Radius.elliptical(200, 200),
              ),
            ),
            width: w(context),
            height: h(context) * .7,
            child: Column(
              children: [
                AppSpacer(heightPortion: .2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(false, SolarIconsOutline.user, "Profile"),
                    _buildButton(true, SolarIconsOutline.settings, "Settings"),
                  ],
                ),
                AppSpacer(heightPortion: .05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(false, SolarIconsOutline.user, "Profile"),
                    _buildButton(true, SolarIconsOutline.settings, "Settings"),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 70,
            left: 30,
            right: 30,
            child: Container(
              width: w(context),
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.topLeft,
                  colors: [AppColors.DARK_SECONDARY, AppColors.gradientBlack],
                ),

                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SLK VENTURES",
                    style: AppStyle.poppins(
                      color: AppColors.white,
                      size: AppDimensions.fontSize30(context),
                      context: context,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "Dealer ID: 8765",
                    style: AppStyle.poppins(
                      color: AppColors.grey,
                      size: AppDimensions.fontSize10(context),
                      context: context,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(bool revers, IconData icon, String title) {
    return Container(
      width: w(context) * .4,
      height: w(context) * .35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors:
              revers
                  ? [AppColors.gradientBlack, AppColors.DARK_SECONDARY]
                  : [AppColors.DARK_SECONDARY, AppColors.gradientBlack],
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(1),

        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.DARK_PRIMARY, // Inner background color
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Color(0xFFCBA8F1)),
            AppSpacer(heightPortion: .01),
            Text(
              title,
              style: AppStyle.poppins(
                fontWeight: FontWeight.w400,
                context: context,
                size: AppDimensions.fontSize16(context),
                color: Color(0xFFCBA8F1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
