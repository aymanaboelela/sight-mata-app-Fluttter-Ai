import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/animations.dart';

class MyCircularLoadingIndicator extends StatelessWidget {
  const MyCircularLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: kIsWeb
          ? const Center(
              child: Text(
                "Loading...",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Lottie.asset(LottieAnimationManager.loading),
    );
  }
}

class MyLinearLoadingIndicator extends StatelessWidget {
  const MyLinearLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      color: Colors.blue,
      backgroundColor: Colors.blue.withOpacity(0.1),
    );
  }
}
