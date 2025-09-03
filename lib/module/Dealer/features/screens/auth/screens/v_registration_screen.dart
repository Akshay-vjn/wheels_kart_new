import 'package:flutter/gestures.dart';
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
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_image_const.dart';
import 'package:wheels_kart/module/Dealer/core/utils/v_messages.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/screens/terms_and_condition_screen.dart';
import 'package:wheels_kart/module/Dealer/features/screens/auth/screens/v_login_screen.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_button.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_texfield.dart';

class VRegistrationScreen extends StatefulWidget {
  VRegistrationScreen({super.key});

  @override
  State<VRegistrationScreen> createState() => _VRegistrationScreenState();
}

class _VRegistrationScreenState extends State<VRegistrationScreen>
    with TickerProviderStateMixin {
  final _mobileNumberController = TextEditingController();

  final _emailContller = TextEditingController();

  final _fullNameController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordContoller = TextEditingController();

  final _cityController = TextEditingController();

  final _mobileFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confimrPasswordFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _fullNameFocusNode = FocusNode();
  final _cityFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  late AnimationController _fadeController;

  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;

  late Animation<Offset> _slideAnimation;

  bool _isPasswordVisible = false;

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  void _setupFocusListeners() {
    _mobileFocusNode.addListener(() {
      if (_mobileFocusNode.hasFocus) {
        HapticFeedback.selectionClick();
      }
    });

    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        HapticFeedback.selectionClick();
      }
    });
  }

  bool _isTermsAccepted = false;
  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _mobileFocusNode.dispose();
    _passwordFocusNode.dispose();
    _mobileNumberController.dispose();
    _passwordController.dispose();
    _cityController.dispose();
    _confirmPasswordContoller.dispose();
    _emailContller.dispose();
    _fullNameController.dispose();
    _confimrPasswordFocusNode.dispose();
    _emailFocusNode.dispose();
    _fullNameFocusNode.dispose();
    _cityFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initializeAnimations();
    _setupFocusListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AppAuthController, AppAuthControllerState>(
        listener: (context, state) {
          // switch (state) {
          //   case AuthErrorState():
          //     {
          //       HapticFeedback.heavyImpact();
          //       vSnackBarMessage(
          //         context,
          //         state.errorMessage,
          //         state: VSnackState.ERROR,
          //       );
          //     }
          //   case AuthCubitAuthenticateState():
          //     {
          //       HapticFeedback.mediumImpact();
          //       showToastMessage(context, state.loginMesaage);
          //       Navigator.of(context).pushAndRemoveUntil(
          //         AppRoutes.createRoute(VLoginScreen()),
          //         (context) => false,
          //       );
          //     }
          //   default:
          //     {}
          // }
        },
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [_buildHeader(context), _buildLoginForm(context)],
                ),
              ),
              Positioned(left: 0, child: SafeArea(child: VCustomBackbutton())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: h(context) * 0.45,
      child: Stack(
        children: [
          // Clean gradient background
          Container(
            width: w(context),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  VColors.SECONDARY.withAlpha(200),
                  VColors.SECONDARY,
                  VColors.SECONDARY.withAlpha(220),
                ],
              ),
            ),
          ),

          // Decorative shapes
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          Positioned(
            top: 80,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // Back button

          // Welcome text with animation
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign Up",
                      style: VStyle.style(
                        context: context,
                        fontWeight: FontWeight.bold,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Create an account to continue",
                      style: VStyle.style(
                        context: context,
                        fontWeight: FontWeight.w400,
                        size: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              _buildEnhancedTextField(
                controller: _fullNameController,
                focusNode: _fullNameFocusNode,
                label: "Name",
                hint: "Enter your name",
                keyboardType: TextInputType.text,
                prefixIcon: Icons.person,
                validator: (value) => Validator.validateRequired(value),
              ),
              const SizedBox(height: 24),
              _buildEnhancedTextField(
                controller: _mobileNumberController,
                focusNode: _mobileFocusNode,
                label: "Mobile Number",
                hint: "Enter your mobile number",
                keyboardType: TextInputType.number,
                prefixIcon: Icons.phone_outlined,
                validator: (value) => Validator.validateMobileNumber(value),
              ),
              const SizedBox(height: 24),

              _buildEnhancedTextField(
                controller: _emailContller,
                focusNode: _emailFocusNode,
                label: "email",
                hint: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail,
                validator: (value) => Validator.validateEmail(value),
              ),

              const SizedBox(height: 24),
              _buildEnhancedTextField(
                controller: _cityController,
                focusNode: _cityFocusNode,
                label: "City",
                hint: "Enter your city",
                keyboardType: TextInputType.text,
                prefixIcon: Icons.location_city,
                validator: (value) => Validator.validateRequired(value),
              ),
              const SizedBox(height: 40),

              // Password Field
              _buildEnhancedTextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                label: "Password",
                hint: "Enter your password",
                isPassword: true,
                prefixIcon: Icons.lock_outline,
                validator: (value) => Validator.validateRequired(value),
              ),
              const SizedBox(height: 24),
              _buildEnhancedTextField(
                controller: _confirmPasswordContoller,
                focusNode: _confimrPasswordFocusNode,
                label: "Confirm Password",
                hint: "Re-enter your password",
                isPassword: true,
                prefixIcon: Icons.lock_outline,
                validator: (value) {
                  if (_passwordController.text !=
                      _confirmPasswordContoller.text) {
                    return "Password does not match";
                  }
                  return Validator.validateRequired(value);
                },
              ),

              const SizedBox(height: 10),
              // Row(
              //   children: [
              //     Checkbox.adaptive(
              //       activeColor: VColors.SUCCESS,
              //       value: _isTermsAccepted,
              //       onChanged:
              //           (value) =>
              //               setState(() => _isTermsAccepted = value ?? false),
              //     ),
              //     Expanded(
              //       child: GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             _isTermsAccepted = !_isTermsAccepted;
              //           });
              //         },
              //         child: RichText(
              //           text: TextSpan(
              //             text: "I accept the  ",
              //             style: VStyle.style(
              //               context: context,
              //               size: 13,
              //               color: VColors.BLACK,
              //             ),
              //             children: [
              //               TextSpan(
              //                 text: "Terms & Conditions",
              //                 style: VStyle.style(
              //                   context: context,
              //                   size: 13,
              //                   color: VColors.SECONDARY,
              //                   decoration: TextDecoration.underline,
              //                 ),
              //                 recognizer:
              //                     TapGestureRecognizer()
              //                       ..onTap = () {
              //                         // Navigate to Terms & Conditions page

              //                         Navigator.push(
              //                           context,
              //                           AppRoutes.createRoute(
              //                             VTermsAndConditionScreen(),
              //                           ),
              //                         );
              //                       },
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 10),

              // Sign In Button
              BlocBuilder<AppAuthController, AppAuthControllerState>(
                builder: (context, state) {
                  return _buildEnhancedButton(
                    isLoading: state is AuthLodingState,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        // if (!_isTermsAccepted) {
                        //   HapticFeedback.heavyImpact();
                        //   vSnackBarMessage(
                        //     context,
                        //     "Accept Terms & Conditions to proceed",
                        //     state: VSnackState.ERROR,
                        //   );
                        // } else {
                        HapticFeedback.mediumImpact();
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
                          // }
                        }
                      } else {
                        HapticFeedback.lightImpact();
                      }
                    },
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Aleady have an account? ",
                    style: VStyle.style(
                      context: context,
                      size: 14,
                      color: VColors.BLACK,
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
                        size: 14,
                        color: VColors.SECONDARY,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedButton({
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 56,
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
                      "SIGN UP",
                      style: VStyle.style(
                        context: context,
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

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData prefixIcon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(60),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: isPassword && !_isPasswordVisible,
        validator: validator,
        style: VStyle.style(
          context: context,
          size: 16,
          color: Colors.grey[800],
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(
            prefixIcon,
            color: focusNode.hasFocus ? VColors.SECONDARY : Colors.grey[400],
          ),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey[400],
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                      HapticFeedback.selectionClick();
                    },
                  )
                  : null,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: VColors.SECONDARY, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          labelStyle: VStyle.style(
            context: context,
            color: focusNode.hasFocus ? VColors.SECONDARY : Colors.grey[600],
            size: 14,
          ),
          hintStyle: VStyle.style(
            context: context,
            color: Colors.grey[400],
            size: 14,
          ),
        ),
        onTap: () {
          HapticFeedback.selectionClick();
        },
      ),
    );
  }
}
