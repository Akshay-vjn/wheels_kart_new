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
import 'package:wheels_kart/module/Dealer/features/screens/auth/screens/v_registration_screen.dart';
import 'package:wheels_kart/module/Dealer/features/v_nav_screen.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_button.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_texfield.dart';

class VLoginScreen extends StatefulWidget {
  VLoginScreen({super.key});

  @override
  State<VLoginScreen> createState() => _VLoginScreenState();
}

class _VLoginScreenState extends State<VLoginScreen>
    with TickerProviderStateMixin {
  final _mobileNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _mobileFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupFocusListeners();
  }

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

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _mobileFocusNode.dispose();
    _passwordFocusNode.dispose();
    _mobileNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [_buildHeader(context), _buildLoginForm(context)],
            ),
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
          Positioned(left: 0, child: SafeArea(child: VCustomBackbutton())),

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
                      "Welcome Back",
                      style: VStyle.style(
                        context: context,
                        fontWeight: FontWeight.w300,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                          "Sign In",
                          style: VStyle.style(
                            context: context,
                            fontWeight: FontWeight.bold,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                    const SizedBox(height: 12),
                    Text(
                      "Enter your credentials to continue",
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
                controller: _mobileNumberController,
                focusNode: _mobileFocusNode,
                label: "Mobile Number",
                hint: "Enter your mobile number",
                keyboardType: TextInputType.number,
                prefixIcon: Icons.phone_outlined,
                validator: (value) => Validator.validateMobileNumber(value),
              ),

              const SizedBox(height: 24),

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

              const SizedBox(height: 16),

              // Forgot password
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () {
              //       HapticFeedback.selectionClick();
              //       // Handle forgot password
              //     },
              //     child: Text(
              //       "Forgot Password?",
              //       style: VStyle.style(
              //         context: context,
              //         size: 14,
              //         color: VColors.SECONDARY,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),

              const SizedBox(height: 32),

              // Sign In Button
              BlocBuilder<AppAuthController, AppAuthControllerState>(
                builder: (context, state) {
                  return _buildEnhancedButton(
                    isLoading: state is AuthLodingState,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        HapticFeedback.mediumImpact();
                        await context.read<AppAuthController>().loginVendor(
                          context,
                          _mobileNumberController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      } else {
                        HapticFeedback.lightImpact();
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 48),
            ],
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
            color: Colors.grey.withAlpha(100),
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
                      child:VLoadingIndicator(
                    
                      ),
                    )
                    : Text(
                      "SIGN IN",
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
}
