import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';
import 'package:sight_mate_app/core/constants/cach_data_const.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/presentation/widgets/on_bording_back_round.dart';
import 'package:sight_mate_app/presentation/widgets/on_bording_dots.dart';
import '../../core/helper/cach_data.dart';
import '../../core/utils/router/app_router.dart';
import '../../core/widgets/custom_buttons.dart';

class OnBordingView extends StatefulWidget {
  const OnBordingView({super.key});

  @override
  State<OnBordingView> createState() => _OnBordingViewState();
}

class _OnBordingViewState extends State<OnBordingView> {
  int _currentPage = 0;
  final PageController _pageController1 = PageController();

  @override
  void dispose() {
    _pageController1.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const OnbordingBackGround(),
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    CacheData.setData(
                        key: AppCacheData.isOnBordingFinshed, value: true);
                    GoRouter.of(context).pushReplacement(AppRouter.kLoginView);
                    // _pageController1.jumpToPage(2);
                    // _pageController2.jumpToPage(2);
                    // _pageController3.jumpToPage(2);
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController1,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: const [
                      CustomOnpordingPageView(
                        heading: "Track Their Journey in Real Time",
                        image: AppAssets.onbording1,
                        subHeading:
                            "Easily monitor your loved one's real-time\n location, ensuring they’re always safe and within\n reach—only when they enable it.",
                      ),
                      CustomOnpordingPageView(
                        heading: "Get Alerts When They Go Too Far",
                        image: AppAssets.onbording2,
                        subHeading:
                            "Receive instant notifications if \nyour loved one moves beyond a safe distance.\n You set the limit, and we’ll keep you informed.",
                      ),
                      CustomOnpordingPageView(
                        heading: "Immediate Alerts When It Matters Most",
                        image: AppAssets.onbording3,
                        subHeading:
                            "If your loved one is in danger,\n they can send an emergency alert with their location\n and a pre-set message directly to you.",
                      ),
                      CustomOnpordingPageView(
                        heading: "Welcome to Sight Mate!",
                        image: AppAssets.onbording4,
                        subHeading:
                            "take care of your loved ones and\n get some peace of mind",
                      ),

                      //
                      CustomOnpordingPageView(
                        heading: "Identify Your Surroundings",
                        subHeading:
                            "Point your phone at objects,\n and Sight Mate will describe them to you.\n This helps you know what’s around you",
                      ),
                      CustomOnpordingPageView(
                        heading: "Safety First",
                        subHeading:
                            "In an emergency, press the power button\n twice to send your location to your trusted contacts.",
                      ),
                      CustomOnpordingPageView(
                        heading: "Your Privacy is Our Priority",
                        subHeading:
                            "At Sight Mate, we are committed to protecting\nyour privacy.Your location will only be shared with trusted contacts and only with \nyour permission.",
                      ),
                      CustomOnpordingPageView(
                        heading: "Your Guide Starts Here",
                        subHeading:
                            "\ntake care of your loved ones and\n get some peace of mind",
                      ),
                    ],
                  ),
                ),
                Center(
                  child: CustomGeneralButton(
                    width: 200.w,
                    text: (_currentPage == 3 || _currentPage == 6)
                        ? "Get Started"
                        : "Next",
                    onTap: () {
                      if (_currentPage < 6) {
                        _pageController1.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        GoRouter.of(context)
                            .pushReplacement(AppRouter.kLoginView);
                        CacheData.setData(
                            key: AppCacheData.isOnBordingFinshed, value: true);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 22.h,
                ),
                if (_currentPage < 3)
                  Center(child: OnBordingDots(index: _currentPage.clamp(0, 2))),
                if (_currentPage > 3 && _currentPage < 6)
                  Center(
                      child:
                          OnBordingDots(index: (_currentPage - 4).clamp(0, 2))),
                if (_currentPage > 3)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        AppAssets.mic,
                        height: 24.h,
                      ),
                      SvgPicture.asset(
                        AppAssets.volume,
                        height: 24.h,
                      ),
                    ],
                  ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomOnpordingPageView extends StatelessWidget {
  const CustomOnpordingPageView(
      {super.key, this.heading, this.subHeading, this.image});
  final String? heading, subHeading, image;

  @override
  Widget build(BuildContext context) {
    return image != null
        ? Column(
            children: [
              Text(
                heading!,
                style: const TextStyle(
                    color: AppColors.white, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              SizedBox(height: 200.h, child: LottieBuilder.asset(image!)),
              SizedBox(height: 270.h),
              Text(subHeading!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.primaryBlueColor,
                      fontWeight: FontWeight.w500)),
            ],
          )
        : Column(
            children: [
              SizedBox(height: 120.h),
              Text(
                heading!,
                style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 362.h),
              Text(
                subHeading!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.primaryBlueColor,
                    fontWeight: FontWeight.w500),
              ),
            ],
          );
  }
}
