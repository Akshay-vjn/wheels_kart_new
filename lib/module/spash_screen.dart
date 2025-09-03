import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/features/screens/auth/screens/terms_and_condion_accept_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_const_images.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/features/v_nav_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/module/decision_screen.dart';

import 'package:wheels_kart/module/EVALAUATOR/features/screens/ev_dashboard_screen.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loadingController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _loadingOpacityAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();

    Future.delayed(const Duration(milliseconds: 2500)).then((value) async {
      BlocProvider.of<AppAuthController>(context).checkForLogin(context);
    });
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Loading animation controller
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Text animations
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // Loading animation
    _loadingOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeIn),
    );

    // Background animation
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    // Particle animation
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeInOut),
    );
  }

  void _startAnimationSequence() async {
    // Start background and particle animations immediately
    _backgroundController.forward();
    _particleController.repeat();

    // Start logo animation after a short delay
    await Future.delayed(const Duration(milliseconds: 400));
    _logoController.forward();

    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Show loading after text
    await Future.delayed(const Duration(milliseconds: 800));

    _loadingController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<AppAuthController, AppAuthControllerState>(
      listener: (context, state) async {
        switch (state) {
          case AuthCubitAuthenticateState():
            {
              if (state.userModel.userType == "EVALUATOR" ||
                  state.userModel.userType == "ADMIN") {
                Navigator.of(context).pushAndRemoveUntil(
                  AppRoutes.createRoute(EvDashboardScreen()),
                  (context) => false,
                );
              } else {
                final getUserPref = await AppAuthController().getUserData;
                if (getUserPref.isDealerAcceptedTermsAndCondition == true) {
                  Navigator.of(context).pushAndRemoveUntil(
                    AppRoutes.createRoute(VNavScreen()),
                    (context) => false,
                  );
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                    AppRoutes.createRoute(VTermsAndCondionAcceptScreen()),
                    (context) => false,
                  );
                }
              }
            }
          case AuthCubitUnAuthenticatedState():
            {
              Navigator.of(context).pushAndRemoveUntil(
                AppRoutes.createRoute(DecisionScreen()),
                (context) => false,
              );
            }
          default:
            {}
        }
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    const Color(0xFF0F3460),
                    const Color(0xFF16213E).withOpacity(0.9),
                  ],
                  stops: [
                    0.0,
                    0.3 + (_backgroundAnimation.value * 0.2),
                    0.7 + (_backgroundAnimation.value * 0.1),
                    1.0,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Animated background particles/shapes
                  ...List.generate(6, (index) {
                    return AnimatedBuilder(
                      animation: _particleAnimation,
                      builder: (context, child) {
                        final offset = _particleAnimation.value * 2 * 3.14159;
                        return Positioned(
                          left:
                              50 +
                              (index * 60) +
                              (30 * math.sin(offset + index)),
                          top:
                              100 +
                              (index * 80) +
                              (40 * math.cos(offset + index * 0.5)),
                          child: Opacity(
                            opacity: 0.1,
                            child: Container(
                              width: 20 + (index * 5),
                              height: 20 + (index * 5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),

                  // Main content
                  SafeArea(
                    child: Column(
                      children: [
                        const Spacer(flex: 3),

                        // Logo section
                        Expanded(
                          flex: 4,
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _logoController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _logoScaleAnimation.value,
                                  child: Transform.rotate(
                                    angle: _logoRotationAnimation.value * 0.1,
                                    child: Opacity(
                                      opacity: _logoOpacityAnimation.value,
                                      child: Container(
                                        padding: const EdgeInsets.all(30),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          color: Colors.white.withOpacity(0.1),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.2,
                                            ),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 20,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: SizedBox(
                                          width: w(context) * 0.4,
                                          height: w(context) * 0.4,
                                          child: Hero(
                                            tag: "app_logo",
                                            child: Image.asset(
                                              EvConstImages.logoWhitePng,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        AnimatedBuilder(
                          animation: _textController,
                          builder: (context, child) {
                            return SlideTransition(
                              position: _textSlideAnimation,
                              child: FadeTransition(
                                opacity: _textOpacityAnimation,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 50),
                                    Text(
                                      'Your Trusted Vehicle Partner',
                                      style: EvAppStyle.style(
                                        context: context,
                                        size: 16,
                                        color: Colors.white.withAlpha(200),
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const Spacer(flex: 3),

                        // Loading section
                        // if (showLoading)
                        AnimatedBuilder(
                          animation: _loadingController,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _loadingOpacityAnimation,
                              child: Column(
                                children: [
                                  Text(
                                    'Preparing your automotive experience...',
                                    style: EvAppStyle.poppins(
                                      context: context,
                                      size: 12,
                                      color: Colors.white.withAlpha(180),
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SpinKitChasingDots(color: VColors.WHITE),
                                ],
                              ),
                            );
                          },
                        ),

                        const Spacer(flex: 1),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Import this at the top of your file
