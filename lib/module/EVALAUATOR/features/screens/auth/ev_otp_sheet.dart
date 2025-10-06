import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/config/pushnotification_controller.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/utils/v_messages.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/auth/screens/terms_and_condion_accept_screen.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_button.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_texfield.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/ev_dashboard_screen.dart';

class EvOtpSheet extends StatelessWidget {
  final String mobilNumber;
  final int userId;
  EvOtpSheet({super.key, required this.mobilNumber, required this.userId});
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        // left: 10,
        // right: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: BlocConsumer<AppAuthController, AppAuthControllerState>(
        listener: (context, state) async {
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

                await PushNotificationConfig().initNotification(context);
                showToastMessage(context, state.loginMesaage);
                Navigator.of(context).pushAndRemoveUntil(
                  AppRoutes.createRoute(EvDashboardScreen()),
                  (context) => false,
                );
              }
            default:
              {}
          }
        },
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.all(20),
            width: w(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
              color: VColors.WHITE,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSpacer(heightPortion: .02),
                  Text(
                    textAlign: TextAlign.center,
                    "We sent 6 digit verification code to",
                    style: VStyle.style(
                      context: context,
                      size: AppDimensions.fontSize15(context),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "+91 $mobilNumber",
                    style: VStyle.style(
                      context: context,
                      size: AppDimensions.fontSize17(context),
                      color: VColors.SECONDARY,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacer(heightPortion: .025),

                  Pinput(
                    length: 6,
                    controller: _otpController,
                    defaultPinTheme: _pintheme(
                      context,
                      TextFieldState.OUTOFFOCUS,
                    ),
                    errorPinTheme: _pintheme(context, TextFieldState.ERROR),
                    focusedPinTheme: _pintheme(context, TextFieldState.FOCUSED),
                    disabledPinTheme: _pintheme(
                      context,
                      TextFieldState.OUTOFFOCUS,
                    ),
                    submittedPinTheme: _pintheme(
                      context,
                      TextFieldState.OUTOFFOCUS,
                    ),
                    followingPinTheme: _pintheme(
                      context,
                      TextFieldState.FOCUSED,
                    ),
                  ),

                  AppSpacer(heightPortion: .03),
                  if (state is AuthErrorState) ...[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        state.errorMessage,
                        style: VStyle.poppins(
                          size: 12,
                          context: context,
                          color: VColors.ERROR,
                        ),
                      ),
                    ),
                  ],
                  BlocBuilder<AppAuthController, AppAuthControllerState>(
                    builder: (context, state) {
                      if (state is AuthCubitSendOTPState) {
                        if (state.isEnabledResendOTPButton == true) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Dont't receive the OTP ?",
                                style: VStyle.style(
                                  context: context,
                                  size: AppDimensions.fontSize13(context),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  HapticFeedback.mediumImpact();
                                  await context
                                      .read<AppAuthController>()
                                      .evaluatorRensendOTP(userId);
                                },
                                child: Text(
                                  "RESEND OTP",
                                  style: VStyle.style(
                                    context: context,
                                    size: AppDimensions.fontSize13(context),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "00:${state.runTime.toString()}",
                              style: EvAppStyle.poppins(
                                context: context,
                                fontWeight: FontWeight.bold,
                                size: 15,
                                color: EvAppColors.DEFAULT_ORANGE,
                              ),
                            ),
                          );
                        }
                      } else {
                        return SizedBox();
                      }
                    },
                  ),

                  AppSpacer(heightPortion: .01),

                  _buildEnhancedButton(
                    comtext: context,
                    isLoading: state is AuthLodingState,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        HapticFeedback.mediumImpact();
                        await context
                            .read<AppAuthController>()
                            .evaluatorVerifyOtp(
                              context,
                              mobilNumber,
                              _otpController.text.trim(),
                              userId,
                            );
                      } else {
                        HapticFeedback.lightImpact();
                      }
                    },
                  ),
                  // VCustomButton(
                  //   bgColor: VColors.SECONDARY,
                  //   width: w(context) * .7, title: "VERIFY"),
                  AppSpacer(heightPortion: .01),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PinTheme _pintheme(context, TextFieldState state) {
    Color borderColor;

    switch (state) {
      case TextFieldState.ERROR:
        {
          borderColor = VColors.ERROR;
        }
      case TextFieldState.FOCUSED:
        {
          borderColor = VColors.SECONDARY;
        }
      case TextFieldState.OUTOFFOCUS:
        {
          borderColor = VColors.SECONDARY.withAlpha(120);
        }
    }
    return PinTheme(
      textStyle: VStyle.style(
        context: context,
        color: borderColor,
        fontWeight: FontWeight.bold,
        size: AppDimensions.fontSize16(context),
      ),
      width: w(context) / 6,
      height: 50,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize15),
        border: Border.all(color: borderColor),
      ),
    );
  }

  Widget _buildEnhancedButton({
    required bool isLoading,
    required VoidCallback onTap,
    required BuildContext comtext,
  }) {
    return Container(
      height: 56,
      width: w(comtext) * .8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [VColors.SECONDARY, VColors.SECONDARY.withOpacity(0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: VColors.SECONDARY.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isLoading ? null : onTap,
          child: Center(
            child:
                isLoading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: VLoadingIndicator(),
                    )
                    : Text(
                      "VERIFY OTP",
                      style: VStyle.style(
                        context: comtext,
                        fontWeight: FontWeight.bold,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
