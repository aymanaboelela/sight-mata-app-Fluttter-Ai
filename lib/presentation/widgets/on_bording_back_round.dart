import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';

class OnbordingBackGround extends StatelessWidget {
  const OnbordingBackGround({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.primaryBlueColor,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.53,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(370),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
