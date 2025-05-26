import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20car%20make/fetch_car_make_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20car%20models/fetch_car_model_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20city/fetch_city_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20document%20types/fetch_document_type_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20documents/fetch_documents_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20inspection%20prefilled/fetch_prefill_data_of_inspection_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20picture%20angles/fetch_picture_angles_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20portions/fetch_portions_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20questions/fetch_questions_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20systems/fetch_systems_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch_dashboard/ev_fetch_dashboard_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch_vehilce_photo/fetch_uploaded_vehilce_photos_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/login%20page%20bloc/login_bloc_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/search/search%20car%20make/search_car_make_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/app%20navigation%20cubit/app_navigation_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/submit%20answer%20controller/submit_answer_controller_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/submit%20document/submit_document_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/upload%20vehilce%20photo/uplaod_vehilce_photo_cubit.dart';
import 'package:wheels_kart/module/spash_screen.dart';
import 'package:wheels_kart/module/vendor/data/cubit/auth/v_auth_controller_cubit.dart';
import 'package:wheels_kart/module/vendor/data/cubit/bottom_nav_controller/v_bottom_nav_controller_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: AppColors.DEFAULT_BLUE_DARK),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EvLoginBlocBloc>(create: (_) => EvLoginBlocBloc()),
        BlocProvider<EvFetchCarMakeBloc>(create: (_) => EvFetchCarMakeBloc()),
        BlocProvider<EvFetchCarModelBloc>(create: (_) => EvFetchCarModelBloc()),
        BlocProvider<EvSearchCarMakeBloc>(create: (_) => EvSearchCarMakeBloc()),
        BlocProvider<EvFetchCityBloc>(create: (_) => EvFetchCityBloc()),
        BlocProvider<EvAuthBlocCubit>(create: (_) => EvAuthBlocCubit()),
        BlocProvider<EvAppNavigationCubit>(
          create: (_) => EvAppNavigationCubit(),
        ),

        BlocProvider<EvFetchDashboardBloc>(
          create: (_) => EvFetchDashboardBloc(),
        ),
        BlocProvider<FetchInspectionsBloc>(
          create: (_) => FetchInspectionsBloc(),
        ),
        BlocProvider<FetchPortionsBloc>(create: (_) => FetchPortionsBloc()),
        BlocProvider<FetchSystemsBloc>(create: (_) => FetchSystemsBloc()),
        BlocProvider<FetchQuestionsBloc>(create: (_) => FetchQuestionsBloc()),
        BlocProvider<EvSubmitAnswerControllerCubit>(
          create: (_) => EvSubmitAnswerControllerCubit(),
        ),
        BlocProvider<EvFetchPrefillDataOfInspectionBloc>(
          create: (_) => EvFetchPrefillDataOfInspectionBloc(),
        ),
        BlocProvider<FetchDocumentTypeBloc>(
          create: (_) => FetchDocumentTypeBloc(),
        ),
        BlocProvider<FetchDocumentsCubit>(create: (_) => FetchDocumentsCubit()),
        BlocProvider<SubmitDocumentCubit>(create: (_) => SubmitDocumentCubit()),
        BlocProvider<FetchUploadedVehilcePhotosCubit>(create: (_) => FetchUploadedVehilcePhotosCubit()),
        BlocProvider<UplaodVehilcePhotoCubit>(create: (_) => UplaodVehilcePhotoCubit()),
        BlocProvider<FetchPictureAnglesCubit>(create: (_) => FetchPictureAnglesCubit()),
        // USER CONTROLLERS
        BlocProvider<VAuthControllerCubit>(
          create: (_) => VAuthControllerCubit(),
        ),
        BlocProvider<VBottomNavControllerCubit>(
          create: (_) => VBottomNavControllerCubit(),
        ),
      ],
      child: SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wheels Kart',
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              toolbarHeight: 70,
              color: AppColors.DEFAULT_BLUE_DARK,
            ),
            scaffoldBackgroundColor: AppColors.kScafoldBgColor,
            iconTheme: const IconThemeData(color: AppColors.DEFAULT_BLUE_DARK),
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.DEFAULT_BLUE_DARK,
            ),
            useMaterial3: true,
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
