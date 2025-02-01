// import 'package:akodo_api/features/addHouse/presentation/controller/addhouse/add_house_stite.dart';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/core/utils/router/page_transition.dart';
import 'package:sight_mate_app/presentation/screens/login_view.dart';
import 'package:sight_mate_app/presentation/screens/on_bording_view.dart';
import 'package:sight_mate_app/presentation/screens/splash_view.dart';

abstract class AppRouter {
  static const kOnBoardingView = '/onboardingView';
  static const login = '/login';

  // edit house

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) =>
            PageTransitionManager.fadeTransition(const SplashViewbody()),
      ),
      GoRoute(
        path: kOnBoardingView,
        pageBuilder: (context, state) =>
            PageTransitionManager.fadeTransition(const OnBordingView()),
      ),
      GoRoute(
        path: kOnBoardingView,
        pageBuilder: (context, state) =>
            PageTransitionManager.fadeTransition(const LoginView()),
      ),
    ],
  );
}
