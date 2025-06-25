import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_image_const.dart';
import 'package:wheels_kart/module/VENDOR/features/widgets/v_custom_button.dart';
import 'package:wheels_kart/module/VENDOR/helper/blocs/v%20nav%20controller/v_nav_controller_cubit.dart';
import 'package:wheels_kart/module/vendor/core/v_style.dart';

class VAccountTab extends StatelessWidget {
  const VAccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // physics: AlwaysScrollableScrollPhysics(),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: h(context),

            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(VImageConst.loginBg),
            ),
          ),

          Positioned(
            width: w(context) * .85,
            top: h(context) * .5,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  width: w(context),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: VColors.SECONDARY.withAlpha(50),
                        blurRadius: 10,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSize15,
                    ),
                    color: VColors.WHITE,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Account Info",
                        style: VStyle.style(
                          context: context,
                          fontWeight: FontWeight.bold,
                          size: AppDimensions.fontSize18(context),
                        ),
                      ),
                      AppSpacer(heightPortion: .02),
                      _build("7756873424", SolarIconsOutline.phone, context),
                      AppSpacer(heightPortion: .01),
                      _build("Anand Jain", SolarIconsOutline.user, context),
                      AppSpacer(heightPortion: .01),
                      _build("ABC Company", SolarIconsOutline.shop, context),

                      // AppSpacer(heightPortion: .03,),
                    ],
                  ),
                ),
                AppSpacer(heightPortion: .04),
                VCustomButton(
                  title: "LOGOUT",
                  onTap: () {
                    context.read<VNavControllerCubit>().onChangeNav(0);
                    context.read<AppAuthController>().clearPreferenceData(
                      context,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _build(String title, IconData icon, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      width: w(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize15),
        border: Border.all(color: VColors.SECONDARY, width: .5),
        color: VColors.GREY.withAlpha(30),
      ),
      child: Row(
        children: [
          Icon(icon, color: VColors.SECONDARY),
          AppSpacer(widthPortion: .04),
          Text(
            title,
            style: VStyle.style(
              fontWeight: FontWeight.w500,
              context: context,
              size: 15,
              color: VColors.SECONDARY,
            ),
          ),
        ],
      ),
    );
  }
}
