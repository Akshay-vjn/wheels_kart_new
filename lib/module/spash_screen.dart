import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:wheels_kart/common/config/pushnotification_controller.dart';
import 'package:wheels_kart/module/Dealer/features/screens/auth/screens/terms_and_condion_accept_screen.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/features/v_nav_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_const_images.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/ev_dashboard_screen.dart';
import 'package:wheels_kart/module/decision_screen.dart';
import 'package:wheels_kart/common/controllers/auth cubit/auth_cubit.dart';

import 'package:new_version_plus/new_version_plus.dart';
import 'package:wheels_kart/common/config/app_config.dart';

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
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _loadingOpacityAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
    _handleStartupFlow();
  }

  // Combined update-check + login navigation
  Future<void> _handleStartupFlow() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    // Force update check using new_version_plus (only if enabled)
    if (AppConfig.forceUpdateEnabled) {
      await _checkForForceUpdate();
    }

    if (!mounted) return;

    // Continue existing login flow
    try {
      BlocProvider.of<AppAuthController>(context)
          .checkTheTokenValidity(context);
    } catch (_) {
      BlocProvider.of<AppAuthController>(context)
          .checkTheTokenValidity(context);
    }
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

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

    _textOpacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_textController);

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(_textController);

    _loadingOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      _loadingController,
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      _backgroundController,
    );
  }

  void _startAnimationSequence() async {
    try {
      if (!mounted) return;

      _backgroundController.forward();

      await Future.delayed(const Duration(milliseconds: 400));
      _logoController.forward();

      await Future.delayed(const Duration(milliseconds: 800));
      _textController.forward();

      await Future.delayed(const Duration(milliseconds: 800));
      _loadingController.forward();
    } catch (_) {}
  }

  // Force update check using new_version_plus
  Future<void> _checkForForceUpdate() async {
    try {
      final newVersion = NewVersionPlus(
        androidId: "com.crisant.wheelskart", 
        iOSId: "6749476545", 
      );

      final status = await newVersion.getVersionStatus();

      if (status?.canUpdate == true && mounted) {
        // Show force update dialog
        await showDialog(
          context: context,
          barrierDismissible: false, // Cannot dismiss
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.system_update,
                  color: EvAppColors.DEFAULT_BLUE_DARK,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Update Required",
                    style: EvAppStyle.style(
                      context: context,
                      size: 20,
                      fontWeight: FontWeight.bold,
                      color: EvAppColors.DEFAULT_BLUE_DARK,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please update to the latest version to continue using Wheels Kart.",
                  style: EvAppStyle.style(
                    context: context,
                    size: 16,
                    color: EvAppColors.DEFAULT_BLUE_DARK,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: EvAppColors.DEFAULT_BLUE_DARK,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "This update includes important improvements and bug fixes.",
                          style: EvAppStyle.style(
                            context: context,
                            size: 14,
                            color: EvAppColors.DEFAULT_BLUE_DARK,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (status?.appStoreLink != null) {
                      newVersion.launchAppStore(status!.appStoreLink);
                    }
                  },
                  icon: const Icon(Icons.download),
                  label: const Text("Update Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error checking for updates: $e");
      // Continue with app flow even if update check fails
    }
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
      listener: (context, state) async {
        switch (state) {
          case AuthCubitAuthenticateState():
            if (state.userModel.userType == "EVALUATOR" ||
                state.userModel.userType == "ADMIN") {
              await PushNotificationConfig().initNotification(context);
              Navigator.of(context).pushAndRemoveUntil(
                AppRoutes.createRoute(EvDashboardScreen()),
                    (context) => false,
              );
            } else {
              final getUserPref = await AppAuthController().getUserData;
              if (getUserPref.isDealerAcceptedTermsAndCondition == true) {
                await PushNotificationConfig().initNotification(context);
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
            break;
          case AuthCubitUnAuthenticatedState():
            Navigator.of(context).pushAndRemoveUntil(
              AppRoutes.createRoute(DecisionScreen()),
                  (context) => false,
            );
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                    Color(0xFF0F3460),
                    Color(0xFF16213E),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 3),
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
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white.withOpacity(0.1),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
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
                              const SpinKitChasingDots(color: Colors.white),
                            ],
                          ),
                        );
                      },
                    ),
                    const Spacer(flex: 1),
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