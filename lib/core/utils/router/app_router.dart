// import 'package:akodo_api/features/addHouse/presentation/controller/addhouse/add_house_stite.dart';

import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/core/utils/router/page_transition.dart';
import 'package:sight_mate_app/presentation/screens/Distance_Off_view.dart';
import 'package:sight_mate_app/presentation/screens/create_acounte.dart';
import 'package:sight_mate_app/presentation/screens/home_view.dart';
import 'package:sight_mate_app/presentation/screens/login_view.dart';
import 'package:sight_mate_app/presentation/screens/on_bording_view.dart';
import 'package:sight_mate_app/presentation/screens/splash_view.dart';

abstract class AppRouter {
  static const kOnBoardingView = '/onboardingView';
  static const kLoginView = '/login';
  static const kHomeView = '/homeview';
  static const kSignUp = '/signup';
  static const kDistanceOff = '/DistanceOff';
  // edit house

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) =>
            PageTransitionManager.fadeTransition(const SplashViewbody()),
      ),
      GoRoute(
        path: kSignUp,
        pageBuilder: (context, state) =>
            PageTransitionManager.fadeTransition(const SignupView()),
      ),
      GoRoute(
        path: kOnBoardingView,
        pageBuilder: (context, state) =>
            PageTransitionManager.fadeTransition(const OnBordingView()),
      ),
      GoRoute(
        path: kLoginView,
        pageBuilder: (context, state) =>
            PageTransitionManager.fadeTransition(const LoginView()),
      ),
      GoRoute(
        path: kHomeView,
        pageBuilder: (context, state) =>
            PageTransitionManager.fadeTransition(HomeView()),
      ),
      GoRoute(
        path: kDistanceOff,
        pageBuilder: (context, state) =>
            PageTransitionManager.fadeTransition(const DistanceOffView()),
      ),
    ],
  );
}
