import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';
import 'package:sight_mate_app/core/constants/cach_data_const.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/core/helper/cach_data.dart';
import 'package:sight_mate_app/core/utils/router/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashViewbody extends StatefulWidget {
  const SplashViewbody({super.key});

  @override
  State<SplashViewbody> createState() => _SplashViewbodyState();
}

class _SplashViewbodyState extends State<SplashViewbody>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(begin: 0.2, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _animationController.repeat(reverse: true);

    // Delay checking session until the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _goToNewScreen();
    });
  }

  final bool _hasSeenOnboarding =
      CacheData.getData(key: AppCacheData.isOnBordingFinshed) ?? false;
  final bool isAdmin = CacheData.getData(key: AppCacheData.isAdmin) ?? false;
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlueColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) => Opacity(
              opacity: _animation.value,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only(left: 35),
                child: Image.asset(AppAssets.logo2),
              )),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  /// Navigates to the correct screen after 3 seconds
  void _goToNewScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      // CacheData.clearData(clearData: true);
      final session = Supabase.instance.client.auth.currentSession;
      if (_hasSeenOnboarding == false) {
        GoRouter.of(context).pushReplacement(AppRouter.kOnBoardingView);
      } else if (session != null) {
        if (isAdmin == false) {
          GoRouter.of(context).pushReplacement(AppRouter.KBLindHomeView);
        } else {
          GoRouter.of(context).pushReplacement(AppRouter.kHomeView);
        }
      } else {
        GoRouter.of(context).pushReplacement(AppRouter.kLoginView);
      }
    });
  }
}
