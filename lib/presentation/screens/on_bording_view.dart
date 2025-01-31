import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/presentation/widgets/on_bording_back_round.dart';
import 'package:sight_mate_app/presentation/widgets/on_bording_dots.dart';

import '../../core/widgets/custom_buttons.dart';

class OnBordingView extends StatefulWidget {
  const OnBordingView({super.key});

  @override
  State<OnBordingView> createState() => _OnBordingViewState();
}

int index = 0;

class _OnBordingViewState extends State<OnBordingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const OnbordingBackGround(),
          Positioned(
              top: 50.h,
              right: 20,
              child: InkWell(
                onTap: () {},
                child: const Text(
                  "Skip",
                  style: TextStyle(color: AppColors.white),
                ),
              )),
          Positioned(
            bottom: 80,
            right: 140,
            left: 140,
            child: CustomGeneralButton(
              text: "Next",
              onTap: () {
                index++;
                setState(() {});
              },
            ),
          ),
          OnBordingDots(
            index: index,
          ),
        ],
      ),
    );
  }
}
