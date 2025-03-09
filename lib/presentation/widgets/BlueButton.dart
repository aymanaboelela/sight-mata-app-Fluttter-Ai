
import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';

class BlueButton extends StatelessWidget {
  final String teks;
  final double padding;
  final VoidCallback onPressed;

  const BlueButton({
    Key? key,
    required this.teks,
    required this.padding,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlueColor, // اللون الأزرق للزر
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // حواف دائرية
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50), // حواف الزر
        ),
        child: Text(
          teks,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
