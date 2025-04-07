import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/module/evaluator/data/cubit/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/vendor/UI/widgets/v_custom_text_field.dart';

class VeLoginScreen extends StatelessWidget {
  VeLoginScreen({super.key});

  final _mobileNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.DARK_PRIMARY,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppSpacer(heightPortion: .1),
            Text(
              'Welcome back !',
              style: AppStyle.style(
                color: AppColors.DEFAULT_ORANGE_LIGHT,
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
                      color: AppColors.DEFAULT_ORANGE_LIGHT,
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
                      color: AppColors.DEFAULT_ORANGE,
                    ),
                  ),
                ],
              ),
            ),
            const AppSpacer(heightPortion: .1),

            Expanded(
              child: Container(
                width: w(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(70)),
                  color: AppColors.vScafoldColor,
                ),
                child: AppMargin(
                  child: Column(
                    children: [
                      VAppCustomTextfield(
                        labeltext: "Mobile Number",
                        hintText: "Enter your registerd phone number",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
