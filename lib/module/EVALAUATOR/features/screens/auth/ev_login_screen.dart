import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wheels_kart/common/config/pushnotification_controller.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/auth/ev_otp_sheet.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/auth/ev_registration_Screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/ev_dashboard_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/app%20navigation%20cubit/app_navigation_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/login%20page%20bloc/login_bloc_bloc.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';

import '../../../../../common/utils/custome_show_messages.dart';

class EvLoginScreen extends StatefulWidget {
  const EvLoginScreen({super.key});

  @override
  State<EvLoginScreen> createState() => _EvLoginScreenState();
}

class _EvLoginScreenState extends State<EvLoginScreen>
    with TickerProviderStateMixin {
  final _mobileNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _slideAnimationController;
  late AnimationController _fadeAnimationController;
  late AnimationController _scaleAnimationController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isFormValid = false;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupKeyboardListener();
    _setupFormListener();
  }

  void _setupAnimations() {
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Start animations
    _fadeAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _scaleAnimationController.forward();
    });
  }

  void _setupKeyboardListener() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      setState(() {
        _isKeyboardVisible = keyboardHeight > 0;
      });
    });
  }

  void _setupFormListener() {
    _mobileNumberController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _mobileNumberController.text.length == 10;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    _fadeAnimationController.dispose();
    _scaleAnimationController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocListener<AppAuthController, AppAuthControllerState>(
        listener: (context, state) async {
          switch (state) {
            case AuthErrorState():
              {
                HapticFeedback.heavyImpact();
                showSnakBar(
                  context,
                  state.errorMessage,
                  isError: true,
                  enablePop: true,
                );
              }
            case AuthCubitSendOTPState():
              {
                if (state.isEnabledResendOTPButton != false &&
                    state.runTime == null) {
                  HapticFeedback.mediumImpact();

                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSize18,
                      ),
                    ),
                    backgroundColor: EvAppColors.white,
                    context: context,
                    builder:
                        (context) => EvOtpSheet(
                          mobilNumber: _mobileNumberController.text.trim(),
                          userId: state.userId,
                        ),
                  );
                }

                // await PushNotificationConfig().initNotification(context);
                // showToastMessage(context, state.loginMesaage);
                // Navigator.of(context).pushAndRemoveUntil(
                //   AppRoutes.createRoute(EvDashboardScreen()),
                //   (context) => false,
                // );
              }
            case AuthLodingState():
              {
                showCustomLoadingDialog(context);
              }
            default:
              {}
          }
        },
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
                  child: AppMargin(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Header Section
                          Expanded(
                            flex: 2,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // App Icon/Logo placeholder
                                  ScaleTransition(
                                    scale: _scaleAnimation,
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: EvAppColors.kAppSecondaryColor,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: EvAppColors
                                                .kAppSecondaryColor
                                                .withOpacity(0.3),
                                            blurRadius: 20,
                                            spreadRadius: 5,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Iconsax.user_octagon,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Welcome Text
                                  SlideTransition(
                                    position: _slideAnimation,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Welcome Back!',
                                          style: EvAppStyle.style(
                                            fontWeight: FontWeight.w700,
                                            size: AppDimensions.fontSize25(
                                              context,
                                            ),
                                            context: context,
                                            color: EvAppColors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Sign in to your ',
                                                style: EvAppStyle.style(
                                                  context: context,
                                                  fontWeight: FontWeight.w400,
                                                  size:
                                                      AppDimensions.fontSize16(
                                                        context,
                                                      ),
                                                  color: EvAppColors.black
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'Evaluator Account',
                                                style: EvAppStyle.style(
                                                  size:
                                                      AppDimensions.fontSize16(
                                                        context,
                                                      ),
                                                  fontWeight: FontWeight.w600,
                                                  context: context,
                                                  color:
                                                      EvAppColors
                                                          .kAppSecondaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Form Section
                          Expanded(
                            flex: 2,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Container(
                                padding: EdgeInsets.all(
                                  AppDimensions.paddingSize25,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      AppDimensions.radiusSize18,
                                    ),
                                    topRight: Radius.circular(
                                      AppDimensions.radiusSize18,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                      offset: const Offset(0, -5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Form Header
                                    Container(
                                      width: 40,
                                      height: 4,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 30),
                                      child: Container(
                                        width: 40,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Mobile Number Field
                                    _buildEnhancedTextField(
                                      controller: _mobileNumberController,
                                      label: 'Mobile Number',
                                      hint: 'Enter your 10-digit mobile number',
                                      prefixIcon: Iconsax.mobile,
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'Please enter your mobile number';
                                        }
                                        if (value!.length != 10) {
                                          return 'Please enter a valid 10-digit mobile number';
                                        }
                                        return null;
                                      },
                                    ),

                                    // const SizedBox(height: 20),

                                    // Password Field
                                    AppSpacer(heightPortion: .05),

                                    // Forgot Password
                                    // Align(
                                    //   alignment: Alignment.centerRight,
                                    //   child: TextButton(
                                    //     onPressed: () {
                                    //       HapticFeedback.lightImpact();
                                    //       // TODO: Implement forgot password
                                    //     },
                                    //     child: Text(
                                    //       'Forgot Password?',
                                    //       style: AppStyle.style(
                                    //         fontWeight: FontWeight.w600,
                                    //         context: context,
                                    //         color: AppColors.kAppSecondaryColor,
                                    //         size: AppDimensions.fontSize15(context),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),

                                    // const Spacer(),

                                    // Login Button
                                    _buildEnhancedButton(
                                      onTap: () async {
                                        if (_formKey.currentState!.validate()) {
                                          HapticFeedback.mediumImpact();
                                          context
                                              .read<EvAppNavigationCubit>()
                                              .handleBottomnavigation(0);

                                          await context
                                              .read<AppAuthController>()
                                              .sendOtpForEvaluator(
                                                context,
                                                _mobileNumberController.text,
                                              );
                                        } else {
                                          HapticFeedback.heavyImpact();
                                        }
                                      },
                                      title: 'GET OTP',
                                      isEnabled: _isFormValid,
                                    ),

                                    const SizedBox(height: 5),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Don't have an account?",
                                          style: EvAppStyle.style(
                                            context: context,
                                            color: EvAppColors.black
                                                .withOpacity(0.6),
                                            size: AppDimensions.fontSize15(
                                              context,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              AppRoutes.createRoute(
                                                const EvRegistrationScreen(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Sign Up',
                                            style: EvAppStyle.style(
                                              context: context,
                                              color:
                                                  EvAppColors
                                                      .kAppSecondaryColor,
                                              fontWeight: FontWeight.w600,
                                              size: AppDimensions.fontSize15(
                                                context,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Additional Options
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     Text(
                                    //       'Need help? ',
                                    //       style: AppStyle.style(
                                    //         context: context,
                                    //         color: AppColors.black.withOpacity(0.6),
                                    //         size: AppDimensions.fontSize15(context),
                                    //       ),
                                    //     ),
                                    //     GestureDetector(
                                    //       onTap: () {
                                    //         HapticFeedback.lightImpact();
                                    //         // TODO: Implement support
                                    //       },
                                    //       child: Text(
                                    //         'Contact Support',
                                    //         style: AppStyle.style(
                                    //           context: context,
                                    //           color: AppColors.kAppSecondaryColor,
                                    //           fontWeight: FontWeight.w600,
                                    //           size: AppDimensions.fontSize15(context),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: evCustomBackButton(context, color: EvAppColors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    int? maxLength,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: EvAppStyle.style(
            context: context,
            fontWeight: FontWeight.w600,
            color: EvAppColors.black.withOpacity(0.8),
            size: AppDimensions.fontSize15(context),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              prefixIcon,
              color: EvAppColors.kAppSecondaryColor,
              size: 20,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
              borderSide: BorderSide(
                color: EvAppColors.kAppSecondaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingSize20,
              vertical: AppDimensions.paddingSize15,
            ),
            counterText: '',
            hintStyle: EvAppStyle.style(
              context: context,
              color: Colors.grey[500],
              size: AppDimensions.fontSize15(context),
            ),
          ),
          style: EvAppStyle.style(
            context: context,
            fontWeight: FontWeight.w500,
            size: AppDimensions.fontSize16(context),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedButton({
    required VoidCallback onTap,
    required String title,
    bool isEnabled = true,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isEnabled ? EvAppColors.kAppSecondaryColor : Colors.grey[300],
          foregroundColor: Colors.white,
          elevation: isEnabled ? 8 : 0,
          shadowColor: EvAppColors.kAppSecondaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: EvAppStyle.style(
                context: context,
                fontWeight: FontWeight.w600,
                color: isEnabled ? Colors.white : Colors.grey[600],
                size: AppDimensions.fontSize16(context),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Iconsax.arrow_right_3,
              color: isEnabled ? Colors.white : Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
