import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sight_mate_app/controllers/add_data_cubit/data_cubit.dart';
import 'package:sight_mate_app/controllers/auth/auth_cubit.dart';
import 'package:sight_mate_app/controllers/editprofile/editprofile_cubit.dart';
import 'package:sight_mate_app/core/constants/constans.dart';
import 'package:sight_mate_app/core/helper/cach_data.dart';
import 'package:sight_mate_app/core/helper/simple_bloc_observer.dart';
import 'package:sight_mate_app/core/utils/router/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'controllers/cubit/map_cubit.dart';
import 'core/helper/location/location_permission.dart';
import 'data/repository/map_repository.dart';
import 'data/source/apis/maps_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: apiKey,
  );

  // Initialize BLoC observer
  Bloc.observer = SimpleBlocObserver();

  // Initialize ScreenUtil
  await ScreenUtil.ensureScreenSize();

  // Initialize Cache
  await CacheData.cacheDataInit();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MapCubit>(
          create: (_) => MapCubit(
              MapsRepository(MapsWebService(Dio())), LocationService()),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<DataCubit>(
          create: (context) => DataCubit(),
        ),
        BlocProvider<EditprofileCubit>(
          create: (context) => EditprofileCubit(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
