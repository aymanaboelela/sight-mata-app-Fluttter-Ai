import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'presentation/screens/map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: apiKey,
  );

  // bloc observer
  Bloc.observer = SimpleBlocObserver();
  // Ensure screen size is initialized for ScreenUtil
  await ScreenUtil.ensureScreenSize();

  // Initialize shared preferences or cache data
  await CacheData.cacheDataInit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MapCubit(
              MapsRepository(MapsWebService(Dio())), LocationService()),
          child: const MapScreen(
          ),
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
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
