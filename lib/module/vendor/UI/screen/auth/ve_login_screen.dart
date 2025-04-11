import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/vendor/UI/v_navigation_screen.dart';
import 'package:wheels_kart/module/vendor/UI/widgets/v_back_button.dart';
import 'package:wheels_kart/module/vendor/UI/widgets/v_custom_button.dart';
import 'package:wheels_kart/module/vendor/UI/widgets/v_custom_text_field.dart';
import 'package:wheels_kart/module/vendor/data/cubit/auth/v_auth_controller_cubit.dart';

class VeLoginScreen extends StatelessWidget {
  VeLoginScreen({super.key});

  final _mobileNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.DARK_PRIMARY,
              AppColors.DARK_PRIMARY.withOpacity(0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppMargin(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppSpacer(heightPortion: .02),
                        Row(children: [VBackButton()]),
                        const AppSpacer(heightPortion: .1),

                        /// Enhanced Welcome Text
                        RichText(
                          text: TextSpan(
                            text: 'Welcome back!\n',
                            style: AppStyle.poppins(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              size: AppDimensions.fontSize30(context),
                              context: context,
                            ),
                            children: [
                              TextSpan(
                                text: 'Glad to see you again!',
                                style: AppStyle.poppins(
                                  color: AppColors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w400,
                                  size: AppDimensions.fontSize18(context),
                                  context: context,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const AppSpacer(heightPortion: .1),
                      ],
                    ),
                  ),

                  /// Login Card
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        width: w(context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            AppSpacer(heightPortion: .05),
                            VAppCustomTextfield(
                              controller: _mobileNumberController,
                              fillColor: AppColors.vFillColor,
                              hintText: 'Mobile number',
                              keyBoardType: TextInputType.phone,
                            ),
                            AppSpacer(heightPortion: .02),
                            BlocBuilder<
                              VAuthControllerCubit,
                              VAuthControllerState
                            >(
                              builder: (context, state) {
                                return VAppCustomTextfield(
                                  controller: _passwordController,
                                  fillColor: AppColors.vFillColor,
                                  hintText: 'Enter your password',
                                  isObsecure: state.isObsecure,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      context
                                          .read<VAuthControllerCubit>()
                                          .onChangePasswordVisibility();
                                    },
                                    icon: Icon(
                                      state.isObsecure
                                          ? SolarIconsOutline.eye
                                          : SolarIconsOutline.eyeClosed,
                                    ),
                                  ),
                                );
                              },
                            ),
                            AppSpacer(heightPortion: .02),

                            /// Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Forgot Password?',
                                style: AppStyle.poppins(
                                  color: AppColors.DARK_PRIMARY,
                                  fontWeight: FontWeight.w500,
                                  size: AppDimensions.fontSize15(context),
                                  context: context,
                                ),
                              ),
                            ),

                            AppSpacer(heightPortion: .04),

                            /// Login Button
                            VCustomButton(
                              title: "Login",
                              onPressed: () {
                                Navigator.of(context).push(
                                  AppRoutes.createRoute(VNavigationScreen()),
                                );
                                // Handle login
                              },
                            ),

                            AppSpacer(heightPortion: .03),

                            /// Sign up link
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
