import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/home/ev_dashboard_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_button.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_textfield.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/login%20page%20bloc/login_bloc_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/cubit/auth%20cubit/auth_cubit.dart';

import '../../../../../core/utils/custome_show_messages.dart';

class EvLoginScreen extends StatelessWidget {
  EvLoginScreen({super.key});

  final _mobileNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<EvAuthBlocCubit, EvAuthBlocState>(
        listener: (context, state) {
          switch (state) {
            case AuthErrorState():
              {
                showSnakBar(context, state.errorMessage, isError: true,enablePop: true);
              }
            case AuthCubitAuthenticateState():
              {
                showToastMessage(context, state.loginMesaage);
                Navigator.of(context).pushAndRemoveUntil(
                  AppRoutes.createRoute(EvDashboardScreen()),
                  (context) => false,
                );
              }
            case AuthLodingState():
              {
                showCustomLoadingDialog(context);
              }
            default:
              {}
          }
        },
        child: Center(
          child: AppMargin(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingSize15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back !',
                        style: AppStyle.style(
                          fontWeight: FontWeight.w400,
                          size: AppDimensions.fontSize30(context),
                          context: context,
                        ),
                      ),
                      Text.rich(
                        style: AppStyle.style(context: context),
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'to ',
                              style: AppStyle.style(
                                context: context,
                                fontWeight: FontWeight.w400,
                                size: AppDimensions.fontSize30(context),
                              ),
                            ),
                            TextSpan(
                              text: 'Wheels Kart',
                              style: AppStyle.style(
                                size: AppDimensions.fontSize30(context),
                                fontWeight: FontWeight.bold,
                                context: context,
                                color: AppColors.kAppSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const AppSpacer(heightPortion: .1),
                      EvAppCustomTextfield(
                        fillColor: AppColors.white,
                        prefixIcon: Icon(Icons.phone_iphone_rounded),
                        borderRudius: AppDimensions.radiusSize18,
                        fontWeght: FontWeight.w500,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your registered mobile number';
                          } else {
                            return null;
                          }
                        },
                        controller: _mobileNumberController,
                        labeltext: 'Mobile Number',
                        hintText: 'Enter your mobile number',
                        keyBoardType: TextInputType.number,
                        maxLenght: 10,
                      ),
                      BlocBuilder<EvLoginBlocBloc, EvLoginBlocState>(
                        builder:
                            (context, state) => SizedBox(
                              child: EvAppCustomTextfield(
                                fillColor: AppColors.white,
                                prefixIcon: Icon(Icons.lock_outlined),
                                borderRudius: AppDimensions.radiusSize18,
                                fontWeght: FontWeight.w500,

                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the password';
                                  } else {
                                    return null;
                                  }
                                },
                                controller: _passwordController,
                                labeltext: 'Password',
                                isObsecure: state.isPasswordHide,
                                hintText: 'Enter your password',
                                suffixIcon: InkWell(
                                  onTap: () {
                                    if (state.isPasswordHide) {
                                      context.read<EvLoginBlocBloc>().add(
                                        HidePassword(),
                                      );
                                    } else {
                                      context.read<EvLoginBlocBloc>().add(
                                        ShowPassword(),
                                      );
                                    }
                                  },
                                  child: Icon(
                                    state.isPasswordHide
                                        ? Iconsax.eye
                                        : Iconsax.eye_slash,
                                  ),
                                ),
                              ),
                            ),
                      ),
                      const AppSpacer(heightPortion: .05),
                      EvAppCustomButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await context.read<EvAuthBlocCubit>().loginUser(
                              context,
                              _mobileNumberController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        title: 'Login Now',
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: AppStyle.style(
                            fontWeight: FontWeight.w600,
                            context: context,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
