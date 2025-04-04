import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/decision_screen.dart';

import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/home/e_dashboard_screen.dart';
import 'package:wheels_kart/module/evaluator/data/cubit/auth%20cubit/auth_cubit.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<EvAuthBlocCubit, EvAuthBlocState>(
      listener: (context, state) {
        switch (state) {
          case AuthCubitAuthenticateState():
            {
              Navigator.of(context).pushAndRemoveUntil(
                  AppRoutes.createRoute(EvDashboardScreen()),
                  (context) => false);
            }
          case AuthCubitUnAuthenticatedState():
            {
              Navigator.of(context).pushAndRemoveUntil(
                  AppRoutes.createRoute(DecisionScreen()), (context) => false);
            }
          default:
            {}
        }
      },
      child: Scaffold(
        body: Center(
          child: AppLoadingIndicator(),
        ),
      ),
    );
  }
}
