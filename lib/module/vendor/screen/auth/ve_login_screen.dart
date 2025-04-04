import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_button.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_textfield.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/login%20page%20bloc/login_bloc_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/cubit/auth%20cubit/auth_cubit.dart';

class VeLoginScreen extends StatelessWidget {
  VeLoginScreen({super.key});

  final _mobileNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<EvAuthBlocCubit, EvAuthBlocState>(
        listener: (context, state) {},
        child: AppMargin(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppSpacer(
                    heightPortion: .1,
                  ),
                  Text(
                    'Welcome back !',
                    style: AppStyle.style(
                        fontWeight: FontWeight.w400,
                        size: AppDimensions.fontSize30(context),
                        context: context),
                  ),
                  Text.rich(
                      style: AppStyle.style(context: context),
                      TextSpan(children: [
                        TextSpan(
                            text: 'to ',
                            style: AppStyle.style(
                              context: context,
                              fontWeight: FontWeight.w400,
                              size: AppDimensions.fontSize30(context),
                            )),
                        TextSpan(
                            text: 'Wheels Kart',
                            style: AppStyle.style(
                                size: AppDimensions.fontSize30(context),
                                fontWeight: FontWeight.bold,
                                context: context,
                                color: AppColors.kAppSecondaryColor)),
                      ])),
                  const AppSpacer(
                    heightPortion: .1,
                  ),
                  // AppCustomTextfield(
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return 'Please enter your registered mobile number';
                  //     } else {
                  //       return null;
                  //     }
                  //   },
                  //   controller: _mobileNumberController,
                  //   labeltext: 'Mobile Number',
                  //   hintText: 'Enter your mobile number',
                  //   suffixIcon: const Icon(Iconsax.call),
                  //   keyBoardType: TextInputType.number,
                  //   maxLenght: 10,
                  // ),
                  // BlocBuilder<EvLoginBlocBloc, EvLoginBlocState>(
                  //   // bloc: LoginBlocBloc(),
                  //   builder: (context, state) => AppCustomTextfield(
                  //     validator: (value) {
                  //       if (value!.isEmpty) {
                  //         return 'Please enter the password';
                  //       }
                  //       // else if (!AppRegex.regexForPassword.hasMatch(value)) {
                  //       //   return 'Please enter valid password';
                  //       // }
                  //       else {
                  //         return null;
                  //       }
                  //     },
                  //     controller: _passwordController,
                  //     labeltext: 'Password',
                  //     isObsecure: state.isPasswordHide,
                  //     hintText: 'Enter your password',
                  //     suffixIcon: InkWell(
                  //       onTap: () {
                  //         if (state.isPasswordHide) {
                  //           context.read<EvLoginBlocBloc>().add(HidePassword());
                  //         } else {
                  //           context.read<EvLoginBlocBloc>().add(ShowPassword());
                  //         }
                  //       },
                  //       child: Icon(state.isPasswordHide
                  //           ? Iconsax.eye
                  //           : Iconsax.eye_slash),
                  //     ),
                  //   ),
                  // ),
                  // const AppSpacer(
                  //   heightPortion: .1,
                  // ),
                  // AppCustomButton(
                  //   onTap: () async {
                  //     if (_formKey.currentState!.validate()) {}
                  //   },
                  //   title: 'Login Now',
                  // ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'I forgot my password',
                        style: AppStyle.style(
                          fontWeight: FontWeight.w600,
                          context: context,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
