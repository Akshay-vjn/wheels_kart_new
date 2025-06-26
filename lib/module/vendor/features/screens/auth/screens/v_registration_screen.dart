import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/common/utils/validator.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_image_const.dart';
import 'package:wheels_kart/module/VENDOR/core/v_style.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/auth/screens/v_login_screen.dart';
import 'package:wheels_kart/module/VENDOR/features/v_nav_screen.dart';
import 'package:wheels_kart/module/VENDOR/features/widgets/v_custom_button.dart';
import 'package:wheels_kart/module/VENDOR/features/widgets/v_custom_texfield.dart';

class VRegistrationScreen extends StatelessWidget {
  VRegistrationScreen({super.key});

  final _mobileNumberController = TextEditingController();
  final _emailContller = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordContoller = TextEditingController();
  final _cityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                              " Up",
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
                      title: "Full Name",
                      hintText: "Enter your name",
                      controller: _fullNameController,
                      validator: (p0) => Validator.validateRequired(p0),
                    ),
                    AppSpacer(heightPortion: .03),
                    VCustomTexfield(
                      keyboardType: TextInputType.number,
                      title: "Mobile number",
                      hintText: "Enter mobile number",
                      controller: _mobileNumberController,
                      validator: (p0) => Validator.validateMobileNumber(p0),
                    ),
                    AppSpacer(heightPortion: .03),
                    VCustomTexfield(
                      keyboardType: TextInputType.emailAddress,
                      title: "Email",
                      hintText: "Enter your email address",
                      controller: _emailContller,
                      validator: (p0) => Validator.validateEmail(p0),
                    ),
                    AppSpacer(heightPortion: .03),
                    VCustomTexfield(
                      title: "City",
                      hintText: "Enter your city",
                      controller: _cityController,
                      validator: (p0) => Validator.validateRequired(p0),
                    ),
                    AppSpacer(heightPortion: .06),

                    VCustomTexfield(
                      title: "Password",
                      hintText: "Enter a new password",
                      controller: _passwordController,
                      validator: (p0) => Validator.validateRequired(p0),
                    ),
                    AppSpacer(heightPortion: .03),
                    VCustomTexfield(
                      title: "Confirm Password",
                      hintText: "Enter password again",
                      controller: _confirmPasswordContoller,
                      validator: (p0) => Validator.validateRequired(p0),
                    ),

                    AppSpacer(heightPortion: .06),
                    VCustomButton(
                      title: "REGISTER",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await context
                              .read<AppAuthController>()
                              .registerVendor(
                                context,
                                _mobileNumberController.text.trim(),
                                _passwordController.text.trim(),
                                _confirmPasswordContoller.text.trim(),
                                _fullNameController.text.trim(),
                                _emailContller.text.trim(),
                                _cityController.text.trim(),
                              );
                        }
                      },
                    ),
                    AppSpacer(heightPortion: .03),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You already have a Account ?",
                          style: VStyle.style(
                            context: context,
                            color: VColors.DARK_GREY,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).push(AppRoutes.createRoute(VLoginScreen()));
                          },
                          child: Text(
                            "Sign In",
                            style: VStyle.style(
                              context: context,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    AppSpacer(heightPortion: .03),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
