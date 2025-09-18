import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wheels_kart/common/block_providers.dart';
import 'package:wheels_kart/firebase_options.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/spash_screen.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // AppAuthController().clearPreferenceData(context);
    return blocProviders(
      MaterialApp(
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        title: 'Wheels Kart',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            toolbarHeight: 70,
            color: EvAppColors.DEFAULT_BLUE_DARK,
          ),
          scaffoldBackgroundColor: EvAppColors.kScafoldBgColor,
          iconTheme: const IconThemeData(color: EvAppColors.DEFAULT_BLUE_DARK),
          colorScheme: ColorScheme.fromSeed(
            seedColor: EvAppColors.DEFAULT_BLUE_DARK,
          ),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
// HELLOOO