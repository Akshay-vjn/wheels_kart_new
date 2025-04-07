import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/images.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';

import 'package:wheels_kart/module/evaluator/data/cubit/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/model/auth_model.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';

class EvProfileScreen extends StatefulWidget {
  const EvProfileScreen({super.key});

  @override
  State<EvProfileScreen> createState() => _EvProfileScreenState();
}

class _EvProfileScreenState extends State<EvProfileScreen> {
  late AuthUserModel userModel;
  @override
  void initState() {
    super.initState();
    final state = context.read<EvAuthBlocCubit>().state;
    if (state is AuthCubitAuthenticateState) {
      userModel = state.userModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 70,
      //   centerTitle: true,
      //   title: Text(
      //     "Account",
      //     style: AppStyle.style(
      //         color: AppColors.kWhite,
      //         context: context,
      //         fontWeight: FontWeight.bold,
      //         size: AppDimensions.fontSize24(context)),
      //   ),
      // ),
      body: Column(
        children: [
          SizedBox(
            // color: AppColors.kRed,
            height: h(context) * .36,
            width: w(context),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: h(context) * .3,
                  width: w(context),
                  color: AppColors.DEFAULT_BLUE_DARK,
                  child: Column(
                    children: const [
                      AppSpacer(heightPortion: .05),
                      CircleAvatar(radius: 80),
                      AppSpacer(heightPortion: .02),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Container(
                    padding: EdgeInsets.all(AppDimensions.paddingSize15),
                    height: h(context) * .1,
                    width: w(context) * .9,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1,
                          spreadRadius: 1,
                          color: AppColors.DEFAULT_BLUE_DARK.withOpacity(.1),
                        ),
                      ],
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSize18,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userModel.userName,
                              style: AppStyle.style(
                                context: context,
                                fontWeight: FontWeight.w600,
                                size: AppDimensions.fontSize25(context),
                              ),
                            ),
                            Text(
                              userModel.mobileNumber,
                              style: AppStyle.style(
                                context: context,
                                fontWeight: FontWeight.w400,
                                size: AppDimensions.fontSize13(context),
                              ),
                            ),
                          ],
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // _buildProfileTile(
          //   "Edit profile",
          //   SolarIconsBold.pen,
          //   () {},
          // ),
          _buildProfileTile("Settings", SolarIconsBold.settings, () {}),
          _buildProfileTile(
            "Logout",
            SolarIconsBold.logout_3,
            textColor: AppColors.kRed,
            iconColor: AppColors.kRed,
            hideArrow: true,
            () async {
              await context.read<EvAuthBlocCubit>().clearPreferenceData(
                context,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile(
    String title,
    IconData icon,
    void Function()? onTap, {
    bool? hideArrow,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing:
          hideArrow == true
              ? SizedBox()
              : Icon(SolarIconsBold.roundAltArrowRight),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    String subtitle,
    void Function()? onTap,
  ) {
    return ListTile(
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
      title: Text(
        title,
        style: AppStyle.style(
          context: context,
          fontWeight: FontWeight.w600,
          size: AppDimensions.fontSize18(context),
        ),
      ),
      subtitle: Text(subtitle, style: AppStyle.style(context: context)),
    );
  }
}

//Privacy Policy
//Terms & Conditions
//Return & Cancellation
//Contact Us
