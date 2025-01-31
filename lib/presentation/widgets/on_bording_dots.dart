
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class OnBordingDots extends StatelessWidget {
  const OnBordingDots({
    super.key,
    required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      right: 0,
      left: 0,
      child: DotsIndicator(
        dotsCount: 3,
        position: index,
        decorator: const DotsDecorator(
            activeSize: Size(13.0, 12.0),
            color: Colors.black87, // Inactive color
            activeColor: AppColors.primaryBlueColor),
      ),
    );
  }
}
