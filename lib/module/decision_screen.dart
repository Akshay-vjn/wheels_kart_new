import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_const_images.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/auth/ev_login_screen.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/VENDOR/features/v_nav_screen.dart';

class DecisionScreen extends StatefulWidget {
  const DecisionScreen({super.key});

  @override
  State<DecisionScreen> createState() => _DecisionScreenState();
}

class _DecisionScreenState extends State<DecisionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Start animations
    _fadeAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              EvAppColors.white,
              EvAppColors.kAppSecondaryColor.withOpacity(0.05),
              EvAppColors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: AppMargin(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  AppSpacer(heightPortion: .08),

                  // Animated Logo
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: w(context) * .6,
                      padding: EdgeInsets.all(AppDimensions.paddingSize20),
                      decoration: BoxDecoration(),
                      child: Hero(
                        tag: "app_logo",
                        child: Image.asset(EvConstImages.appLogoHr),
                      ),
                    ),
                  ),

                  AppSpacer(heightPortion: .06),

                  // Animated Welcome Text
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text(
                            'Welcome Back!',
                            textAlign: TextAlign.center,
                            style: EvAppStyle.style(
                              fontWeight: FontWeight.w700,
                              size: AppDimensions.fontSize30(context),
                              context: context,
                              color: EvAppColors.kAppSecondaryColor,
                            ),
                          ),
                          // AppSpacer(heightPortion: .01),
                          Text(
                            'Choose your profile to continue',
                            textAlign: TextAlign.center,
                            style: EvAppStyle.style(
                              fontWeight: FontWeight.w400,
                              size: AppDimensions.fontSize16(context),
                              context: context,
                              color: EvAppColors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  AppSpacer(heightPortion: .05),

                  // Animated Decision Buttons
                  SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        _buildEnhancedDecisionButton(
                          context,
                          'Evaluator',
                          'Login as Wheels Kart Evaluator',
                          'Assess and evaluate vehicles',
                          EvConstImages.evaluatorImage,
                          Icons.assessment_outlined,
                          const Color(0xFF2E7D32),
                          () {
                            _navigateWithAnimation(EvLoginScreen());
                          },
                        ),

                        AppSpacer(heightPortion: .03),

                        _buildEnhancedDecisionButton(
                          context,
                          'Vendor',
                          'Login as Vendor / Dealer',
                          'Manage your vehicle inventory',
                          EvConstImages.vendorImage,
                          Icons.store_outlined,
                          const Color(0xFF1565C0),
                          () {
                           _navigateWithAnimation(VNavScreen());
                          },
                        ),
                      ],
                    ),
                  ),

                  AppSpacer(heightPortion: .05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateWithAnimation(Widget screen) {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Widget _buildEnhancedDecisionButton(
    BuildContext context,
    String title,
    String subtitle,
    String description,
    String? image,
    IconData fallbackIcon,
    Color accentColor,
    VoidCallback? onTap,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween(begin: 1.0, end: 1.0),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: w(context) * .9,
            margin: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingSize10,
            ),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
              shadowColor: accentColor.withOpacity(0.3),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
                onTap: onTap,
                onTapDown: (_) {
                  // Scale down animation on tap
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.all(AppDimensions.paddingSize25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSize18,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        accentColor.withOpacity(0.05),
                        Colors.white,
                      ],
                    ),
                    border: Border.all(
                      color: accentColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Icon/Image Container
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSize18,
                          ),
                          border: Border.all(
                            color: accentColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child:
                            image != null
                                ? Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(image, color: accentColor),
                                )
                                : Icon(
                                  fallbackIcon,
                                  color: accentColor,
                                  size: 28,
                                ),
                      ),

                      SizedBox(width: AppDimensions.paddingSize20),

                      // Text Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: EvAppStyle.style(
                                context: context,
                                color: EvAppColors.black,
                                fontWeight: FontWeight.w700,
                                size: AppDimensions.fontSize18(context),
                              ),
                            ),
                            SizedBox(height: AppDimensions.paddingSize5),
                            Text(
                              subtitle,
                              style: EvAppStyle.style(
                                context: context,
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                                size: AppDimensions.fontSize15(context),
                              ),
                            ),
                            SizedBox(height: AppDimensions.paddingSize5),
                            Text(
                              description,
                              style: EvAppStyle.style(
                                context: context,
                                color: EvAppColors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w400,
                                size: AppDimensions.fontSize12(context),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Arrow Icon
                      Container(
                        padding: EdgeInsets.all(AppDimensions.paddingSize10),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSize10,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
