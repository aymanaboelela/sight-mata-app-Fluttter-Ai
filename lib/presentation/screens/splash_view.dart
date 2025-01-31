import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/core/helper/cach_data.dart';
import 'package:sight_mate_app/core/utils/router/app_router.dart';

class SplashViewbody extends StatefulWidget {
  const SplashViewbody({super.key});
  @override
  State<SplashViewbody> createState() => _SplashViewbodyState();
}

class _SplashViewbodyState extends State<SplashViewbody>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _animation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = Tween<double>(begin: .2, end: 1).animate(_animationController!)
      ..addListener(() {
        setState(() {});
      });
    _animationController?.repeat(reverse: true);
    _goToNewScreen();
  }

  @override
  void dispose() {
    _animationController?.dispose();
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
          // Image.asset(kBackGrawendSplash),
          AnimatedBuilder(
            animation: _animation!,
            builder: (context, _) => Opacity(
              opacity: _animation?.value,
              child: Center(
                child: Text(
                  "logo &name",
                  style: TextStyle(fontSize: 50.sp),
                ),

                // child: SvgPicture.asset(
                //   AppAssets.logo,
                //   color: Colors.white,
                //   // height: 100.h,
                // ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void _goToNewScreen() {
    Future.delayed(
      const Duration(
        seconds: 3,
      ),
      () {
        GoRouter.of(context).pushReplacement(AppRouter.kOnBoardingView);
      },
    );
  }
}
