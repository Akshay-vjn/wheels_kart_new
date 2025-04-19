import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/images.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/decision_screen.dart';

import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/home/ev_dashboard_screen.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/auth%20cubit/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed((const Duration(seconds: 2))).then((value) async {
      // await context.read<EvAuthBlocCubit>().clearPreferenceData(context);

      BlocProvider.of<EvAuthBlocCubit>(context).checkForLogin(context);
    });
  }

  bool showLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<EvAuthBlocCubit, EvAuthBlocState>(
      listener: (context, state) {
        switch (state) {
          case AuthCubitAuthenticateState():
            {
              Navigator.of(context).pushAndRemoveUntil(
                AppRoutes.createRoute(EvDashboardScreen()),
                (context) => false,
              );
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppSpacer(heightPortion: .1),
              TweenAnimationBuilder<double>(
                onEnd: () {
                  setState(() {
                    showLoading = true;
                  });
                },
                duration: Duration(seconds: 1),
                tween: Tween(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: SizedBox(
                      width: w(context) * .6,
                      child: Image.asset(ConstImages.appLogo),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 100,
                child: Visibility(
                  visible: showLoading,
                  child: AppLoadingIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
