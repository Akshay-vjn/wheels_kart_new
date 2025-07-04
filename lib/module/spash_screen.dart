import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_const_images.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/features/v_nav_screen.dart';
import 'package:wheels_kart/module/decision_screen.dart';

import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';
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

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  // late Animation<double> _textOpacityAnimation;
  // late Animation<Offset> _textSlideAnimation;
  late Animation<double> _loadingOpacityAnimation;
  late Animation<double> _backgroundAnimation;

  bool showLoading = false;
  bool showText = false;

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
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Loading animation controller
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Text animations
    // _textOpacityAnimation = Tween<double>(
    //   begin: 0.0,
    //   end: 1.0,
    // ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // _textSlideAnimation = Tween<Offset>(
    //   begin: const Offset(0, 0.5),
    //   end: Offset.zero,
    // ).animate(
    //   CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    // );

    // Loading animation
    _loadingOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeIn),
    );

    // Background animation
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );
  }

  void _startAnimationSequence() async {
    // Start background animation immediately
    _backgroundController.forward();

    // Start logo animation after a short delay
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => showText = true);
    _textController.forward();

    // Show loading after text
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => showLoading = true);
    _loadingController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppAuthController, AppAuthControllerState>(
      listener: (context, state) {
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
                Navigator.of(context).pushAndRemoveUntil(
                  AppRoutes.createRoute(VNavScreen()),
                  (context) => false,
                );
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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).primaryColor.withAlpha(10),
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).primaryColor.withAlpha(10),
                  ],
                  stops: [
                    0.0,
                    0.0,
                    0.5 + (_backgroundAnimation.value * 0.3),
                    0.0,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    AppSpacer(heightPortion: .05),
                    Expanded(
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _logoController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _logoScaleAnimation.value,
                              child: Opacity(
                                opacity: _logoOpacityAnimation.value,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: SizedBox(
                                    width: w(context) * 0.5,
                                    height: w(context) * 0.5,
                                    child: Hero(
                                      tag: "app_logo",
                                      child: Image.asset(
                                        EvConstImages.appLogoHr,
                                        fit: BoxFit.contain,
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

                    // Bottom section with loading
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // if (showLoading)
                        AnimatedBuilder(
                          animation: _loadingController,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _loadingOpacityAnimation,
                              child: Column(
                                children: [
                                  // Custom Loading Indicator
                                  SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Stack(
                                      children: [
                                        // Background circle
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(
                                              context,
                                            ).primaryColor.withOpacity(0.1),
                                          ),
                                        ),
                                        // Loading indicator
                                        Center(child: EVAppLoadingIndicator()),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Loading your experience...',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withOpacity(0.6),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    AppSpacer(heightPortion: .05),

                    // Bottom padding
                    // const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
