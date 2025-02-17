// import 'package:akodo_api/features/addHouse/presentation/controller/addhouse/add_house_stite.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/controllers/editprofile/editprofile_cubit.dart';
import 'package:sight_mate_app/core/utils/router/page_transition.dart';
import 'package:sight_mate_app/models/data_mode.dart';
import 'package:sight_mate_app/presentation/screens/About_view.dart';
import 'package:sight_mate_app/presentation/screens/BLindHome_View.dart';
import 'package:sight_mate_app/presentation/screens/Help_View.dart';
import 'package:sight_mate_app/presentation/screens/Distance_Off_view.dart';
import 'package:sight_mate_app/presentation/screens/MyProfile_view.dart';
import 'package:sight_mate_app/presentation/screens/UserLocationNow_view.dart';
import 'package:sight_mate_app/presentation/screens/create_acounte.dart';
import 'package:sight_mate_app/presentation/screens/home_view.dart';
import 'package:sight_mate_app/presentation/screens/login_view.dart';
import 'package:sight_mate_app/presentation/screens/splash_view.dart';

abstract class AppRouter {
  static const kOnBoardingView = '/onboardingView';
  static const kLoginView = '/login';
  static const kHomeView = '/homeview';
  static const kSignUp = '/signup';
  static const kDistanceOff = '/DistanceOff';
  static const kMyProfileView = '/MyProfileView';
  static const kettingsView = '/SettingsView';
  static const kAboutView = '/AboutView';
  static const khelpView = '/khelpView';
  static const kUserLocationNow = '/kUserLocationNow';
    static const KBLindHomeView = '/BLindHomeView';


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
            PageTransitionManager.fadeTransition(DistanceOffView(
          onTap: () {},
        )),
      ),
      GoRoute(
        path: kMyProfileView,
        pageBuilder: (context, state) =>
            PageTransitionManager.fadeTransition(MyprofileView()),
      ),
      GoRoute(
        path: kAboutView,
        pageBuilder: (context, state) =>
            PageTransitionManager.fadeTransition(AboutView()),
      ),
      GoRoute(
        path: khelpView,
        pageBuilder: (context, state) =>
            PageTransitionManager.fadeTransition(HelpView()),
      ),
       GoRoute(
        path: KBLindHomeView,
        pageBuilder: (context, state) =>
            PageTransitionManager.fadeTransition(HomeBlindView()),
      ),
      GoRoute(
          path: kUserLocationNow,
          pageBuilder: (context, state) {
            final data = state.extra as DataModel;
            return PageTransitionManager.fadeTransition(UserlocationnowView(
              data: data,
            ));
          }),
    ],
  );
}
