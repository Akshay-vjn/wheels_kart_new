import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/common/utils/validator.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_image_const.dart';
import 'package:wheels_kart/module/VENDOR/core/utils/v_messages.dart';
import 'package:wheels_kart/module/VENDOR/core/v_style.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/auth/screens/v_registration_screen.dart';
import 'package:wheels_kart/module/VENDOR/features/v_nav_screen.dart';
import 'package:wheels_kart/module/VENDOR/features/widgets/v_custom_button.dart';
import 'package:wheels_kart/module/VENDOR/features/widgets/v_custom_texfield.dart';

class VLoginScreen extends StatelessWidget {
  VLoginScreen({super.key});
  final _mobileNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AppAuthController, AppAuthControllerState>(
        listener: (context, state) {
          switch (state) {
            case AuthErrorState():
              {
                HapticFeedback.heavyImpact();
                vSnackBarMessage(
                  context,
                  state.errorMessage,
                  state: VSnackState.ERROR,
                );
              }
            case AuthCubitAuthenticateState():
              {
                HapticFeedback.mediumImpact();
                showToastMessage(context, state.loginMesaage);
                Navigator.of(context).pushAndRemoveUntil(
                  AppRoutes.createRoute(VNavScreen()),
                  (context) => false,
                );
              }

            default:
              {}
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    SizedBox(
                      width: w(context),
                      child: Image.asset(
                        fit: BoxFit.fitWidth,
                        VImageConst.loginBg,
                      ),
                    ),
                    Positioned(
                      bottom: h(context) * .1,
                      child: AppMargin(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sign",
                                  style: VStyle.style(
                                    context: context,
                                    fontWeight: FontWeight.bold,
                                    size: 30,
                                  ),
                                ),
                                Container(
                                  height: 4,
                                  width: w(context) * .17,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusSize50,
                                    ),
                                    color: VColors.SECONDARY.withAlpha(200),
                                  ),
                                ),
                              ],
                            ),
                            Flexible(
                              child: Text(
                                " In",
                                style: VStyle.style(
                                  context: context,
                                  fontWeight: FontWeight.bold,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                AppMargin(
                  child: Column(
                    children: [
                      VCustomTexfield(
                        keyboardType: TextInputType.number,
                        title: "Mobile number",
                        hintText: "Enter mobile number",
                        controller: _mobileNumberController,
                        validator: (p0) => Validator.validateMobileNumber(p0),
                      ),
                      AppSpacer(heightPortion: .02),
                      VCustomTexfield(
                        // keyboardType: TextInputType,
                        title: "Password",
                        hintText: "Enter password",
                        controller: _passwordController,
                        validator: (p0) => Validator.validateRequired(p0),
                      ),

                      AppSpacer(heightPortion: .06),
                      BlocBuilder<AppAuthController, AppAuthControllerState>(
                        builder: (context, state) {
                          return VCustomButton(
                            isLoading: state is AuthLodingState,
                            title: "SIGN IN",
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                await context
                                    .read<AppAuthController>()
                                    .loginVendor(
                                      context,
                                      _mobileNumberController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                              }
                            },
                          );
                        },
                      ),

                      AppSpacer(heightPortion: .03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an Account ? ",
                            style: VStyle.style(
                              context: context,
                              color: VColors.DARK_GREY,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                AppRoutes.createRoute(VRegistrationScreen()),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: VStyle.style(
                                context: context,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // showOtpSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     isDismissible: true,
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => OtpSheet(mobilNumber: "9846475854",),
  //   );
  // }
}
